import 'package:flutter/material.dart';

class PixelPositioned extends StatefulWidget {
  final int pixelX;
  final int pixelY;
  final Size imageOriginalSize;
  final Size imageDisplaySize;
  final Widget child;

  final void Function(int newPixelX, int newPixelY)? onDragEnd;

  const PixelPositioned({
    super.key,
    required this.pixelX,
    required this.pixelY,
    required this.imageOriginalSize,
    required this.imageDisplaySize,
    required this.child,
    this.onDragEnd,
  });

  @override
  State<PixelPositioned> createState() => _PixelPositionedState();
}

class _PixelPositionedState extends State<PixelPositioned> {
  late double _currentDisplayX;
  late double _currentDisplayY;

  Offset _calcDisplayOffset(int pixelX, int pixelY) {
    final imageAspect =
        widget.imageOriginalSize.width / widget.imageOriginalSize.height;
    final stackAspect =
        widget.imageDisplaySize.width / widget.imageDisplaySize.height;

    double displayWidth, displayHeight;
    double offsetX = 0, offsetY = 0;

    if (imageAspect > stackAspect) {
      displayWidth = widget.imageDisplaySize.width;
      displayHeight = displayWidth / imageAspect;
      offsetY = (widget.imageDisplaySize.height - displayHeight) / 2;
    } else {
      displayHeight = widget.imageDisplaySize.height;
      displayWidth = displayHeight * imageAspect;
      offsetX = (widget.imageDisplaySize.width - displayWidth) / 2;
    }

    final displayX =
        pixelX * (displayWidth / widget.imageOriginalSize.width) + offsetX;
    final displayY =
        pixelY * (displayHeight / widget.imageOriginalSize.height) + offsetY;

    return Offset(displayX, displayY);
  }

  @override
  void initState() {
    super.initState();
    final pos = _calcDisplayOffset(widget.pixelX, widget.pixelY);
    _currentDisplayX = pos.dx;
    _currentDisplayY = pos.dy;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _currentDisplayX,
      top: _currentDisplayY,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _currentDisplayX += details.delta.dx;
            _currentDisplayY += details.delta.dy;
          });
        },
        onPanEnd: (details) {
          if (widget.onDragEnd != null) {
            // 表示座標をピクセル座標に逆変換
            final newPixelX =
                ((_currentDisplayX - _calcDisplayOffset(0, 0).dx) *
                        (widget.imageOriginalSize.width /
                            widget.imageDisplaySize.width))
                    .round();
            final newPixelY =
                ((_currentDisplayY - _calcDisplayOffset(0, 0).dy) *
                        (widget.imageOriginalSize.height /
                            widget.imageDisplaySize.height))
                    .round();

            widget.onDragEnd!(newPixelX, newPixelY);
          }
        },
        child: widget.child,
      ),
    );
  }
}
