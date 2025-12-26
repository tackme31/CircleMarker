import 'package:circle_marker/viewModels/circle_view_model.dart';
import 'package:circle_marker/views/widgets/circle_box.dart';
import 'package:circle_marker/views/widgets/draggable_line.dart';
import 'package:circle_marker/views/widgets/pixel_positioned.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// 個別サークルマーカーを管理する ConsumerWidget
///
/// Riverpod Family パターンを使用して、各サークルを独立して管理します。
/// これにより、1つのサークル更新時に他のサークルが再描画されることを防ぎます。
class CircleMarker extends ConsumerWidget {
  const CircleMarker({
    super.key,
    required this.circleId,
    required this.imageOriginalSize,
    required this.imageDisplaySize,
    required this.dragIconScale,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  final int circleId;
  final Size imageOriginalSize;
  final Size imageDisplaySize;
  final double dragIconScale;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final circleAsync = ref.watch(circleViewModelProvider(circleId));

    return circleAsync.when(
      data: (circle) {
        return Opacity(
          opacity: isSelected ? 1.0 : 0.5,
          child: Stack(
            children: [
              // ポインターライン
              DraggableLine(
                startPixelX: circle.positionX! + circle.sizeWidth! ~/ 2,
                startPixelY: circle.positionY! + circle.sizeHeight! ~/ 2,
                endPixelX: circle.pointerX!,
                endPixelY: circle.pointerY!,
                imageOriginalSize: imageOriginalSize,
                imageDisplaySize: imageDisplaySize,
                dragIconScale: dragIconScale,
                showIcon: isSelected,
                onEndPointDragEnd: (newEndX, newEndY) {
                  ref
                      .read(circleViewModelProvider(circleId).notifier)
                      .updatePointer(newEndX, newEndY);
                },
              ),
              // サークルボックス
              PixelPositioned(
                pixelX: circle.positionX!,
                pixelY: circle.positionY!,
                imageDisplaySize: imageDisplaySize,
                imageOriginalSize: imageOriginalSize,
                onTap: onTap,
                onDragEnd: (x, y) async {
                  await ref
                      .read(circleViewModelProvider(circleId).notifier)
                      .updatePosition(x, y);
                },
                child: Container(
                  color: Colors.white.withValues(alpha: 0.7),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleBox(
                        circle: circle,
                        imageDisplaySize: imageDisplaySize,
                        imageOriginalSize: imageOriginalSize,
                        onLongPress: onLongPress,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const Icon(Icons.error, color: Colors.red),
    );
  }
}
