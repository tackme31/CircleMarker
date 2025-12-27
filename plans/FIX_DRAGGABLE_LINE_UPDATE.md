# DraggableLine始点追従機能の実装設計（改訂版）

## 📋 ドキュメント情報

- **作成日**: 2025-12-27
- **ステータス**: 設計完了 → 実装待ち
- **前提ドキュメント**: [FIX_DRAGGABLE_LINE.md](./FIX_DRAGGABLE_LINE.md)
- **改訂理由**: 既存コード実態との乖離を修正し、実装可能な方針に更新

---

## 1. 既存実装の実態分析

### 1.1 計画書（FIX_DRAGGABLE_LINE.md）との主な相違点

#### ❌ 誤解1: CircleMarkerの構造
**計画書の想定**:
```dart
class CircleMarker extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() { ... }); // ❌ 存在しない
      },
    );
  }
}
```

**実際のコード** (`lib/views/widgets/circle_marker.dart:12`):
```dart
class CircleMarker extends ConsumerWidget {  // StatelessWidget
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // setStateは使えない
    // ローカル状態（localPosition）も持っていない
  }
}
```

#### ❌ 誤解2: ドラッグ処理の実装場所
**計画書の想定**: CircleMarkerが直接ドラッグを処理

**実際のコード**: `PixelPositioned`ウィジェットがドラッグ処理を担当
```dart
// circle_marker.dart:61-71
PixelPositioned(
  pixelX: circle.positionX!,
  pixelY: circle.positionY!,
  onDragEnd: (x, y) async {
    await ref.read(circleViewModelProvider(circleId).notifier)
        .updatePosition(x, y);
  },
  child: Container(...),
)
```

**PixelPositionedの内部実装** (`lib/views/widgets/pixel_positioned.dart:29-93`):
- `_currentDisplayX`, `_currentDisplayY`でディスプレイ座標を管理（StatefulWidget）
- `onPanUpdate`で`setState`による座標更新
- `onPanEnd`でピクセル座標に変換してコールバック実行

#### ❌ 誤解3: 座標管理の方法
**計画書の想定**: CircleMarkerのローカル状態を`widget`プロパティとして渡す

**実際の問題**:
- ドラッグ中の座標は`PixelPositioned`の**内部状態**（`_currentDisplayX/Y`）
- この状態は外部から参照不可能
- `widget`プロパティとして渡されていないため、`didUpdateWidget`で検出できない

---

### 1.2 現在のウィジェット構造

```
MapDetailScreen (StatefulWidget)
└─ Stack
   ├─ Image.file (ベース画像)
   └─ CircleMarker (ConsumerWidget) ×N
      └─ Stack
         ├─ DraggableLine (StatefulWidget)
         │  └─ 始点: circle.positionX/Y から計算（buildメソッド内）
         │     終点: _endPosition (ローカル状態)
         └─ PixelPositioned (StatefulWidget)
            └─ _currentDisplayX/Y (ローカル状態)
               └─ CircleBox
```

**重要な観察**:
1. `CircleMarker`自体はStateless → ローカル状態を持てない
2. ドラッグ中の座標は`PixelPositioned`の内部状態
3. `DraggableLine`は`CircleMarker`の子要素として存在
4. `DraggableLine`と`PixelPositioned`は兄弟関係で、状態を共有していない

---

## 2. 修正版アプローチ: PixelPositionedベースの実装

### 2.1 設計方針

#### 核心コンセプト
**PixelPositionedのドラッグ中状態を、MapDetailScreenまで伝播させる**

#### データフロー
```
PixelPositioned (onPanUpdate)
  ↓ onDragUpdate(displayPosition)
CircleMarker
  ↓ onDragUpdate(displayPosition)
MapDetailScreen
  ↓ setState({ _draggingDisplayPositions[circleId] = displayPosition })
  ↓ rebuild
DraggableLine
  ↓ draggingStartDisplayPosition ?? pixelToDisplay(startPixelX/Y)
線の始点が更新される ✅
```

