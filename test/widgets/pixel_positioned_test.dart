import 'package:circle_marker/views/widgets/pixel_positioned.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PixelPositioned', () {
    testWidgets('converts pixel coordinates to display coordinates on init',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                PixelPositioned(
                  pixelX: 500,
                  pixelY: 500,
                  imageOriginalSize: const Size(1000, 1000),
                  imageDisplaySize: const Size(500, 500),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // TODO: 実装してください
      // 期待値: displayX = 500 * 0.5 = 250, displayY = 500 * 0.5 = 250
      fail('Not implemented yet');
    });

    testWidgets('handles aspect ratio mismatch correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                PixelPositioned(
                  pixelX: 1000,
                  pixelY: 250,
                  imageOriginalSize: const Size(2000, 500), // 横長画像
                  imageDisplaySize: const Size(400, 400), // 正方形ディスプレイ
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // TODO: 実装してください
      // BoxFit.contain に基づいた座標変換を確認
      fail('Not implemented yet');
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapCallCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                PixelPositioned(
                  pixelX: 100,
                  pixelY: 100,
                  imageOriginalSize: const Size(1000, 1000),
                  imageDisplaySize: const Size(500, 500),
                  onTap: () => tapCallCount++,
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // TODO: 実装してください
      fail('Not implemented yet');
    });

    testWidgets('updates position during drag', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                PixelPositioned(
                  pixelX: 100,
                  pixelY: 100,
                  imageOriginalSize: const Size(1000, 1000),
                  imageDisplaySize: const Size(500, 500),
                  child: Container(
                    key: const Key('draggable'),
                    width: 50,
                    height: 50,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // TODO: 実装してください
      // ドラッグして位置が更新されることを確認
      fail('Not implemented yet');
    });

    testWidgets('calls onDragEnd with pixel coordinates', (tester) async {
      int? finalPixelX;
      int? finalPixelY;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                PixelPositioned(
                  pixelX: 100,
                  pixelY: 100,
                  imageOriginalSize: const Size(1000, 1000),
                  imageDisplaySize: const Size(500, 500),
                  onDragEnd: (x, y) {
                    finalPixelX = x;
                    finalPixelY = y;
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // TODO: 実装してください
      // ドラッグ後、逆変換されたピクセル座標が onDragEnd に渡されることを確認
      fail('Not implemented yet');
    });

    testWidgets('updates position when widget is rebuilt with new coordinates',
        (tester) async {
      // 初期状態
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                PixelPositioned(
                  pixelX: 100,
                  pixelY: 100,
                  imageOriginalSize: const Size(1000, 1000),
                  imageDisplaySize: const Size(500, 500),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // 新しい座標で再ビルド
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                PixelPositioned(
                  pixelX: 200,
                  pixelY: 200,
                  imageOriginalSize: const Size(1000, 1000),
                  imageDisplaySize: const Size(500, 500),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // TODO: 実装してください
      fail('Not implemented yet');
    });

    testWidgets('recalculates position when image size changes',
        (tester) async {
      // 初期状態
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                PixelPositioned(
                  pixelX: 500,
                  pixelY: 500,
                  imageOriginalSize: const Size(1000, 1000),
                  imageDisplaySize: const Size(500, 500),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // ディスプレイサイズ変更
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                PixelPositioned(
                  pixelX: 500,
                  pixelY: 500,
                  imageOriginalSize: const Size(1000, 1000),
                  imageDisplaySize: const Size(1000, 1000), // サイズ変更
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // TODO: 実装してください
      // スケールが変わるので、表示座標も変わるはず
      fail('Not implemented yet');
    });
  });
}
