import 'dart:io';

import 'package:circle_marker/viewModels/map_detail_view_model.dart';
import 'package:circle_marker/views/widgets/circle_box.dart';
import 'package:circle_marker/views/widgets/line_between_pixels.dart';
import 'package:circle_marker/views/widgets/pixel_positioned.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MapDetailScreen extends ConsumerStatefulWidget {
  const MapDetailScreen({super.key, required this.mapId});

  final int mapId;

  @override
  ConsumerState<MapDetailScreen> createState() => _MapDetailScreenState();
}

class _MapDetailScreenState extends ConsumerState<MapDetailScreen> {
  final TransformationController _controller = TransformationController();
  Offset? _lastImagePixel;

  void _onDoubleTap(
    BuildContext context,
    TapDownDetails details,
    Size stackSize,
    Size imageOriginalSize,
  ) {
    // Stack内でfit: BoxFit.containで画像が表示されるサイズを計算
    final imageAspect = imageOriginalSize.width / imageOriginalSize.height;
    final stackAspect = stackSize.width / stackSize.height;

    double displayWidth, displayHeight;
    double offsetX = 0, offsetY = 0;

    if (imageAspect > stackAspect) {
      displayWidth = stackSize.width;
      displayHeight = displayWidth / imageAspect;
      offsetY = (stackSize.height - displayHeight) / 2;
    } else {
      displayHeight = stackSize.height;
      displayWidth = displayHeight * imageAspect;
      offsetX = (stackSize.width - displayWidth) / 2;
    }

    // InteractiveViewerの変換行列
    final matrix = _controller.value;
    final scale = matrix.getMaxScaleOnAxis();
    final pan = Offset(matrix.row0[3], matrix.row1[3]);

    // 1. panを引く
    final pos1 = details.localPosition - pan;
    // 2. scaleで割る
    final pos2 = pos1 / scale;
    // 3. 画像の余白を引く
    final imageLocal = pos2 - Offset(offsetX, offsetY);

    // 画像表示サイズ→画像ピクセル座標へ変換
    final imgX = imageLocal.dx * (imageOriginalSize.width / displayWidth);
    final imgY = imageLocal.dy * (imageOriginalSize.height / displayHeight);

    setState(() {
      _lastImagePixel = Offset(imgX, imgY);
    });
  }

  Offset _imagePixelToDisplayOffset({
    required double pixelX,
    required double pixelY,
    required Size imageDisplaySize,
    required Size imageOriginalSize,
  }) {
    final imageAspect = imageOriginalSize.width / imageOriginalSize.height;
    final stackAspect = imageDisplaySize.width / imageDisplaySize.height;

    double displayWidth, displayHeight;
    double offsetX = 0, offsetY = 0;

    if (imageAspect > stackAspect) {
      displayWidth = imageDisplaySize.width;
      displayHeight = displayWidth / imageAspect;
      offsetY = (imageDisplaySize.height - displayHeight) / 2;
    } else {
      displayHeight = imageDisplaySize.height;
      displayWidth = displayHeight * imageAspect;
      offsetX = (imageDisplaySize.width - displayWidth) / 2;
    }

    final displayX =
        pixelX * (displayWidth / imageOriginalSize.width) + offsetX;
    final displayY =
        pixelY * (displayHeight / imageOriginalSize.height) + offsetY;

    return Offset(displayX, displayY);
  }

  void _onDragEnd(int newPixelX, int newPixelY, int circleId) {
    // foobar
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mapDetailViewModelProvider(widget.mapId));

    return Scaffold(
      appBar: AppBar(
        title: switch (state) {
          AsyncData(:final value) when value.mapDetail.title != null => Text(
            //value.mapDetail!.title!,
            _lastImagePixel != null
                ? '${value.mapDetail.title!} (${_lastImagePixel!.dx.toStringAsFixed(1)}, ${_lastImagePixel!.dy.toStringAsFixed(1)})'
                : value.mapDetail.title!,
          ),
          AsyncError() => const Text('Error'),
          _ => const Text('No title'),
        },
      ),
      body: switch (state) {
        AsyncData(:final value) => Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Stackの表示サイズ
                  final imageDisplaySize = Size(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );
                  return GestureDetector(
                    onDoubleTapDown: (details) => _onDoubleTap(
                      context,
                      details,
                      imageDisplaySize,
                      value.baseImageSize,
                    ),
                    child: InteractiveViewer(
                      transformationController: _controller,
                      minScale: 0.5,
                      maxScale: 10.0,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.file(
                              value.baseImage,
                              fit: BoxFit.contain,
                            ),
                          ),
                          ...value.circles.map((circle) {
                            return Stack(
                              children: [
                                IgnorePointer(
                                  child: LineBetweenPixels(
                                    startPixelX: circle.positionX! + circle.sizeWidth! ~/ 2,
                                    startPixelY: circle.positionY! + circle.sizeHeight! ~/ 2,
                                    endPixelX: 1000,
                                    endPixelY: 1000,
                                    imageOriginalSize: value.baseImageSize,
                                    imageDisplaySize: imageDisplaySize,
                                    color: Colors.blue,
                                    strokeWidth: 3,
                                  ),
                                ),
                                PixelPositioned(
                                  pixelX: circle.positionX!,
                                  pixelY: circle.positionY!,
                                  imageDisplaySize: imageDisplaySize,
                                  imageOriginalSize: value.baseImageSize,
                                  onDragEnd: (x, y) =>
                                      _onDragEnd(x, y, circle.circleId!),
                                  child: CircleBox(
                                    pixelWidth: circle.sizeWidth!,
                                    pixleHeight: circle.sizeHeight!,
                                    imageDisplaySize: imageDisplaySize,
                                    imageOriginalSize: value.baseImageSize,
                                    imagePath: circle.imagePath,
                                  ),
                                ),
                              ],
                            );
                          }),
                          // ここに図形を追加
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        AsyncError(:final error) => Center(
          child: Text('Something went wrong: $error'),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