#### 座標系の選択: ディスプレイ座標を採用
| 方式 | メリット | デメリット |
|------|---------|----------|
| ピクセル座標 | データベースと整合 | onPanUpdate毎に変換が必要（パフォーマンス悪） |
| **ディスプレイ座標** ✅ | 変換不要（パフォーマンス良） | DraggableLine側で条件分岐が必要 |

**採用理由**:
- `onPanUpdate`は高頻度で呼ばれる（60fps）
- ピクセル↔ディスプレイ変換は計算コストがかかる
- DraggableLineでの条件分岐は1回のみ

---

### 2.2 具体的な実装内容

#### Phase 1: PixelPositionedの拡張

**ファイル**: `lib/views/widgets/pixel_positioned.dart`

**変更内容**:
```dart
class PixelPositioned extends StatefulWidget {
  const PixelPositioned({
    // 既存のパラメータ...
    this.onDragEnd,
    this.onDragUpdate,  // ✅ 追加
    this.onTap,
  });

  final void Function(int newPixelX, int newPixelY)? onDragEnd;
  final void Function(Offset displayPosition)? onDragUpdate;  // ✅ 追加
  final void Function()? onTap;

  // ...
}

class _PixelPositionedState extends State<PixelPositioned> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _currentDisplayX,
      top: _currentDisplayY,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _currentDisplayX += details.delta.dx;
            _currentDisplayY += details.delta.dy;
          });

          // ✅ ドラッグ中の座標を親に通知（ディスプレイ座標）
          widget.onDragUpdate?.call(Offset(_currentDisplayX, _currentDisplayY));
        },
        onPanEnd: (details) {
          if (widget.onDragEnd != null) {
            final currentDisplayPosition =
                Offset(_currentDisplayX, _currentDisplayY);
            final pixelPosition =
                _converter.displayToPixelRounded(currentDisplayPosition);

            widget.onDragEnd!(
              pixelPosition.dx.toInt(),
              pixelPosition.dy.toInt(),
            );
          }
        },
        child: widget.child,
      ),
    );
  }
}
```

**追加コード量**: 約5行

---

#### Phase 2: CircleMarkerの拡張

**ファイル**: `lib/views/widgets/circle_marker.dart`

**変更内容**:
```dart
class CircleMarker extends ConsumerWidget {
  const CircleMarker({
    super.key,
    // 既存のパラメータ...
    required this.onTap,
    required this.onLongPress,
    this.onDragUpdate,  // ✅ 追加
    this.onDragEnd,     // ✅ 追加
  });

  final int circleId;
  final Size imageOriginalSize;
  final Size imageDisplaySize;
  final double dragIconScale;
  final bool isSelected;
  final double opacity;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final void Function(Offset displayPosition)? onDragUpdate;  // ✅ 追加
  final VoidCallback? onDragEnd;  // ✅ 追加

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final circleAsync = ref.watch(circleViewModelProvider(circleId));

    return circleAsync.when(
      data: (circle) {
        return Opacity(
          opacity: opacity,
          child: Stack(
            children: [
              // ポインターライン（変更なし）
              DraggableLine(
                startPixelX: circle.positionX! + circle.sizeWidth! ~/ 2,
                startPixelY: circle.positionY! + circle.sizeHeight! ~/ 2,
                endPixelX: circle.pointerX!,
                endPixelY: circle.pointerY!,
                imageOriginalSize: imageOriginalSize,
                imageDisplaySize: imageDisplaySize,
                dragIconScale: dragIconScale,
                showIcon: isSelected,
                onEndPointDragEnd: (newEndX, newEndY) {
                  ref
                      .read(circleViewModelProvider(circleId).notifier)
                      .updatePointer(newEndX, newEndY);
                },
              ),
              // サークルボックス
              PixelPositioned(
                pixelX: circle.positionX!,
                pixelY: circle.positionY!,
                imageDisplaySize: imageDisplaySize,
                imageOriginalSize: imageOriginalSize,
                onTap: onTap,
                onDragUpdate: onDragUpdate,  // ✅ 親へ転送
                onDragEnd: (x, y) async {
                  await ref
                      .read(circleViewModelProvider(circleId).notifier)
                      .updatePosition(x, y);

                  // ✅ ドラッグ終了を親に通知
                  onDragEnd?.call();
                },
                child: Container(
                  color: Colors.white.withValues(alpha: 0.7),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleBox(
                        circle: circle,
                        imageDisplaySize: imageDisplaySize,
                        imageOriginalSize: imageOriginalSize,
                        onLongPress: onLongPress,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const Icon(Icons.error, color: Colors.red),
    );
  }
}
```

