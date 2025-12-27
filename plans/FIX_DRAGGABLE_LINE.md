# DraggableLine始点追従機能の実装設計

## 1. 現状分析

### 問題の根本原因

現在、DraggableLineの始点がサークル移動時に追従しない理由は以下の通り：

1. **初期化時の座標固定化**
   ```dart
   // draggable_line.dart (initState)
   _startDx = CoordinateConverter.pixelToDisplay(
     widget.circle.positionX,
     widget.imageSize.width,
     widget.displaySize.width,
   );
   _startDy = CoordinateConverter.pixelToDisplay(
     widget.circle.positionY,
     widget.imageSize.height,
     widget.displaySize.height,
   );
   ```
   - `initState()`で一度だけ始点座標を計算し、その後は更新されない
   - `didUpdateWidget()`での条件分岐が`widget.circle != oldWidget.circle`となっており、**Freezedの等価性比較により、位置変更だけでは再初期化されない**

2. **ドラッグ中の更新タイミングの問題**
   ```dart
   // circle_marker.dart (onPanUpdate)
   final newPositionX = oldPosition.dx + delta.dx;
   final newPositionY = oldPosition.dy + delta.dy;

   setState(() {
     localPosition = Offset(newPositionX, newPositionY);
   });

   // onPanEndでのみViewModelを更新
   await ref.read(circleViewModelProvider(circle.id).notifier)
       .updatePosition(pixelX, pixelY);
   ```
   - ドラッグ中は`setState`でローカル状態のみ更新
   - DraggableLineは親ウィジェット（MapDetailScreen）から渡される`circle`データを参照
   - CircleMarkerのローカル状態変更はDraggableLineに伝わらない

3. **ウィジェット構造の問題**
   ```dart
   // map_detail_screen.dart
   Stack(
     children: [
       ...state.circles.map((circle) => DraggableLine(...)),
       ...state.circles.map((circle) => CircleMarker(...)),
     ],
   )
   ```
   - DraggableLineとCircleMarkerは別々のウィジェット
   - CircleMarkerのドラッグ中の位置情報がDraggableLineに共有されていない

### 問題の影響範囲

- **ユーザー体験**: サークルを移動すると線が取り残され、視覚的に不自然
- **一貫性**: 終点はドラッグ中も追従するのに、始点は追従しない
- **実装複雑性**: CircleMarkerとDraggableLineの状態同期が課題

---

## 2. 提案する実装アプローチ

### 🔵 アプローチA: ローカル状態の共有（推奨）

**概要**: CircleMarkerのドラッグ中のローカル位置をDraggableLineに共有

**実装方法**:
1. MapDetailScreenに`Map<int, Offset?> draggingPositions`状態を追加
2. CircleMarkerのonPanUpdate時にこのMapを更新
3. DraggableLineは`draggingPositions[circle.id] ?? circle.position`を使用

**メリット**:
- ✅ リアルタイム追従が実現できる
- ✅ ViewModelへの書き込みは最小限（onPanEndのみ）
- ✅ パフォーマンスへの影響が少ない
- ✅ 既存のアーキテクチャを大きく変更しない

**デメリット**:
- ⚠️ MapDetailScreenの状態管理が複雑化
- ⚠️ 複数サークルの同時ドラッグには対応しづらい

---

### 🟡 アプローチB: ViewModel即時更新

**概要**: ドラッグ中もViewModelを更新し、Riverpod Familyで再描画

**実装方法**:
1. CircleMarkerのonPanUpdate時にViewModelを更新
2. DraggableLineはCircleViewModelを監視し、自動再描画

**メリット**:
- ✅ 状態管理が一元化される
- ✅ undo/redo機能を将来実装しやすい
- ✅ 複数サークルの同時ドラッグにも対応可能

**デメリット**:
- ❌ ドラッグ中に大量のViewModel更新が発生
- ❌ データベース書き込みタイミングの制御が必要
- ❌ パフォーマンス問題の可能性（60fps維持が課題）
- ❌ Riverpod Familyの頻繁な再構築でメモリ増加の懸念

---

### 🔴 アプローチC: DraggableLineをCircleMarkerに統合

**概要**: CircleMarkerがDraggableLineを子として持つ

**実装方法**:
1. CircleMarkerのbuildメソッド内でDraggableLineを生成
2. ローカル状態`localPosition`を直接DraggableLineに渡す

**メリット**:
- ✅ 状態共有が自然
- ✅ リアルタイム追従が保証される

