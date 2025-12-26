import 'package:circle_marker/models/circle_detail.dart';
import 'package:circle_marker/views/widgets/circle_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CircleBox', () {
    testWidgets('displays check icon when isDone is 1', (tester) async {
      final circle = CircleDetail(
        circleId: 1,
        mapId: 1,
        positionX: 100,
        positionY: 100,
        sizeWidth: 60,
        sizeHeight: 60,
        isDone: 1,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CircleBox(
              circle: circle,
              imageOriginalSize: const Size(1000, 1000),
              imageDisplaySize: const Size(500, 500),
            ),
          ),
        ),
      );

      // TODO: 実装してください
      fail('Not implemented yet');
    });

    testWidgets('does not display check icon when isDone is 0', (tester) async {
      final circle = CircleDetail(
        circleId: 1,
        mapId: 1,
        positionX: 100,
        positionY: 100,
        sizeWidth: 60,
        sizeHeight: 60,
        isDone: 0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CircleBox(
              circle: circle,
              imageOriginalSize: const Size(1000, 1000),
              imageDisplaySize: const Size(500, 500),
            ),
          ),
        ),
      );

      // TODO: 実装してください
      fail('Not implemented yet');
    });

    testWidgets('displays image when imagePath is provided and file exists',
        (tester) async {
      final circle = CircleDetail(
        circleId: 1,
        mapId: 1,
        positionX: 100,
        positionY: 100,
        sizeWidth: 60,
        sizeHeight: 60,
        imagePath: '/path/to/image.jpg',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CircleBox(
              circle: circle,
              imageOriginalSize: const Size(1000, 1000),
              imageDisplaySize: const Size(500, 500),
            ),
          ),
        ),
      );

      // TODO: 実装してください（ファイルモックが必要）
      fail('Not implemented yet - requires file mocking');
    });

    testWidgets('displays placeholder when imagePath is null', (tester) async {
      final circle = CircleDetail(
        circleId: 1,
        mapId: 1,
        positionX: 100,
        positionY: 100,
        sizeWidth: 60,
        sizeHeight: 60,
        imagePath: null,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CircleBox(
              circle: circle,
              imageOriginalSize: const Size(1000, 1000),
              imageDisplaySize: const Size(500, 500),
            ),
          ),
        ),
      );

      // TODO: 実装してください
      fail('Not implemented yet');
    });

    testWidgets('displays circleName when provided', (tester) async {
      final circle = CircleDetail(
        circleId: 1,
        mapId: 1,
        positionX: 100,
        positionY: 100,
        sizeWidth: 60,
        sizeHeight: 60,
        circleName: 'Test Circle',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CircleBox(
              circle: circle,
              imageOriginalSize: const Size(1000, 1000),
              imageDisplaySize: const Size(500, 500),
            ),
          ),
        ),
      );

      // TODO: 実装してください
      fail('Not implemented yet');
    });

    testWidgets('displays spaceNo when provided', (tester) async {
      final circle = CircleDetail(
        circleId: 1,
        mapId: 1,
        positionX: 100,
        positionY: 100,
        sizeWidth: 60,
        sizeHeight: 60,
        spaceNo: 'A-01',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CircleBox(
              circle: circle,
              imageOriginalSize: const Size(1000, 1000),
              imageDisplaySize: const Size(500, 500),
            ),
          ),
        ),
      );

      // TODO: 実装してください
      fail('Not implemented yet');
    });

    testWidgets('displays note when provided', (tester) async {
      final circle = CircleDetail(
        circleId: 1,
        mapId: 1,
        positionX: 100,
        positionY: 100,
        sizeWidth: 60,
        sizeHeight: 60,
        note: 'Important note',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CircleBox(
              circle: circle,
              imageOriginalSize: const Size(1000, 1000),
              imageDisplaySize: const Size(500, 500),
            ),
          ),
        ),
      );

      // TODO: 実装してください
      fail('Not implemented yet');
    });

    testWidgets('calculates display size correctly with equal aspect ratio',
        (tester) async {
      final circle = CircleDetail(
        circleId: 1,
        mapId: 1,
        positionX: 100,
        positionY: 100,
        sizeWidth: 100,
        sizeHeight: 100,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CircleBox(
              circle: circle,
              imageOriginalSize: const Size(1000, 1000),
              imageDisplaySize: const Size(500, 500),
            ),
          ),
        ),
      );

      // TODO: 実装してください
      // 期待値: displayWidth = 100 * (500 / 1000) = 50
      // 期待値: displayHeight = 100 * (500 / 1000) = 50
      fail('Not implemented yet');
    });

    testWidgets('calculates display size correctly with different aspect ratios',
        (tester) async {
      final circle = CircleDetail(
        circleId: 1,
        mapId: 1,
        positionX: 100,
        positionY: 100,
        sizeWidth: 100,
        sizeHeight: 100,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CircleBox(
              circle: circle,
              imageOriginalSize: const Size(2000, 1000), // 横長画像
              imageDisplaySize: const Size(400, 400), // 正方形ディスプレイ
            ),
          ),
        ),
      );

      // TODO: 実装してください
      // BoxFit.contain のロジックに基づいた計算が必要
      fail('Not implemented yet');
    });

    testWidgets('calls onLongPress when long pressed', (tester) async {
      var longPressCallCount = 0;

      final circle = CircleDetail(
        circleId: 1,
        mapId: 1,
        positionX: 100,
        positionY: 100,
        sizeWidth: 60,
        sizeHeight: 60,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CircleBox(
              circle: circle,
              imageOriginalSize: const Size(1000, 1000),
              imageDisplaySize: const Size(500, 500),
              onLongPress: () => longPressCallCount++,
            ),
          ),
        ),
      );

      // TODO: 実装してください
      fail('Not implemented yet');
    });
  });
}
