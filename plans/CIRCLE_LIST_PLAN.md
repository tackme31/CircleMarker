# サークル一覧機能 実装計画

## プロジェクト概要

Circle Markerアプリの第2タブ「サークル」に、全配置図のサークル情報を一覧表示する機能を実装する。

**開発方針**: ミニマルスタート・ボトムアップ開発
- 各フェーズで動作確認できる粒度で段階的に実装
- 利用者は開発者のみ、Android限定
- 多少のエラーや使いづらさは許容

---

## アーキテクチャ設計

### 1. データフロー（Riverpod + Repository パターン）

```
CircleListScreen (UI)
    ↓ watch
CircleListViewModel (@riverpod, generated)
    ↓ read
CircleRepository (existing)
    ↓ query
Database (sqflite)
```

### 2. ファイル構成

```
lib/
├── views/
│   └── screens/
│       └── circle_list_screen.dart          [新規] UI層
├── viewModels/
│   └── circle_list_view_model.dart          [新規] ビジネスロジック層
├── states/
│   └── circle_list_state.dart               [新規] 状態管理（@freezed）
├── repositories/
│   └── circle_repository.dart               [既存に追加] getAllCircles()メソッド追加
└── app_router.dart                          [修正] ルーティング変更
```

---

## 段階的実装計画（5フェーズ）

### Phase 1: 最小限のリスト表示 ⭐ **START HERE**

**目標**: DBの全サークルを単純なリストで表示する

#### 実装内容

1. **CircleRepository拡張** (`lib/repositories/circle_repository.dart`)
   - `Future<List<CircleDetail>> getAllCircles()` メソッド追加
   - 全配置図のサークルを取得（WHERE句なし）

2. **State定義** (`lib/states/circle_list_state.dart`)
   ```dart
   @freezed
   class CircleListState with _$CircleListState {
     const factory CircleListState({
       required List<CircleDetail> circles,
     }) = _CircleListState;
   }
   ```

3. **ViewModel作成** (`lib/viewModels/circle_list_view_model.dart`)
   ```dart
   @riverpod
   class CircleListViewModel extends _$CircleListViewModel {
     @override
     Future<CircleListState> build() async {
       // getAllCircles()で全サークル取得
       final circles = await ref.read(circleRepositoryProvider).getAllCircles();
       return CircleListState(circles: circles);
     }
   }
   ```

4. **Screen作成** (`lib/views/screens/circle_list_screen.dart`)
   - `AsyncValue`で状態監視
   - `ListView.builder`で表示（仮想化なし）
   - 各アイテム: `ListTile`でサークル名・スペース番号のみ表示
   - タップ処理なし（Phase 2で実装）

5. **ルーティング変更** (`lib/app_router.dart`)
   ```dart
   StatefulShellBranch(
     navigatorKey: _circleListNavigationKey,
     routes: [
       GoRoute(
         path: '/circleList',  // ← '/mapList'から変更
         builder: (context, state) => const CircleListScreen(),
       ),
     ],
   ),
   ```

#### 動作確認項目
- [ ] アプリ起動時にサークルタブが表示される
- [ ] サークル一覧が表示される（サークル名、スペース番号）
- [ ] タブ切り替えで配置図タブと行き来できる

#### 注意事項
- **エラーハンドリング**: 最小限（AsyncErrorで表示のみ）
- **パフォーマンス**: 100件以下を想定（仮想化は後回し）
- **UI/UX**: 実用最低限（装飾は後回し）

---

### Phase 2: CircleBottomSheet連携

**目標**: リストアイテムタップでサークル詳細を表示

#### 実装内容

1. **Screen修正** (`lib/views/screens/circle_list_screen.dart`)
   - `ListTile`の`onTap`実装
   - `showModalBottomSheet`で`CircleBottomSheet`表示
   - `CircleBottomSheet`の`mapId`引数に注意（サークルデータから取得）

