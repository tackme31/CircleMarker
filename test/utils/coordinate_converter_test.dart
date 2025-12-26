import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:circle_marker/utils/coordinate_converter.dart';

void main() {
  group('CoordinateConverter', () {
    test('converts pixel to display correctly with BoxFit.contain (equal aspect ratio)', () {
      const converter = CoordinateConverter(
        imageSize: Size(1000, 1000),
        containerSize: Size(500, 500),
      );

      expect(converter.scale, 0.5);
      expect(converter.offset, const Offset(0, 0));

      final result = converter.pixelToDisplay(const Offset(500, 500));
      expect(result.dx, 250);
      expect(result.dy, 250);
    });

    test('handles aspect ratio mismatch correctly (wide image in square container)', () {
      const converter = CoordinateConverter(
        imageSize: Size(1000, 500), // 横長画像
        containerSize: Size(400, 400), // 正方形コンテナ
      );

      // 幅に合わせる (400 / 1000 = 0.4)
      expect(converter.scale, 0.4);

      // 実際の表示サイズ: 400 x 200
      expect(converter.displaySize.width, 400);
      expect(converter.displaySize.height, 200);

      // 上下に100pxのオフセット
      expect(converter.offset.dx, 0);
      expect(converter.offset.dy, 100);
    });

    test('handles aspect ratio mismatch correctly (tall image in square container)', () {
      const converter = CoordinateConverter(
        imageSize: Size(500, 1000), // 縦長画像
        containerSize: Size(400, 400), // 正方形コンテナ
      );

      // 高さに合わせる (400 / 1000 = 0.4)
      expect(converter.scale, 0.4);

      // 実際の表示サイズ: 200 x 400
      expect(converter.displaySize.width, 200);
      expect(converter.displaySize.height, 400);

      // 左右に100pxのオフセット
      expect(converter.offset.dx, 100);
      expect(converter.offset.dy, 0);
    });

    test('converts display to pixel correctly', () {
      const converter = CoordinateConverter(
        imageSize: Size(1000, 1000),
        containerSize: Size(500, 500),
      );

      final result = converter.displayToPixel(const Offset(250, 250));
      expect(result.dx, 500);
      expect(result.dy, 500);
    });

    test('pixelToDisplayInt works correctly with integer coordinates', () {
      const converter = CoordinateConverter(
        imageSize: Size(1000, 1000),
        containerSize: Size(500, 500),
      );

      final result = converter.pixelToDisplayInt(500, 500);
      expect(result.dx, 250);
      expect(result.dy, 250);
    });

    test('displayToPixelRounded returns rounded coordinates', () {
      const converter = CoordinateConverter(
        imageSize: Size(1000, 1000),
        containerSize: Size(500, 500),
      );

      // 250.7 -> 501.4 -> rounds to 501
      final result = converter.displayToPixelRounded(const Offset(250.7, 250.7));
      expect(result.dx, 501);
      expect(result.dy, 501);
    });

    test('converts size from pixel to display', () {
      const converter = CoordinateConverter(
        imageSize: Size(1000, 1000),
        containerSize: Size(500, 500),
      );

      final result = converter.sizePixelToDisplay(const Size(100, 100));
      expect(result.width, 50);
      expect(result.height, 50);
    });

    test('converts size from display to pixel', () {
      const converter = CoordinateConverter(
        imageSize: Size(1000, 1000),
        containerSize: Size(500, 500),
      );

      final result = converter.sizeDisplayToPixel(const Size(50, 50));
      expect(result.width, 100);
      expect(result.height, 100);
    });

    test('round-trip conversion maintains approximate values', () {
      const converter = CoordinateConverter(
        imageSize: Size(1000, 1000),
        containerSize: Size(500, 500),
      );

      const originalPixel = Offset(123, 456);
      final display = converter.pixelToDisplay(originalPixel);
      final backToPixel = converter.displayToPixel(display);

      expect(backToPixel.dx, closeTo(originalPixel.dx, 0.001));
      expect(backToPixel.dy, closeTo(originalPixel.dy, 0.001));
    });

    test('handles extreme aspect ratio differences', () {
      const converter = CoordinateConverter(
        imageSize: Size(2000, 500), // 4:1 横長画像
        containerSize: Size(400, 800), // 1:2 縦長コンテナ
      );

      // 幅に合わせる (400 / 2000 = 0.2)
      expect(converter.scale, 0.2);

      // 実際の表示サイズ: 400 x 100
      expect(converter.displaySize.width, 400);
      expect(converter.displaySize.height, 100);

      // 上下に350pxのオフセット
      expect(converter.offset.dx, 0);
      expect(converter.offset.dy, 350);

      // 座標変換のテスト
      final result = converter.pixelToDisplay(const Offset(1000, 250));
      expect(result.dx, 200); // 1000 * 0.2 + 0
      expect(result.dy, 400); // 250 * 0.2 + 350
    });

    test('handles zero coordinate correctly', () {
      const converter = CoordinateConverter(
        imageSize: Size(1000, 500),
        containerSize: Size(400, 400),
      );

      final result = converter.pixelToDisplay(const Offset(0, 0));
      expect(result.dx, converter.offset.dx);
      expect(result.dy, converter.offset.dy);
    });

    test('handles max coordinate correctly', () {
      const converter = CoordinateConverter(
        imageSize: Size(1000, 500),
        containerSize: Size(400, 400),
      );

      final result = converter.pixelToDisplay(const Offset(1000, 500));
      expect(result.dx, closeTo(400, 0.001)); // 画像の右端
      expect(result.dy, closeTo(300, 0.001)); // 画像の下端 (offset.dy + displayHeight)
    });
  });
}
