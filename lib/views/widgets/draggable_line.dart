import 'package:flutter/material.dart';

class DraggableLine extends StatefulWidget {
  const DraggableLine({
    super.key,
    required this.startPixelX,
    required this.startPixelY,
    required this.endPixelX,
    required this.endPixelY,
    required this.imageOriginalSize,
    required this.imageDisplaySize,
    this.onEndPointDragEnd,
    this.dragIconScale = 1.0,
    required this.showIcon,
  });

  final int startPixelX;
  final int startPixelY;
  final int endPixelX;
  final int endPixelY;
  final Size imageOriginalSize;
  final Size imageDisplaySize;
  final void Function(int newEndX, int newEndY)? onEndPointDragEnd;
  final double dragIconScale;
  final bool showIcon;

  @override
  State<DraggableLine> createState() => _DraggableLineState();
}

class _DraggableLineState extends State<DraggableLine> {
  late Offset _endPosition;

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

  Offset _calcPixelOffset(Offset displayOffset) {
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

    final pixelX =
        ((displayOffset.dx - offsetX) *
                (widget.imageOriginalSize.width / displayWidth))
            .round();
    final pixelY =
        ((displayOffset.dy - offsetY) *
                (widget.imageOriginalSize.height / displayHeight))
            .round();

    return Offset(pixelX.toDouble(), pixelY.toDouble());
  }

  @override
  void initState() {
    super.initState();
    _endPosition = _calcDisplayOffset(widget.endPixelX, widget.endPixelY);
  }

  @override
  void didUpdateWidget(covariant DraggableLine oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 外部からendPixelが更新された場合も表示座標を更新
    if (oldWidget.endPixelX != widget.endPixelX ||
        oldWidget.endPixelY != widget.endPixelY) {
      _endPosition = _calcDisplayOffset(widget.endPixelX, widget.endPixelY);
    }
  }

  @override
  Widget build(BuildContext context) {
    final start = _calcDisplayOffset(widget.startPixelX, widget.startPixelY);

    const iconSize = 24.0;
    final scale = 1 / widget.dragIconScale;
    const fixedDistance = 50.0;

    return Stack(
      children: [
        IgnorePointer(
          child: CustomPaint(
            size: widget.imageDisplaySize,
            painter: _LinePainter(start: start, end: _endPosition),
          ),
        ),
        if (widget.showIcon)
          Positioned(
            left: _endPosition.dx - iconSize / 2,
            top: _endPosition.dy - iconSize / 2 + fixedDistance * scale,
            child: Transform.scale(
              scale: scale,
              alignment: Alignment.center,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _endPosition += details.delta / widget.dragIconScale;
                  });
                },
                onPanEnd: (details) {
                  final newPixel = _calcPixelOffset(_endPosition);
                  widget.onEndPointDragEnd?.call(
                    newPixel.dx.round(),
                    newPixel.dy.round(),
                  );
                },
                child: const Opacity(
                  opacity: 0.65,
                  child: Icon(Icons.open_with, size: 24, color: Colors.red),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _LinePainter extends CustomPainter {
  _LinePainter({required this.start, required this.end});

  final Offset start;
  final Offset end;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red.withAlpha(200)
      ..strokeWidth = 0.6
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant _LinePainter oldDelegate) {
    return oldDelegate.start != start || oldDelegate.end != end;
  }
}
