# サークルリストからマップ詳細画面への遷移機能 実装計画

## プロジェクト概要

CircleListScreenの各リストアイテム右端にマップアイコンを配置し、タップするとMapDetailScreenに遷移してそのサークルが選択状態になる機能を実装する。

**開発方針**: ミニマル実装
- 利用者: 開発者のみ
- 対象OS: Androidのみ
- 多少のエラーや使い勝手の悪さは許容
- 最小限の変更で実装

---

## 要件定義

### 機能要件

1. **UIコンポーネント**
   - CircleListScreenの各ListTileの右端（trailing）にマップアイコン（Icons.map）を表示
   - アイコンはタップ可能なIconButtonとして実装

2. **ナビゲーション**
   - マップアイコンタップ時、go_routerを使用してMapDetailScreenに遷移
   - URL: `/mapList/:mapId` 形式（既存ルート利用）
   - 遷移先のMapDetailScreenでは対象サークルが選択状態になる

3. **状態管理**
   - MapDetailScreen側で選択サークルIDを受け取り、自動的に選択状態に設定
   - CircleBottomSheetも自動的に表示

### 非機能要件

- **パフォーマンス**: 遅延は許容（即座の遷移でなくても可）
- **エラーハンドリング**: mapIdがnullの場合はアイコン非表示またはタップ無効
- **UI/UX**: Material Design準拠の標準アイコン使用

---

## 技術設計

### 1. アーキテクチャ変更

#### 影響範囲

```
lib/
├── views/screens/
│   ├── circle_list_screen.dart          [修正] trailing追加
│   └── map_detail_screen.dart           [修正] URL引数にcircleId追加
└── app_router.dart                      [修正] queryパラメータ追加
```

### 2. 実装詳細

#### 2.1 CircleListScreen修正（lib/views/screens/circle_list_screen.dart）

**変更箇所**: ListTileにtrailing追加（142-165行目）

```dart
return ListTile(
  title: Text("[$mapName] $circleName"),
  subtitle: Text(
    circle.spaceNo == null || circle.spaceNo!.isEmpty
        ? 'スペース番号なし'
        : circle.spaceNo!,
  ),
  // 既存のonTap（CircleBottomSheet表示）
  onTap: circle.mapId != null && circle.circleId != null
      ? () async {
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => CircleBottomSheet(
              circle.mapId!,
              circle.circleId,
              circleId: circle.circleId!,
              width: 0.8,
              height: 0.7,
              isDeletable: false,
            ),
          );
        }
      : null,
  // 新規追加: trailing
  trailing: circle.mapId != null
      ? IconButton(
          icon: const Icon(Icons.map),
          onPressed: () {
            // MapDetailScreenに遷移（circleId付き）
            context.push('/mapList/${circle.mapId}?circleId=${circle.circleId}');
          },
        )
      : null,
);
```

**追加import**: `package:go_router/go_router.dart`

#### 2.2 app_router修正（lib/app_router.dart）

**変更箇所**: MapDetailScreenルートにqueryパラメータ処理追加（56-67行目）

```dart
GoRoute(
  path: '/mapList/:mapId',
  pageBuilder: (context, state) {
    final mapId = state.pathParameters['mapId'];
    if (mapId == null) {
      return const MaterialPage(child: SizedBox.shrink());
    }

    // 新規追加: circleId取得
    final circleIdStr = state.uri.queryParameters['circleId'];
    final circleId = circleIdStr != null ? int.tryParse(circleIdStr) : null;

    return MaterialPage(
      child: MapDetailScreen(
        mapId: int.parse(mapId),
        initialSelectedCircleId: circleId,  // 新規引数
      ),
    );
  },
),
```

#### 2.3 MapDetailScreen修正（lib/views/screens/map_detail_screen.dart）

**変更箇所1**: コンストラクタに引数追加（11-15行目）

```dart
class MapDetailScreen extends ConsumerStatefulWidget {
  const MapDetailScreen({
    super.key,
    required this.mapId,
    this.initialSelectedCircleId,  // 新規追加（optional）
  });

  final int mapId;
  final int? initialSelectedCircleId;  // 新規追加
```

**変更箇所2**: initState修正（192-198行目）

