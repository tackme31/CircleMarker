import 'package:flutter/material.dart';
import 'package:circle_marker/utils/coordinate_converter.dart';

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
    this.draggingStartDisplayPosition,
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
  final Offset? draggingStartDisplayPosition;

  @override
  State<DraggableLine> createState() => _DraggableLineState();
}

class _DraggableLineState extends State<DraggableLine> {
  late Offset _endPosition;
  late CoordinateConverter _converter;

  @override
  void initState() {
    super.initState();
    _converter = CoordinateConverter(
      imageSize: widget.imageOriginalSize,
      containerSize: widget.imageDisplaySize,
    );
    _endPosition = _converter.pixelToDisplayInt(
      widget.endPixelX,
      widget.endPixelY,
    );
  }

  @override
  void didUpdateWidget(covariant DraggableLine oldWidget) {
    super.didUpdateWidget(oldWidget);
    // サイズが変更された場合、converter を再作成
    if (oldWidget.imageOriginalSize != widget.imageOriginalSize ||
        oldWidget.imageDisplaySize != widget.imageDisplaySize) {
      _converter = CoordinateConverter(
        imageSize: widget.imageOriginalSize,
        containerSize: widget.imageDisplaySize,
      );
    }
    // 外部からendPixelが更新された場合も表示座標を更新
    if (oldWidget.endPixelX != widget.endPixelX ||
        oldWidget.endPixelY != widget.endPixelY) {
      _endPosition = _converter.pixelToDisplayInt(
        widget.endPixelX,
        widget.endPixelY,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ドラッグ中ならdraggingStartDisplayPositionを使用、そうでなければピクセル座標から計算
    final start =
        widget.draggingStartDisplayPosition ??
        _converter.pixelToDisplayInt(widget.startPixelX, widget.startPixelY);

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
                  final newPixel = _converter.displayToPixelRounded(
                    _endPosition,
                  );
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