#### 動作確認項目
- [ ] アイテムタップでBottomSheetが開く
- [ ] サークル情報が正しく表示される
- [ ] 編集・削除が機能する
- [ ] BottomSheet閉じた後、リストが更新される

#### 注意事項
- **mapId渡し**: `circle.mapId`を使用
- **リスト更新**: BottomSheet閉じた後の`ref.invalidate`実装

---

### Phase 3: ソート機能

**目標**: サークル名・スペース番号・isDone順でソート

#### 実装内容

1. **State拡張** (`lib/states/circle_list_state.dart`)
   ```dart
   enum SortType { name, spaceNo, isDone }

   @freezed
   class CircleListState with _$CircleListState {
     const factory CircleListState({
       required List<CircleDetail> circles,
       @Default(SortType.name) SortType sortType,  // 追加
     }) = _CircleListState;
   }
   ```

2. **ViewModel拡張** (`lib/viewModels/circle_list_view_model.dart`)
   - `setSortType(SortType type)` メソッド追加
   - ソートロジック実装（Dart標準の`sort`使用）

3. **Screen拡張** (`lib/views/screens/circle_list_screen.dart`)
   - AppBarに`PopupMenuButton`追加
   - ソートタイプ選択UI

#### 動作確認項目
- [ ] ソートメニューが表示される
- [ ] サークル名順でソートされる
- [ ] スペース番号順でソートされる
- [ ] isDone順でソートされる（未完了→完了）

#### 注意事項
- **null処理**: サークル名・スペース番号がnullの場合は末尾に配置
- **昇順のみ**: 降順は実装しない（シンプル化）

---

### Phase 4: フィルター機能

**目標**: isDone状態・配置図でフィルタリング

#### 実装内容

1. **State拡張** (`lib/states/circle_list_state.dart`)
   ```dart
   enum FilterType { all, done, notDone }

   @freezed
   class CircleListState with _$CircleListState {
     const factory CircleListState({
       required List<CircleDetail> circles,
       @Default(SortType.name) SortType sortType,
       @Default(FilterType.all) FilterType filterType,  // 追加
       int? selectedMapId,  // 追加（null = 全配置図）
     }) = _CircleListState;
   }
   ```

2. **ViewModel拡張** (`lib/viewModels/circle_list_view_model.dart`)
   - `setFilterType(FilterType type)` メソッド追加
   - `setMapFilter(int? mapId)` メソッド追加
   - フィルタリングロジック実装

3. **Screen拡張** (`lib/views/screens/circle_list_screen.dart`)
   - フィルターチップUI追加（`FilterChip`使用）
   - 配置図選択ドロップダウン追加（`DropdownButton`）

#### 動作確認項目
- [ ] 全サークル表示される（デフォルト）
- [ ] 完了済みのみフィルタリングされる
- [ ] 未完了のみフィルタリングされる
- [ ] 特定配置図のサークルのみ表示される
- [ ] フィルター + ソート併用が機能する

#### 注意事項
- **複数フィルター**: isDoneと配置図は同時適用可能
- **UI配置**: AppBar下に`FilterChip`を配置（画面上部固定）

---

### Phase 5: 仮想リスト化（パフォーマンス最適化）

**目標**: 大量データ（1000件以上）でもスムーズにスクロール

#### 実装内容

1. **ListView.builder最適化** (`lib/views/screens/circle_list_screen.dart`)
   - `addAutomaticKeepAlives: false` 追加
   - `addRepaintBoundaries: true` 追加
   - `cacheExtent: 100` 設定（画面外100px先まで事前レンダリング）

2. **画像読み込み最適化**（アイテムにサムネイル表示する場合）
   - `Image.file`の`cacheWidth`/`cacheHeight`設定
   - `errorBuilder`でフォールバック画像表示

3. **状態最適化**
   - `const`コンストラクタ活用
   - 不要な`setState`削減

#### 動作確認項目
- [ ] 1000件のサークルでスムーズにスクロール（60fps）
- [ ] メモリ使用量が許容範囲内（Android Studio Profiler確認）
- [ ] 画像がスクロール中に遅延なく表示される