```dart
@override
void initState() {
  super.initState();
  viewModel = ref.read(mapDetailViewModelProvider(widget.mapId).notifier);
  _transformController.addListener(_onTransformChanged);
  _currentScale = _transformController.value.getMaxScaleOnAxis();

  // 新規追加: 初期選択サークル設定
  if (widget.initialSelectedCircleId != null) {
    selectedCircleId = widget.initialSelectedCircleId;
    // 画面表示後にBottomSheet表示
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && selectedCircleId != null) {
        _onCircleTap(context, selectedCircleId!);
      }
    });
  }
}
```

---

## 実装手順（3ステップ）

### Step 1: CircleListScreen修正

1. `lib/views/screens/circle_list_screen.dart`を開く
2. ファイル冒頭に`import 'package:go_router/go_router.dart';`追加
3. ListTileの`trailing`プロパティ追加（上記コード参照）
4. 動作確認: アイコンが表示されることを確認（タップはまだ動作しない）

### Step 2: app_router修正

1. `lib/app_router.dart`を開く
2. `/mapList/:mapId`ルートのpageBuilderを修正
3. queryパラメータから`circleId`取得処理を追加
4. `MapDetailScreen`に`initialSelectedCircleId`を渡す（コンパイルエラー発生、Step 3で解消）

### Step 3: MapDetailScreen修正

1. `lib/views/screens/map_detail_screen.dart`を開く
2. コンストラクタに`initialSelectedCircleId`引数追加
3. フィールド`final int? initialSelectedCircleId;`追加
4. `initState`に初期選択ロジック追加
5. 動作確認: CircleListScreenのアイコンタップ → MapDetailScreen遷移 → サークル選択 → BottomSheet表示

---

## 動作確認項目

### 正常系

- [ ] CircleListScreenで各リストアイテム右端にマップアイコンが表示される
- [ ] mapIdがnullのサークルではアイコンが表示されない
- [ ] アイコンタップでMapDetailScreenに遷移する
- [ ] 遷移先で対象サークルが選択状態（他のサークルは0.5透明度）
- [ ] CircleBottomSheetが自動的に表示される
- [ ] BottomSheetの内容が正しいサークル情報を表示
- [ ] BottomSheet閉じるとサークル選択が解除される

### 異常系（許容範囲）

- [ ] circleIdが不正な値の場合、選択されない（エラーなし）
- [ ] 対象サークルが存在しない場合、何も選択されない（エラーなし）
- [ ] 画面遷移後、戻るボタンでCircleListScreenに戻れる

---

## 技術的考慮事項

### URL設計

- **Path**: `/mapList/:mapId`（既存ルート流用）
- **Query**: `?circleId=123`（新規追加）
- **理由**: 既存ルート構造を変更せず、最小限の追加で実装

### 状態管理

- **選択状態**: MapDetailScreenの`selectedCircleId`フィールドで管理（既存実装）
- **永続化**: 不要（一時的な選択のみ）
- **同期**: 不要（単一画面内で完結）

### パフォーマンス

- **画面遷移**: `context.push`使用（非同期でも許容）
- **BottomSheet表示**: `addPostFrameCallback`で画面構築後に実行
- **メモリ**: ナビゲーションスタック増加（許容範囲）

### エラーハンドリング

**ミニマル方針**: try-catchなし、null安全のみ

- `mapId`がnull → trailing表示しない（`circle.mapId != null`チェック）
- `mapId`のMapDetailが存在しない → trailingしない
- `circleId`がnull → queryパラメータに含めない
- `circleId`パースエラー → `int.tryParse`でnull返却、選択なし
- 存在しないサークルID → `_onCircleTap`実行されるが、既存ロジックで対応

---

## UI/UXガイドライン

### アイコンデザイン

- **アイコン**: `Icons.map`（Material Design標準）
- **サイズ**: デフォルト（24x24 dp）
- **色**: プライマリーカラー（テーマ依存）
- **領域**: IconButton（タップ領域拡大）

### インタラクション

- **タップフィードバック**: IconButtonの標準リップルエフェクト
- **画面遷移**: デフォルトアニメーション（右からスライド）
- **選択状態**: 既存実装（選択中サークル透明度1.0、他0.5）

### アクセシビリティ（最小限）

- IconButtonは自動的にタップ領域確保（48x48 dp最小）
- セマンティクス: 特になし（開発者専用のため省略可）