**追加コード量**: 約15行（パラメータ定義 + コールバック配線）

---

#### Phase 3: MapDetailScreenの状態管理

**ファイル**: `lib/views/screens/map_detail_screen.dart`

**変更内容**:
```dart
class _MapDetailScreenState extends ConsumerState<MapDetailScreen> {
  final TransformationController _transformController =
      TransformationController();
  PersistentBottomSheetController? _sheetController;
  late final MapDetailViewModel viewModel;
  int? selectedCircleId;
  double _currentScale = 1.0;
  bool _orientationLocked = false;

  // ✅ ドラッグ中のサークル位置を保持（ディスプレイ座標）
  final Map<int, Offset> _draggingDisplayPositions = {};

  // ✅ ドラッグ更新コールバック
  void _onCircleDragUpdate(int circleId, Offset displayPosition) {
    setState(() {
      _draggingDisplayPositions[circleId] = displayPosition;
    });
  }

  // ✅ ドラッグ終了コールバック
  void _onCircleDragEnd(int circleId) {
    setState(() {
      _draggingDisplayPositions.remove(circleId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mapDetailViewModelProvider(widget.mapId));

    return Scaffold(
      // AppBarは変更なし...
      body: switch (state) {
        AsyncData(:final value) => Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final imageDisplaySize = Size(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );
                  return GestureDetector(
                    // onLongPressStart, onDoubleTapDownは変更なし...
                    child: InteractiveViewer(
                      transformationController: _transformController,
                      minScale: 0.5,
                      maxScale: 10.0,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.file(
                              value.baseImage,
                              fit: BoxFit.contain,
                            ),
                          ),
                          ...value.circleIds
                              .where(
                                (id) =>
                                    widget.initialSelectedCircleId == null ||
                                    widget.initialSelectedCircleId == id,
                              )
                              .map((circleId) {
                                return CircleMarker(
                                  key: Key(circleId.toString()),
                                  circleId: circleId,
                                  imageOriginalSize: value.baseImageSize,
                                  imageDisplaySize: imageDisplaySize,
                                  dragIconScale: _transformController.value
                                      .getMaxScaleOnAxis(),
                                  isSelected: selectedCircleId == circleId,
                                  opacity:
                                      selectedCircleId == null ||
                                          selectedCircleId == circleId
                                      ? 1.0
                                      : 0.5,
                                  onTap: () => _onCircleTap(context, circleId),
                                  onLongPress: () => _pickCircleImage(circleId),
                                  // ✅ ドラッグコールバックを追加
                                  onDragUpdate: (displayPosition) =>
                                      _onCircleDragUpdate(circleId, displayPosition),
                                  onDragEnd: () => _onCircleDragEnd(circleId),
                                );
                              }),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        AsyncError(:final error) => Center(
          child: Text('Something went wrong: $error'),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
```

**追加コード量**: 約20行（状態変数 + コールバック + 配線）

---

#### Phase 4: DraggableLineの修正

**ファイル**: `lib/views/widgets/draggable_line.dart`

**変更内容**:
```dart
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
    this.draggingStartDisplayPosition,  // ✅ 追加
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
  final Offset? draggingStartDisplayPosition;  // ✅ 追加（ディスプレイ座標）

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
    _endPosition = _converter.pixelToDisplayInt(widget.endPixelX, widget.endPixelY);
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
      _endPosition = _converter.pixelToDisplayInt(widget.endPixelX, widget.endPixelY);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ ドラッグ中ならdraggingStartDisplayPositionを使用、そうでなければピクセル座標から計算
    final start = widget.draggingStartDisplayPosition ??
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
                  final newPixel = _converter.displayToPixelRounded(_endPosition);
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
```

**追加コード量**: 約5行（パラメータ + 条件分岐）

---

#### Phase 5: CircleMarkerとDraggableLineの接続