#### 注意事項
- **測定ツール**: Android Studio Performance Profilerで確認
- **目標FPS**: 60fps（スクロール時）
- **メモリ**: 100MB以下増加を目標

---

## 技術的考慮事項

### 既存実装との整合性

1. **CircleBottomSheet再利用**
   - `mapId`を動的に渡す必要がある
   - `circle.mapId`から取得

2. **ErrorHandler統合**
   - 既存の`ErrorHandler.handleError()`を使用
   - ユーザーフレンドリーなエラーメッセージ表示

3. **code_generation**
   - 全ての変更後に`dart run build_runner build --delete-conflicting-outputs`実行

### データベース設計

- **新規テーブル**: 不要（既存`circle_detail`テーブル使用）
- **新規カラム**: 不要
- **インデックス**: パフォーマンス問題発生時に検討（Phase 5で必要に応じて）

### パフォーマンス目標

| 項目 | 目標値 | 測定方法 |
|------|--------|----------|
| 初回ロード時間 | < 1秒（100件） | Stopwatch計測 |
| スクロールFPS | 60fps | Flutter DevTools |
| メモリ増加 | < 100MB | Android Studio Profiler |

---

## 実装順序（推奨）

```
Phase 1 → 動作確認 → Phase 2 → 動作確認 → Phase 3 → 動作確認 → Phase 4 → 動作確認 → Phase 5
```

**各フェーズ後に必ず動作確認を実施すること**

---

## UI/UXガイドライン（最小限）

### Phase 1-2 (MVP)
- Material Design 3準拠（Flutterデフォルト）
- `ListTile`標準レイアウト
- エラー時は`SnackBar`表示

### Phase 3-4 (機能拡張)
- ソート/フィルターはAppBarまたはその下に配置
- 選択中の状態を視覚的にフィードバック（色変更など）

### Phase 5 (最適化)
- ローディング時は`CircularProgressIndicator`表示
- 画像ロード失敗時はプレースホルダー表示

---

## リスク管理

### 既知の制約
- Android限定（iOS未検証）
- シングルユーザー（同期不要）
- オフライン専用（ネットワーク処理なし）

### 潜在的な問題
1. **大量データ**: 10,000件超で遅延の可能性 → Phase 5で対処
2. **画像メモリ**: サムネイル多数表示時のOOM → `cacheWidth`で対処
3. **ソート/フィルター複合**: ロジック複雑化 → 単体テスト推奨（任意）

---

## 完了定義（Definition of Done）

各フェーズ完了時に以下を満たすこと:

- [ ] コードが正常にビルドされる
- [ ] 動作確認項目が全てパスする
- [ ] エラー時にアプリがクラッシュしない（SnackBarで通知）
- [ ] タブ切り替えで配置図タブとの行き来が正常

---

## 参考情報

### 既存実装パターン
- **MapListScreen**: 配置図一覧画面の実装参考（`lib/views/screens/map_list_screen.dart:14-346`）
- **CircleBottomSheet**: サークル詳細表示（`lib/views/widgets/circle_bottom_sheet.dart:13-196`）
- **CircleRepository**: データアクセス層（`lib/repositories/circle_repository.dart:10-272`）

### Flutter公式ドキュメント
- ListView.builder: https://api.flutter.dev/flutter/widgets/ListView-class.html
- Riverpod code generation: https://riverpod.dev/docs/concepts/about_code_generation
- Go Router: https://pub.dev/packages/go_router

---

## 次のアクション

**Phase 1から実装開始:**
1. `CircleRepository.getAllCircles()` メソッド追加
2. State/ViewModel作成
3. CircleListScreen実装
4. app_router.dart修正
5. `dart run build_runner build --delete-conflicting-outputs` 実行
6. 動作確認

---

**作成日**: 2025-12-27
**対象バージョン**: Flutter 3.x, Riverpod 2.x
**開発環境**: Android限定