**デメリット**:
- ❌ Stackの描画順序の制御が困難（線が常にサークルの上に描画される）
- ❌ 現在の「線を下、サークルを上」というレイアウトが崩れる
- ❌ アーキテクチャの大幅な変更が必要

---

## 3. 推奨実装: アプローチA（詳細設計）

### 3.1 MapDetailScreenの変更

```dart
class _MapDetailScreenState extends ConsumerState<MapDetailScreen> {
  // ドラッグ中のサークル位置を保持（ピクセル座標）
  final Map<int, Offset> _draggingPositions = {};

  void _onCircleDragUpdate(int circleId, Offset pixelPosition) {
    setState(() {
      _draggingPositions[circleId] = pixelPosition;
    });
  }

  void _onCircleDragEnd(int circleId) {
    setState(() {
      _draggingPositions.remove(circleId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // DraggableLineにdraggingPositionを渡す
        ...state.circles.map((circle) => DraggableLine(
          circle: circle,
          draggingPosition: _draggingPositions[circle.id],
          // ...
        )),

        // CircleMarkerにコールバックを渡す
        ...state.circles.map((circle) => CircleMarker(
          circle: circle,
          onDragUpdate: (pixelPosition) => _onCircleDragUpdate(circle.id, pixelPosition),
          onDragEnd: () => _onCircleDragEnd(circle.id),
          // ...
        )),
      ],
    );
  }
}
```

### 3.2 CircleMarkerの変更

```dart
class CircleMarker extends HookConsumerWidget {
  final void Function(Offset pixelPosition)? onDragUpdate;
  final VoidCallback? onDragEnd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onPanUpdate: (details) {
        // ローカル状態更新
        final newPositionX = oldPosition.dx + delta.dx;
        final newPositionY = oldPosition.dy + delta.dy;
        setState(() {
          localPosition = Offset(newPositionX, newPositionY);
        });

        // ピクセル座標に変換して親に通知
        final pixelX = CoordinateConverter.displayToPixel(
          newPositionX,
          displaySize.width,
          imageSize.width,
        );
        final pixelY = CoordinateConverter.displayToPixel(
          newPositionY,
          displaySize.height,
          imageSize.height,
        );
        onDragUpdate?.call(Offset(pixelX, pixelY));
      },

      onPanEnd: (details) async {
        // ViewModel更新
        await ref.read(circleViewModelProvider(circle.id).notifier)
            .updatePosition(pixelX, pixelY);

        // ドラッグ終了を親に通知
        onDragEnd?.call();
      },
    );
  }
}
```

### 3.3 DraggableLineの変更

```dart
class DraggableLine extends StatefulWidget {
  final CircleDetail circle;
  final Offset? draggingPosition; // ドラッグ中のピクセル座標（nullならcircle.positionを使用）
  final Size imageSize;
  final Size displaySize;

  // ...
}

class _DraggableLineState extends State<DraggableLine> {
  late double _startDx;
  late double _startDy;

  @override
  void initState() {
    super.initState();
    _updateStartPosition();
  }

  @override
  void didUpdateWidget(DraggableLine oldWidget) {
    super.didUpdateWidget(oldWidget);

    // draggingPositionが変更されたら始点を更新
    if (widget.draggingPosition != oldWidget.draggingPosition ||
        widget.circle.positionX != oldWidget.circle.positionX ||
        widget.circle.positionY != oldWidget.circle.positionY) {
      _updateStartPosition();
    }
  }

  void _updateStartPosition() {
    // ドラッグ中ならdraggingPositionを使用、そうでなければcircle.positionを使用
    final pixelX = widget.draggingPosition?.dx ?? widget.circle.positionX;
    final pixelY = widget.draggingPosition?.dy ?? widget.circle.positionY;

    setState(() {
      _startDx = CoordinateConverter.pixelToDisplay(
        pixelX,
        widget.imageSize.width,
        widget.displaySize.width,
      );
      _startDy = CoordinateConverter.pixelToDisplay(
        pixelY,
        widget.imageSize.height,
        widget.displaySize.height,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // 既存の実装（_startDx, _startDyを使用）
  }
}
```

---

## 4. テスト方法

### 4.1 手動テスト

1. **基本動作テスト**
   - [ ] サークルをドラッグすると、線の始点がリアルタイムで追従する
   - [ ] ドラッグ終了後も線が正しい位置に描画される
   - [ ] 複数のサークルを順番にドラッグしても問題ない

2. **パフォーマンステスト**
   - [ ] ドラッグ中のフレームレートが60fps近く維持される（Flutter DevToolsで確認）
   - [ ] 多数のサークル（20個以上）がある場合でもスムーズに動作