**ファイル**: `lib/views/widgets/circle_marker.dart`

**変更内容**:
```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final circleAsync = ref.watch(circleViewModelProvider(circleId));

  return circleAsync.when(
    data: (circle) {
      return Opacity(
        opacity: opacity,
        child: Stack(
          children: [
            // ✅ DraggableLineにdraggingStartDisplayPositionを渡す
            // ここでMapDetailScreenから渡されたdraggingPositionを使用する必要がある
            // そのため、CircleMarkerに新しいパラメータを追加する必要がある
            DraggableLine(
              startPixelX: circle.positionX! + circle.sizeWidth! ~/ 2,
              startPixelY: circle.positionY! + circle.sizeHeight! ~/ 2,
              endPixelX: circle.pointerX!,
              endPixelY: circle.pointerY!,
              imageOriginalSize: imageOriginalSize,
              imageDisplaySize: imageDisplaySize,
              dragIconScale: dragIconScale,
              showIcon: isSelected,
              draggingStartDisplayPosition: draggingStartDisplayPosition,  // ✅ 追加
              onEndPointDragEnd: (newEndX, newEndY) {
                ref
                    .read(circleViewModelProvider(circleId).notifier)
                    .updatePointer(newEndX, newEndY);
              },
            ),
            // PixelPositionedは前述の通り...
          ],
        ),
      );
    },
    loading: () => const SizedBox.shrink(),
    error: (error, stack) => const Icon(Icons.error, color: Colors.red),
  );
}
```

**重要な追加**:
```dart
class CircleMarker extends ConsumerWidget {
  const CircleMarker({
    // 既存のパラメータ...
    this.draggingStartDisplayPosition,  // ✅ 追加
  });

  final Offset? draggingStartDisplayPosition;  // ✅ 追加

  // ...
}
```

---

#### Phase 6: MapDetailScreenからCircleMarkerへの配線完了

**ファイル**: `lib/views/screens/map_detail_screen.dart`

**変更内容**:
```dart
...value.circleIds
    .where(
      (id) =>
          widget.initialSelectedCircleId == null ||
          widget.initialSelectedCircleId == id,
    )
    .map((circleId) {
      return CircleMarker(
        key: Key(circleId.toString()),
        circleId: circleId,
        imageOriginalSize: value.baseImageSize,
        imageDisplaySize: imageDisplaySize,
        dragIconScale: _transformController.value.getMaxScaleOnAxis(),
        isSelected: selectedCircleId == circleId,
        opacity: selectedCircleId == null || selectedCircleId == circleId
            ? 1.0
            : 0.5,
        onTap: () => _onCircleTap(context, circleId),
        onLongPress: () => _pickCircleImage(circleId),
        onDragUpdate: (displayPosition) =>
            _onCircleDragUpdate(circleId, displayPosition),
        onDragEnd: () => _onCircleDragEnd(circleId),
        draggingStartDisplayPosition: _draggingDisplayPositions[circleId],  // ✅ 追加
      );
    }),
```

---

## 3. 実装の全体像まとめ

### 3.1 変更ファイル一覧

| ファイル | 変更内容 | 追加行数 |
|---------|---------|---------|
| `pixel_positioned.dart` | `onDragUpdate`コールバック追加 | +5行 |
| `circle_marker.dart` | `onDragUpdate`, `onDragEnd`, `draggingStartDisplayPosition`追加 | +20行 |
| `map_detail_screen.dart` | `_draggingDisplayPositions`状態管理 + コールバック | +20行 |
| `draggable_line.dart` | `draggingStartDisplayPosition`パラメータ + 始点計算修正 | +5行 |

**合計**: 約50行の追加

---

### 3.2 データフローの完全な経路

