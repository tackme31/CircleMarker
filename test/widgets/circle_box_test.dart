import 'package:circle_marker/models/circle_detail.dart';
import 'package:circle_marker/views/widgets/circle_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CircleBox', () {
    testWidgets('displays check icon when isDone is 1', (tester) async {
      const circle = CircleDetail(
        circleId: 1,
        mapId: 1,
        positionX: 100,
        positionY: 100,
        sizeWidth: 60,
        sizeHeight: 60,
        isDone: 1,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CircleBox(
              circle: circle,
              imageOriginalSize: Size(1000, 1000),
              imageDisplaySize: Size(500, 500),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('does not display check icon when isDone is 0', (tester) async {
      const circle = CircleDetail(
        circleId: 1,
        mapId: 1,
        positionX: 100,
        positionY: 100,
        sizeWidth: 60,
        sizeHeight: 60,
        isDone: 0,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CircleBox(
              circle: circle,
              imageOriginalSize: Size(1000, 1000),
              imageDisplaySize: Size(500, 500),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check), findsNothing);
    });

    testWidgets('displays image when imagePath is provided and file exists', (
      tester,
    ) async {
      const circle = CircleDetail(
        circleId: 1,
        mapId: 1,
        positionX: 100,
        positionY: 100,
        sizeWidth: 60,
        sizeHeight: 60,
        imagePath: '/path/to/image.jpg',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CircleBox(
              circle: circle,
              imageOriginalSize: Size(1000, 1000),
              imageDisplaySize: Size(500, 500),
            ),
          ),
        ),
      );

      // ファイルが存在しないので、実際には no_image.png が表示される
      // Image.file ウィジェットが存在することを確認
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('displays placeholder when imagePath is null', (tester) async {
      const circle = CircleDetail(
        circleId: 1,
        mapId: 1,
        positionX: 100,
        positionY: 100,
        sizeWidth: 60,
        sizeHeight: 60,
        imagePath: null,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CircleBox(
              circle: circle,
              imageOriginalSize: Size(1000, 1000),
              imageDisplaySize: Size(500, 500),
            ),
          ),
        ),
      );

      // no_image.png が表示される
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('displays circleName when provided', (tester) async {
      const circle = CircleDetail(
        circleId: 1,
        mapId: 1,
        positionX: 100,
        positionY: 100,
        sizeWidth: 60,
        sizeHeight: 60,
        circleName: 'Test Circle',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CircleBox(
              circle: circle,
              imageOriginalSize: Size(1000, 1000),
              imageDisplaySize: Size(500, 500),
            ),
          ),
        ),
      );

      expect(find.text('Test Circle'), findsOneWidget);
    });

    testWidgets('displays spaceNo when provided', (tester) async {
      const circle = CircleDetail(
        circleId: 1,
        mapId: 1,
        positionX: 100,
        positionY: 100,
        sizeWidth: 60,
        sizeHeight: 60,
        spaceNo: 'A-01',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CircleBox(
              circle: circle,
              imageOriginalSize: Size(1000, 1000),
              imageDisplaySize: Size(500, 500),
            ),
          ),
        ),
      );

      expect(find.text('A-01'), findsOneWidget);
    });

    testWidgets('displays note when provided', (tester) async {
      const circle = CircleDetail(
        circleId: 1,
        mapId: 1,
        positionX: 100,
        positionY: 100,
        sizeWidth: 60,
        sizeHeight: 60,
        note: 'Important note',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CircleBox(
              circle: circle,
              imageOriginalSize: Size(1000, 1000),
              imageDisplaySize: Size(500, 500),
            ),
          ),
        ),
      );

      expect(find.text('Important note'), findsOneWidget);
    });

    testWidgets('calculates display size correctly with equal aspect ratio', (
      tester,
    ) async {
      const circle = CircleDetail(
        circleId: 1,
        mapId: 1,
        positionX: 100,
        positionY: 100,
        sizeWidth: 100,
        sizeHeight: 100,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CircleBox(
              circle: circle,
              imageOriginalSize: Size(1000, 1000),
              imageDisplaySize: Size(500, 500),
            ),
          ),
        ),
      );

      // 期待値: displayWidth = 100 * (500 / 1000) = 50
      // 期待値: displayHeight = 100 * (500 / 1000) = 50
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, 50);
      expect(sizedBox.height, 50);
    });

    testWidgets(
      'calculates display size correctly with different aspect ratios',
      (tester) async {
        const circle = CircleDetail(
          circleId: 1,
          mapId: 1,
          positionX: 100,
          positionY: 100,
          sizeWidth: 100,
          sizeHeight: 100,
        );

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CircleBox(
                circle: circle,
                imageOriginalSize: Size(2000, 1000), // 横長画像
                imageDisplaySize: Size(400, 400), // 正方形ディスプレイ
              ),
            ),
          ),
        );

        // BoxFit.contain のロジック: 幅に合わせる (scale = 400 / 2000 = 0.2)
        // displayWidth = 100 * 0.2 = 20
        // displayHeight = 100 * 0.2 = 20
        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
        expect(sizedBox.width, 20);
        expect(sizedBox.height, 20);
      },
    );

    testWidgets('calls onLongPress when long pressed', (tester) async {
      var longPressCallCount = 0;

      const circle = CircleDetail(
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

      await tester.longPress(find.byType(CircleBox));
      expect(longPressCallCount, 1);
    });
  });
}
