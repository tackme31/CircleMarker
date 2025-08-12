import 'dart:io';

import 'package:flutter/material.dart';

class CircleBox extends StatelessWidget {
  final int pixelWidth;
  final int pixleHeight;
  final Size imageOriginalSize;
  final Size imageDisplaySize;
  final String? imagePath;
  final void Function()? onLongPress;

  const CircleBox({
    super.key,
    required this.pixelWidth,
    required this.pixleHeight,
    required this.imageOriginalSize,
    required this.imageDisplaySize,
    this.imagePath,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    // 実際の画像表示サイズを計算（BoxFit.contain相当）
    final imageAspect = imageOriginalSize.width / imageOriginalSize.height;
    final displayAspect = imageDisplaySize.width / imageDisplaySize.height;

    double fittedWidth, fittedHeight;
    if (imageAspect > displayAspect) {
      fittedWidth = imageDisplaySize.width;
      fittedHeight = fittedWidth / imageAspect;
    } else {
      fittedHeight = imageDisplaySize.height;
      fittedWidth = fittedHeight * imageAspect;
    }

    // 幅・高さを変換
    final displayWidth = pixelWidth * (fittedWidth / imageOriginalSize.width);
    final displayHeight =
        pixleHeight * (fittedHeight / imageOriginalSize.height);

    return GestureDetector(
      onLongPress: onLongPress,
      child: SizedBox(
        width: displayWidth,
        height: displayHeight,
        child: imagePath != null && File(imagePath!).existsSync()
            ? Image.file(File(imagePath!), fit: BoxFit.contain)
            : Image.asset('assets/no_image.png', fit: BoxFit.contain),
      ),
    );
  }
}
