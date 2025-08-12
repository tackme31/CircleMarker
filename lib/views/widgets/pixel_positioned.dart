import 'package:flutter/material.dart';

class PixelPositioned extends StatelessWidget {
  final double pixelX;
  final double pixelY;
  final Size imageOriginalSize;
  final Size imageDisplaySize;
  final Widget child;

  const PixelPositioned({
    super.key,
    required this.pixelX,
    required this.pixelY,
    required this.imageOriginalSize,
    required this.imageDisplaySize,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // 画像ピクセル座標→Stack内座標に変換
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

    return Positioned(left: displayX, top: displayY, child: child);
  }
}