---

## リスク管理

### 既知の制約

- Android限定（iOS未検証）
- 開発者専用（一般ユーザーのUX考慮不要）
- オフライン専用

### 潜在的な問題と対策

| 問題 | 発生条件 | 対策 | 優先度 |
|------|----------|------|--------|
| circleIdが不正 | URL直接入力 | `int.tryParse`でnull処理 | 低 |
| mapIdとcircleIdが不整合 | データ破損 | 何も選択されないのみ | 低 |
| 画面遷移後の戻る処理 | ユーザー操作 | go_routerが自動処理 | なし |
| BottomSheet表示タイミング | 初期化競合 | `addPostFrameCallback`使用 | 中 |

---

## 代替案の検討

### 代替案1: モーダルダイアログで遷移確認

**内容**: アイコンタップ時に「マップを開きますか?」確認ダイアログ表示

**メリット**: 誤タップ防止

**デメリット**: 手順増加、UX悪化

**判断**: 不採用（ミニマル方針に反する）

### 代替案2: Long Pressで遷移

**内容**: アイコンをLong Pressで遷移

**メリット**: 誤タップ完全防止

**デメリット**: 操作が直感的でない

**判断**: 不採用（タップが一般的）

### 代替案3: 行全体タップで遷移、長押しでBottomSheet

**内容**: 現在のonTapとtrailingを入れ替え

**メリット**: シンプルなUI

**デメリット**: 既存動作の大幅変更

**判断**: 不採用（既存ユーザー（開発者自身）の混乱）

---

## テストシナリオ（手動）

### シナリオ1: 基本フロー

1. アプリ起動
2. 「サークル」タブを選択
3. リスト内のサークル右端のマップアイコンをタップ
4. MapDetailScreenに遷移することを確認
5. 対象サークルが選択状態（ハイライト）であることを確認
6. CircleBottomSheetが自動表示されることを確認
7. BottomSheet内容が正しいサークル情報であることを確認
8. 戻るボタンでCircleListScreenに戻ることを確認

### シナリオ2: 異なるサークルに遷移

1. シナリオ1完了後、CircleListScreenで別のサークルのマップアイコンをタップ
2. 異なるマップまたは同一マップに遷移
3. 選択サークルが正しく切り替わることを確認

### シナリオ3: BottomSheet操作後の戻り

1. シナリオ1完了後、BottomSheetでサークル情報を編集
2. BottomSheet閉じる
3. 戻るボタンでCircleListScreenに戻る
4. リストが更新されていることを確認（編集内容反映）

---

## 完了定義（Definition of Done）

- [ ] コードが正常にビルドされる
- [ ] 全テストシナリオがパスする
- [ ] エラー時にアプリがクラッシュしない
- [ ] CircleListScreenとMapDetailScreen間の往復が正常に動作
- [ ] BottomSheetの開閉が正常に動作
- [ ] 既存機能（サークルタップでBottomSheet表示）が正常動作

---

## 実装見積もり

- **実装時間**: 30分～1時間
- **テスト時間**: 15分
- **合計**: 約1時間

---

## 参考情報

### 関連ファイル

- `lib/views/screens/circle_list_screen.dart:142-165` - ListTile実装
- `lib/views/screens/map_detail_screen.dart:11-18` - MapDetailScreenコンストラクタ
- `lib/views/screens/map_detail_screen.dart:110-145` - _onCircleTap実装
- `lib/app_router.dart:56-67` - MapDetailScreenルート定義

### Flutter公式ドキュメント

- go_router queryParameters: https://pub.dev/documentation/go_router/latest/topics/Query%20parameters-topic.html
- WidgetsBinding.addPostFrameCallback: https://api.flutter.dev/flutter/scheduler/SchedulerBinding/addPostFrameCallback.html
- IconButton: https://api.flutter.dev/flutter/material/IconButton-class.html

---

## 次のアクション

**実装開始:**
1. CircleListScreen修正（trailing追加）
2. app_router修正（queryパラメータ処理）
3. MapDetailScreen修正（initialSelectedCircleId対応）
4. 動作確認（全テストシナリオ実行）

---

**作成日**: 2025-12-27
**対象バージョン**: Flutter 3.x, go_router 14.x
**開発環境**: Android限定
**実装方針**: ミニマル・最小限変更
