import 'package:flutter/material.dart';

class LineBetweenPixels extends StatelessWidget {
  final int startPixelX;
  final int startPixelY;
  final int endPixelX;
  final int endPixelY;
  final Size imageOriginalSize;
  final Size imageDisplaySize;
  final Color color;
  final double strokeWidth;

  const LineBetweenPixels({
    super.key,
    required this.startPixelX,
    required this.startPixelY,
    required this.endPixelX,
    required this.endPixelY,
    required this.imageOriginalSize,
    required this.imageDisplaySize,
    this.color = Colors.red,
    this.strokeWidth = 2,
  });

  Offset _pixelToDisplayOffset(int pixelX, int pixelY) {
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

    final displayX = pixelX * (displayWidth / imageOriginalSize.width) + offsetX;
    final displayY = pixelY * (displayHeight / imageOriginalSize.height) + offsetY;

    return Offset(displayX, displayY);
  }

  @override
  Widget build(BuildContext context) {
    final start = _pixelToDisplayOffset(startPixelX, startPixelY);
    final end = _pixelToDisplayOffset(endPixelX, endPixelY);

    return CustomPaint(
      size: imageDisplaySize,
      painter: _LinePainter(
        start: start,
        end: end,
        color: color,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final Color color;
  final double strokeWidth;

  _LinePainter({
    required this.start,
    required this.end,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(_LinePainter oldDelegate) {
    return oldDelegate.start != start || oldDelegate.end != end;
  }
}
