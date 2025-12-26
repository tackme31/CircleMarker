import 'package:flutter/material.dart';
import 'package:circle_marker/utils/coordinate_converter.dart';

class PixelPositioned extends StatefulWidget {
  const PixelPositioned({
    super.key,
    required this.pixelX,
    required this.pixelY,
    required this.imageOriginalSize,
    required this.imageDisplaySize,
    required this.child,
    this.onDragEnd,
    this.onTap,
  });

  final int pixelX;
  final int pixelY;
  final Size imageOriginalSize;
  final Size imageDisplaySize;
  final Widget child;

  final void Function(int newPixelX, int newPixelY)? onDragEnd;
  final void Function()? onTap;

  @override
  State<PixelPositioned> createState() => _PixelPositionedState();
}

class _PixelPositionedState extends State<PixelPositioned> {
  late double _currentDisplayX;
  late double _currentDisplayY;
  late CoordinateConverter _converter;

  @override
  void initState() {
    super.initState();
    _converter = CoordinateConverter(
      imageSize: widget.imageOriginalSize,
      containerSize: widget.imageDisplaySize,
    );
    final pos = _converter.pixelToDisplayInt(widget.pixelX, widget.pixelY);
    _currentDisplayX = pos.dx;
    _currentDisplayY = pos.dy;
  }

  @override
  void didUpdateWidget(PixelPositioned oldWidget) {
    super.didUpdateWidget(oldWidget);
    // サイズが変更された場合、converter を再作成
    if (oldWidget.imageOriginalSize != widget.imageOriginalSize ||
        oldWidget.imageDisplaySize != widget.imageDisplaySize) {
      _converter = CoordinateConverter(
        imageSize: widget.imageOriginalSize,
        containerSize: widget.imageDisplaySize,
      );
      final pos = _converter.pixelToDisplayInt(widget.pixelX, widget.pixelY);
      _currentDisplayX = pos.dx;
      _currentDisplayY = pos.dy;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _currentDisplayX,
      top: _currentDisplayY,
      child: GestureDetector(
        onTap: () => widget.onTap?.call(),
        onPanUpdate: (details) {
          setState(() {
            _currentDisplayX += details.delta.dx;
            _currentDisplayY += details.delta.dy;
          });
        },
        onPanEnd: (details) {
          if (widget.onDragEnd != null) {
            // 表示座標をピクセル座標に逆変換
            final currentDisplayPosition =
                Offset(_currentDisplayX, _currentDisplayY);
            final pixelPosition =
                _converter.displayToPixelRounded(currentDisplayPosition);

            widget.onDragEnd!(
              pixelPosition.dx.toInt(),
              pixelPosition.dy.toInt(),
            );
          }
        },
        child: widget.child,
      ),
    );
  }
}