```
1. ユーザーがサークルをドラッグ開始
   ↓
2. PixelPositioned._PixelPositionedState.onPanUpdate
   - setState({ _currentDisplayX/Y更新 })
   - widget.onDragUpdate(Offset(_currentDisplayX, _currentDisplayY))
   ↓
3. CircleMarker.onDragUpdate(displayPosition)
   - このコールバックを親（MapDetailScreen）へ転送
   ↓
4. MapDetailScreen._onCircleDragUpdate(circleId, displayPosition)
   - setState({ _draggingDisplayPositions[circleId] = displayPosition })
   ↓
5. MapDetailScreenがrebuild
   - CircleMarker(draggingStartDisplayPosition: _draggingDisplayPositions[circleId])
   ↓
6. CircleMarkerがrebuild
   - DraggableLine(draggingStartDisplayPosition: draggingStartDisplayPosition)
   ↓
7. DraggableLineがrebuild
   - final start = draggingStartDisplayPosition ?? pixelToDisplay(...)
   - 線の始点が更新される ✅
```

---

## 4. パフォーマンス考慮事項

### 4.1 setState頻度の分析

**ドラッグ中に発生するsetState**:
1. `PixelPositioned`: 1回/フレーム（既存）
2. `MapDetailScreen`: 1回/フレーム（新規）
3. `DraggableLine`: 0回（buildメソッドで計算）

**影響範囲**:
- MapDetailScreenのrebuildにより、**すべてのCircleMarker**がrebuildされる
- ただし、`draggingStartDisplayPosition`が変更されたCircleMarkerのみ、DraggableLineの始点が更新される
- 他のCircleMarkerは同じ値で再構築されるため、Flutterの最適化により実質的なコストは低い

### 4.2 最適化の余地（オプション）

もしパフォーマンス問題が発生した場合の対策：

#### オプション1: RepaintBoundaryの追加
```dart
RepaintBoundary(
  child: CircleMarker(...),
)
```

#### オプション2: 選択的rebuild
```dart
// MapDetailScreenで、ドラッグ中のサークルIDを追跡
int? _draggingCircleId;

// CircleMarkerのbuildで条件分岐
if (circleId != _draggingCircleId) {
  return const SizedBox.shrink();  // ドラッグ中でないサークルは再描画しない
}
```

**現時点の判断**: 最適化は実装後のプロファイリング結果を見てから判断

---

## 5. テスト計画

### 5.1 単体テスト（オプション）

#### PixelPositionedのテスト
```dart
testWidgets('onDragUpdate is called during drag', (tester) async {
  Offset? capturedPosition;

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            PixelPositioned(
              pixelX: 100,
              pixelY: 100,
              imageOriginalSize: Size(1000, 1000),
              imageDisplaySize: Size(500, 500),
              onDragUpdate: (pos) => capturedPosition = pos,
              child: Container(width: 50, height: 50),
            ),
          ],
        ),
      ),
    ),
  );

  // ドラッグシミュレーション
  await tester.drag(find.byType(Container), Offset(10, 10));

  expect(capturedPosition, isNotNull);
  // 座標検証...
});
```

### 5.2 手動テスト（必須）

#### テストケース1: 基本動作
- [ ] サークルをドラッグすると、線の始点がリアルタイムで追従する
- [ ] ドラッグ終了後、線が正しい位置に固定される
- [ ] 複数のサークルを順番にドラッグしても問題ない

#### テストケース2: エッジケース
- [ ] ズーム中（scale > 1.0）のドラッグ動作
- [ ] パン中のドラッグ動作
- [ ] 画面回転時の動作（orientation変更）
- [ ] 非常に小さいマップ画像での動作
- [ ] 非常に大きいマップ画像での動作

#### テストケース3: パフォーマンス
- [ ] Flutter DevToolsでフレームレート確認（目標: 60fps維持）
- [ ] 多数のサークル（20個以上）がある場合の動作
- [ ] メモリ使用量の確認（DevTools Memoryタブ）

#### テストケース4: 既存機能の退行テスト
- [ ] サークルのタップ選択が正常に動作
- [ ] ポインターラインの終点ドラッグが正常に動作
- [ ] サークルの長押しで画像選択が正常に動作
- [ ] ボトムシートの表示・非表示が正常に動作

---

## 6. 実装手順

### Step 1: PixelPositionedの拡張
1. `onDragUpdate`パラメータを追加
2. `onPanUpdate`内でコールバックを呼び出し
3. 動作確認（デバッグプリントで座標確認）

