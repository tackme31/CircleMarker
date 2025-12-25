import 'dart:io';

import 'package:circle_marker/models/circle_detail.dart';
import 'package:flutter/material.dart';

class CircleBox extends StatelessWidget {
  const CircleBox({
    super.key,
    required this.circle,
    required this.imageOriginalSize,
    required this.imageDisplaySize,
    this.onLongPress,
  });

  final CircleDetail circle;
  final Size imageOriginalSize;
  final Size imageDisplaySize;
  final void Function()? onLongPress;

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
    final displayWidth =
        circle.sizeWidth! * (fittedWidth / imageOriginalSize.width);
    final displayHeight =
        circle.sizeHeight! * (fittedHeight / imageOriginalSize.height);

    final imagePath = circle.imagePath;
    return GestureDetector(
      onLongPress: onLongPress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                width: displayWidth,
                height: displayHeight,
                child: imagePath != null && File(imagePath).existsSync()
                    ? Image.file(File(imagePath), fit: BoxFit.contain)
                    : Image.asset('assets/no_image.png', fit: BoxFit.contain),
              ),
              if (circle.isDone == 1)
                const Positioned(
                  top: -2,
                  right: -2,
                  child: Icon(Icons.check, color: Colors.green, size: 9),
                ),
            ],
          ),
          if (circle.circleName != null && circle.circleName!.isNotEmpty)
            SizedBox(
              width:
                  circle.sizeWidth! *
                  (imageDisplaySize.width / imageOriginalSize.width),
              child: Text(
                circle.circleName!,
                softWrap: true,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize:
                      24 * (imageDisplaySize.width / imageOriginalSize.width),
                ),
              ),
            ),
          if (circle.spaceNo != null && circle.spaceNo!.isNotEmpty)
            SizedBox(
              width:
                  circle.sizeWidth! *
                  (imageDisplaySize.width / imageOriginalSize.width),
              child: Text(
                circle.spaceNo!,
                softWrap: true,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize:
                      24 * (imageDisplaySize.width / imageOriginalSize.width),
                ),
              ),
            ),
          if (circle.note != null && circle.note!.isNotEmpty)
            SizedBox(
              width:
                  circle.sizeWidth! *
                  (imageDisplaySize.width / imageOriginalSize.width),
              child: Text(
                circle.note!,
                softWrap: true,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize:
                      24 * (imageDisplaySize.width / imageOriginalSize.width),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