3. **エッジケーステスト**
   - [ ] ズーム・パン中のドラッグ動作
   - [ ] 画面回転時の座標変換
   - [ ] 非常に小さい/大きいマップ画像での動作

### 4.2 自動テスト（ウィジェットテスト）

```dart
// test/widgets/draggable_line_test.dart
testWidgets('DraggableLine responds to draggingPosition changes', (tester) async {
  // テストデータ
  final circle = CircleDetail(
    id: 1,
    positionX: 100,
    positionY: 100,
    // ...
  );

  // 初期描画
  await tester.pumpWidget(
    DraggableLine(
      circle: circle,
      draggingPosition: null,
      imageSize: Size(1000, 1000),
      displaySize: Size(500, 500),
      // ...
    ),
  );

  // 初期位置を確認
  final initialLine = tester.widget<CustomPaint>(find.byType(CustomPaint));
  // ... 位置検証

  // draggingPositionを更新
  await tester.pumpWidget(
    DraggableLine(
      circle: circle,
      draggingPosition: Offset(200, 200),
      imageSize: Size(1000, 1000),
      displaySize: Size(500, 500),
      // ...
    ),
  );

  await tester.pump();

  // 線の始点が更新されたことを確認
  final updatedLine = tester.widget<CustomPaint>(find.byType(CustomPaint));
  // ... 位置検証
});
```

---

## 5. 懸念事項とトレードオフ

### 懸念事項

1. **パフォーマンス**
   - ドラッグ中に`setState`が頻繁に呼ばれる（CircleMarker + DraggableLine）
   - 多数のサークルがある場合、Stackの再描画コストが高い
   - **対策**: Flutter DevToolsでプロファイリングし、必要に応じて`RepaintBoundary`を追加

2. **状態管理の複雑化**
   - `_draggingPositions` Mapの管理が追加される
   - ドラッグ終了時のクリーンアップを忘れるとメモリリーク
   - **対策**: `onDragEnd`コールバックを確実に呼び、単体テストでカバー

3. **座標変換の正確性**
   - ピクセル座標⇔ディスプレイ座標の変換を複数箇所で実施
   - 変換ミスによる線のズレの可能性
   - **対策**: CoordinateConverterのテストを充実させ、デバッグ時に座標をログ出力

4. **ズーム・パン中の動作**
   - TransformationControllerの変換が適用される中でのドラッグ処理
   - 既存の実装で問題ないはずだが、念入りなテストが必要

### トレードオフ

| 項目 | アプローチA（推奨） | アプローチB | アプローチC |
|------|-------------------|------------|------------|
| 実装難易度 | 中 | 高 | 中 |
| パフォーマンス | 良 | 悪（ViewModel頻繁更新） | 良 |
| 保守性 | 中（状態管理が複雑化） | 良（状態一元化） | 悪（描画順序問題） |
| 既存コードへの影響 | 小 | 大 | 大 |
| UX品質 | 高（リアルタイム追従） | 高 | 高 |

### 最終判断

**アプローチAを推奨**する理由：
- ✅ パフォーマンスと実装難易度のバランスが良い
- ✅ 既存のRiverpod Familyパターンを崩さない
- ✅ データベース書き込みタイミングが現状と同じ（onPanEndのみ）
- ⚠️ MapDetailScreenの状態管理が複雑化するが、将来的にはGestureDetectorのカスタマイズで改善可能

---

## 6. 実装の優先順位

### Phase 1: 基本実装（必須）
1. MapDetailScreenに`_draggingPositions` Map追加
2. CircleMarkerに`onDragUpdate`/`onDragEnd`コールバック追加
3. DraggableLineに`draggingPosition`パラメータ追加と`didUpdateWidget`修正

### Phase 2: テスト（必須）
1. ウィジェットテストの追加
2. 手動テストの実施（複数デバイス・画面サイズ）
3. パフォーマンステスト（Flutter DevTools）

### Phase 3: 最適化（オプション）
1. `RepaintBoundary`の追加検討
2. デバッグログの追加（座標変換の検証）
3. ドキュメント更新（CLAUDE.mdへの追記）

---

## 7. 参考資料

- [Flutter Performance Best Practices](https://docs.flutter.dev/perf/best-practices)
- [Riverpod Family Pattern](https://riverpod.dev/docs/concepts/modifiers/family)
- [CoordinateConverter実装](../lib/utils/coordinate_converter.dart)
- [既存のDraggableLine実装](../lib/views/widgets/draggable_line.dart)

---

**作成日**: 2025-12-27
**更新日**: 2025-12-27
**ステータス**: 設計完了 → 実装待ち