### Step 2: CircleMarkerの拡張
1. `onDragUpdate`, `onDragEnd`, `draggingStartDisplayPosition`パラメータを追加
2. PixelPositionedへのコールバック配線
3. DraggableLineへの`draggingStartDisplayPosition`配線
4. 動作確認（デバッグプリントでコールバック確認）

### Step 3: MapDetailScreenの状態管理
1. `_draggingDisplayPositions` Map追加
2. `_onCircleDragUpdate`, `_onCircleDragEnd`メソッド追加
3. CircleMarkerへのコールバック配線
4. 動作確認（デバッグプリントで状態確認）

### Step 4: DraggableLineの修正
1. `draggingStartDisplayPosition`パラメータを追加
2. `build`メソッドの始点計算ロジック修正
3. 動作確認（線が追従することを確認）

### Step 5: 統合テスト
1. 全機能の動作確認
2. パフォーマンステスト
3. エッジケーステスト
4. 退行テスト

### Step 6: コードクリーンアップ（オプション）
1. デバッグプリントの削除
2. コメントの追加（必要に応じて）
3. CLAUDE.mdへの実装内容追記

---

## 7. 既知の制約事項

### 7.1 現在の設計での制約
1. **複数サークルの同時ドラッグには非対応**
   - Flutterの`GestureDetector`は1つのジェスチャーのみ処理
   - マルチタッチ対応には大規模な改修が必要
   - 現実的な使用シーンでは問題なし（ユーザーは1つずつドラッグする）

2. **MapDetailScreen全体のrebuildが発生**
   - パフォーマンス問題が発生する可能性は低い
   - 必要に応じて`RepaintBoundary`で最適化可能

### 7.2 将来的な拡張の可能性
1. **Undo/Redo機能**
   - 現在の設計では対応しづらい
   - ViewModelに履歴管理機能を追加する必要がある

2. **複数サークルの一括移動**
   - 現在の設計では非対応
   - 選択状態の管理を拡張する必要がある

---

## 8. リスク評価

### 低リスク ✅
- **既存の座標変換ロジックを活用**: CoordinateConverterは既にテスト済み
- **最小限の変更**: 4ファイル、約50行の追加のみ
- **既存機能への影響小**: 新規パラメータは`optional`、既存コードは変更不要

### 中リスク ⚠️
- **パフォーマンス**: MapDetailScreenの頻繁なrebuild
  - **対策**: 実装後にFlutter DevToolsでプロファイリング、必要に応じて最適化

### 高リスク ❌
- なし

---

## 9. 成功基準

### 必須（Must Have）
- ✅ サークルドラッグ中に線の始点が追従する
- ✅ ドラッグ終了後に線が正しい位置に固定される
- ✅ 既存機能が正常に動作する（退行なし）

### 推奨（Should Have）
- ⭕ 60fps近くのフレームレートを維持
- ⭕ 20個以上のサークルがあってもスムーズに動作

### オプション（Nice to Have）
- ⚪ 100個以上のサークルでも動作
- ⚪ メモリ使用量の増加が10%未満

---

## 10. 実装後の確認事項

### コードレビュー
- [ ] すべての変更が意図通りに動作するか確認
- [ ] コードの可読性が保たれているか確認
- [ ] 不要なデバッグコードが残っていないか確認

### ドキュメント更新
- [ ] CLAUDE.mdに実装内容を追記
- [ ] コメントが適切に記述されているか確認

### Git管理
- [ ] コミットメッセージが明確か確認
- [ ] 変更が論理的な単位で分割されているか確認

---

## 11. 参考資料

- [Flutter Performance Best Practices](https://docs.flutter.dev/perf/best-practices)
- [Riverpod Family Pattern](https://riverpod.dev/docs/concepts/modifiers/family)
- [CoordinateConverter実装](../lib/utils/coordinate_converter.dart)
- [既存のDraggableLine実装](../lib/views/widgets/draggable_line.dart)
- [PixelPositioned実装](../lib/views/widgets/pixel_positioned.dart)

---

**作成日**: 2025-12-27
**更新日**: 2025-12-27
**ステータス**: 設計完了 → 実装待ち
**承認待ち**: ユーザーレビュー
