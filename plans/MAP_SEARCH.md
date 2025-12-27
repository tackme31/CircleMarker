# MapListScreen 検索機能 実装仕様書

## 概要

MapListScreenにマップタイトルのSQLベース部分一致検索機能を追加し、ユーザーが多数のマップから目的のマップを素早く見つけられるようにする。将来的な仮想リスト（無限スクロール）への移行を見据え、Repository層でのSQLクエリによるフィルタリングを採用する。

## 目的

- 大量のマップが登録された状態でも、目的のマップを素早く検索できるようにする
- SQLクエリレベルでのフィルタリングにより、メモリ効率を最適化
- 仮想リスト（ページネーション・無限スクロール）への将来的な移行を容易にする
- モバイルデバイスでの使いやすさを重視したシンプルなUI/UX

## ユーザーストーリー

```
ユーザーとして、
MapListScreen上部の検索ボックスにマップ名を入力し、
検索ボタンまたはSubmitキーを押すことで、
入力したキーワードに部分一致するマップのみを表示したい。
```

## 機能要件

### 1. UI要件

#### 1.1 検索バーの配置
- **位置**: AppBarの下、マップリストの上部
- **デザイン**: Material Design 3のTextFieldウィジェット使用
- **要素**:
  - テキスト入力フィールド（プレースホルダー: "マップを検索"）
  - 検索アイコン（prefixIcon）
  - クリアボタン（suffixIcon、テキスト入力時のみ表示）

#### 1.2 検索動作
- **トリガー**:
  - ソフトウェアキーボードのSubmitボタン（検索ボタン）押下
  - TextFieldのonSubmittedコールバック
- **リアルタイム検索は不採用**:
  - パフォーマンス最適化のため、明示的なSubmit操作を必須とする
  - DB検索の頻度を抑制し、バッテリー消費を最小化

#### 1.3 検索結果表示
- 検索結果が0件の場合: 「検索結果がありません」メッセージを中央に表示
- 検索クエリが空の場合: 全マップを表示（降順、最新順）
- 検索実行中: 既存のAsyncValueパターンに従ったローディング表示

### 2. 機能要件

#### 2.1 検索ロジック
- **検索対象**: map_detail.title カラム
- **検索方式**: SQL LIKE句による部分一致
  - SQLite構文: `WHERE title LIKE '%query%'`
  - 大文字小文字を区別しない（SQLiteのLIKEはデフォルトでcase-insensitive）
- **検索範囲**: map_detailテーブル全体

#### 2.2 検索状態管理
- 検索クエリはMapListStateに保持
- 検索実行時はViewModelのメソッドを呼び出し、Repository経由でDB検索を実行
- 検索クエリのクリア機能を提供

## 技術設計

### 1. アーキテクチャ変更

#### 1.1 Repository変更
**ファイル**: `lib/repositories/map_repository.dart`

**追加メソッド**:

```dart
/// タイトルによる部分一致検索
///
/// [query]が空の場合は全件取得と同じ動作
/// SQLiteのLIKE句を使用した部分一致検索（case-insensitive）
Future<List<MapDetail>> searchMapsByTitle(String query) async {
  try {
    final db = await _ref.read(databaseProvider.future);

    final normalizedQuery = query.trim();

    if (normalizedQuery.isEmpty) {
      // 検索クエリが空の場合は全件取得
      return getMapDetails();
    }

    // LIKE句による部分一致検索
    // SQLiteのLIKEはデフォルトでcase-insensitiveだが、明示的にLOWER()を使用して保証
    final maps = await db.query(
      _tableName,
      where: 'LOWER(title) LIKE LOWER(?)',
      whereArgs: ['%$normalizedQuery%'],
      orderBy: 'mapId DESC',
    );

    return maps.map(MapDetail.fromJson).toList();
  } on sqflite.DatabaseException catch (e) {
    throw AppException('Failed to search maps', e);
  } on AppException {
    rethrow;
  } on Exception catch (e) {
    throw AppException('Unexpected error while searching maps', e);
  }
}
```

**設計判断**:
- `LOWER(title) LIKE LOWER(?)`で明示的にcase-insensitiveを保証
- `%query%`でワイルドカード検索を実現
- 空クエリは既存の`getMapDetails()`を呼び出して重複コード削減
- orderBy条件は既存の`getMapDetails()`と統一（mapId DESC）

#### 1.2 State変更
**ファイル**: `lib/states/map_list_state.dart`

```dart
@freezed
class MapListState with _$MapListState {
  const factory MapListState({
    @Default([]) List<MapDetail> maps,
    @Default('') String searchQuery,  // 追加: 検索クエリ
  }) = _MapListState;
}
```

**変更内容**:
- `searchQuery`: 現在の検索クエリを保持（UI表示と状態復元に使用）
- `allMaps`は不要（SQLで都度検索するため）

#### 1.3 ViewModel変更
**ファイル**: `lib/viewModels/map_list_view_model.dart`

```dart
@riverpod
class MapListViewModel extends _$MapListViewModel {
  @override
  Future<MapListState> build() async {
    final maps = await ref.watch(mapRepositoryProvider).getMapDetails();
    return MapListState(maps: maps, searchQuery: '');
  }

  /// マップタイトルで検索
  ///
  /// Repository層のSQL検索を呼び出し、結果でstateを更新
  Future<void> searchMaps(String query) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final maps = await ref
          .read(mapRepositoryProvider)
          .searchMapsByTitle(query);

      return MapListState(maps: maps, searchQuery: query);
    });
  }

  /// 検索をクリア
  void clearSearch() {
    searchMaps('');
  }

  // 既存メソッドは変更不要
  Future<MapDetail> addMapDetail(String imagePath) async {
    try {
      final imagePaths = await ref
          .read(imageRepositoryProvider.notifier)
          .saveMapImageWithThumbnail(imagePath);

      final mapDetail = MapDetail(
        title: 'New Map',
        baseImagePath: imagePaths.original,
        thumbnailPath: imagePaths.thumbnail,
      );
      final insertedMap = await ref
          .read(mapRepositoryProvider)
          .insertMapDetail(mapDetail);

      // 現在の検索クエリで再検索
      final currentState = state.value;
      await searchMaps(currentState?.searchQuery ?? '');

      return insertedMap;
    } on ImageOperationException catch (e) {
      debugPrint('Failed to add map: $e');
      rethrow;
    }
  }

  Future<void> removeMap(int mapId) async {
    await ref.read(mapRepositoryProvider).deleteMapDetail(mapId);
    await ref.read(circleRepositoryProvider).deleteCircles(mapId);

    // 現在の検索クエリで再検索
    final currentState = state.value;
    await searchMaps(currentState?.searchQuery ?? '');

    // サークルリストも更新
    ref.invalidate(circleListViewModelProvider);
  }
}
```

**設計判断**:
- `searchMaps()`はAsync操作でRepository検索を実行
- `AsyncValue.guard()`でエラーハンドリングを統一
- `addMapDetail()`と`removeMap()`は検索クエリを保持したまま再検索
- state.loadingを経由することで、検索中のUI表示を可能にする

#### 1.4 Screen変更
**ファイル**: `lib/views/screens/map_list_screen.dart`

**追加要素**:
1. **TextEditingController**: 検索テキストの管理
2. **検索バーWidget**: AppBarとbody間に配置
3. **検索ロジックの呼び出し**: onSubmittedコールバック
4. **検索結果0件の表示**: 空リスト時の専用Widget

**実装パターン**:
```dart
class _MapListScreenState extends ConsumerState<MapListScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onSearchSubmitted(String query) async {
    await ref.read(mapListViewModelProvider.notifier).searchMaps(query);
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(mapListViewModelProvider.notifier).clearSearch();
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'マップを検索',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSearch,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: _onSearchSubmitted,
        onChanged: (value) {
          setState(() {}); // suffixIconの表示切り替え
        },
      ),
    );
  }

  Widget _buildEmptySearchResult() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            '検索結果がありません',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mapListViewModelProvider);
    final ImagePicker picker = ImagePicker();

    return Scaffold(
      appBar: AppBar(
        title: const Text('配置図'),
        actions: [
          IconButton(
            onPressed: _importMap,
            icon: const Icon(Icons.file_upload),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: switch (state) {
              AsyncData(:final value) => value.maps.isEmpty
                  ? _buildEmptySearchResult()
                  : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: RefreshIndicator(
                        onRefresh: () async {
                          final currentQuery = value.searchQuery;
                          await ref
                              .read(mapListViewModelProvider.notifier)
                              .searchMaps(currentQuery);
                        },
                        child: ListView.separated(
                          separatorBuilder: (context, index) => const Gap(12),
                          itemCount: value.maps.length,
                          itemBuilder: (context, index) {
                            final map = value.maps[index];
                            // 既存のCard実装...
                            return Card(/* ... */);
                          },
                        ),
                      ),
                    ),
              AsyncError(:final error) => Center(
                  child: Text('Something went wrong: $error'),
                ),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add',
        onPressed: () => _addMap(picker),
        child: const Icon(Icons.add),
      ),
    );
  }

  // 既存メソッド（_deleteMap, _addMap等）は変更不要
}
```

### 2. 実装上の考慮事項

#### 2.1 パフォーマンス
- **SQLインデックス**: 将来的に大量データ対応として`title`カラムにインデックス作成を検討
  ```sql
  CREATE INDEX idx_map_detail_title ON map_detail(title);
  ```
- **LIKE検索の最適化**:
  - 前方一致の場合は`LIKE 'query%'`でインデックスを活用可能
  - 現仕様は部分一致`LIKE '%query%'`のため、全件スキャンが発生
  - 数千件規模までは問題なし、それ以上は全文検索（FTS5）への移行を検討

#### 2.2 仮想リスト対応の準備
現在の設計は将来的に以下の変更で仮想リスト対応が可能：

```dart
// 将来の拡張例
Future<List<MapDetail>> searchMapsByTitle(
  String query, {
  int limit = 20,
  int offset = 0,
}) async {
  final maps = await db.query(
    _tableName,
    where: 'LOWER(title) LIKE LOWER(?)',
    whereArgs: ['%$query%'],
    orderBy: 'mapId DESC',
    limit: limit,
    offset: offset,
  );
  return maps.map(MapDetail.fromJson).toList();
}
```

#### 2.3 ユーザビリティ（Material Design for Mobile）
- **タップターゲットサイズ**: 検索バーとクリアボタンは48dp以上確保
- **キーボード動作**:
  - `TextInputAction.search`によりキーボードに「検索」ボタン表示
  - onSubmitted後、キーボードは自動的に閉じない（連続検索を考慮）
- **フィードバック**:
  - 検索結果0件時はアイコン付きメッセージ表示
  - 検索中は`CircularProgressIndicator`によるローディング表示
  - RefreshIndicatorは現在の検索クエリを保持したまま再検索

#### 2.4 状態の整合性
- **addMapDetail時**: 現在の検索クエリで再検索（新規マップが検索条件に合致すれば表示）
- **removeMap時**: 現在の検索クエリで再検索（削除後の結果を正確に表示）
- **検索クエリ保持**: RefreshIndicator実行時も検索状態を維持

#### 2.5 エラーハンドリング
- Repository層で`AppException`スロー
- ViewModel層で`AsyncValue.guard()`によるキャッチ
- UI層で`AsyncError`として表示
- title == nullの場合: SQLのLIKE検索ではNULLマッチしない（問題なし）

### 3. データベース設計

#### 3.1 現在のスキーマ（変更不要）
```sql
CREATE TABLE map_detail (
  mapId INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT,
  baseImagePath TEXT,
  thumbnailPath TEXT
);
```

#### 3.2 将来的な最適化（オプション）
大量データ対応時にインデックス追加を検討：

```sql
-- マイグレーションで追加
CREATE INDEX idx_map_detail_title ON map_detail(title);
```

または全文検索テーブル（FTS5）の導入：

```sql
-- 高度な検索が必要な場合
CREATE VIRTUAL TABLE map_detail_fts USING fts5(
  title,
  content='map_detail',
  content_rowid='mapId'
);
```

### 4. テストケース
- [ ] キーボードの検索ボタンで検索実行
- [ ] 日本語入力での検索
- [ ] 検索→マップ追加→自動再検索の確認
- [ ] 検索→マップ削除→自動再検索の確認
- [ ] RefreshIndicatorでの再検索
- [ ] 検索結果0件時の表示確認

## 実装順序

### Phase 1: Repository層実装
1. `MapRepository`に`searchMapsByTitle()`メソッド追加
2. エラーハンドリングの実装

### Phase 2: State/ViewModel層実装
4. `MapListState`に`searchQuery`フィールド追加
5. `MapListViewModel`に`searchMaps()`と`clearSearch()`メソッド追加
6. 既存の`addMapDetail()`と`removeMap()`を修正して再検索対応

### Phase 3: UI層実装
8. `MapListScreen`に`TextEditingController`追加
9. `_buildSearchBar()`メソッド実装
10. `_buildEmptySearchResult()`メソッド実装
11. bodyをColumnに変更し、検索バーを配置
12. RefreshIndicator修正（検索クエリ保持）

### Phase 4: 統合・最終確認
13. コード生成: `dart run build_runner build --delete-conflicting-outputs`
14. 静的解析: `flutter analyze`
15. 実機テスト

## セキュリティ考慮事項

### SQLインジェクション対策
- **準備されたステートメント（Prepared Statements）使用**:
  ```dart
  // ✅ 安全: whereArgsでパラメータバインド
  db.query(_tableName, where: 'title LIKE ?', whereArgs: ['%$query%'])

  // ❌ 危険: 文字列結合（使用禁止）
  db.query(_tableName, where: "title LIKE '%$query%'")
  ```
- sqfliteは自動的にパラメータをエスケープするため、SQLインジェクションのリスクなし

## パフォーマンス指標

### 想定データ規模別の性能
- **〜100件**: 問題なし（体感遅延なし）
- **100〜1,000件**: 問題なし（数十ms程度）
- **1,000〜10,000件**: LIKE検索で100ms程度（インデックス推奨）
- **10,000件〜**: FTS5全文検索への移行推奨

### 将来的な最適化オプション
1. **段階1（現在）**: LIKE検索
2. **段階2（1,000件以上）**: インデックス追加
3. **段階3（10,000件以上）**: FTS5全文検索テーブル
4. **段階4（さらなる大規模化）**: 仮想リスト+ページネーション

## 参考実装

- `CircleListScreen`: フィルタリング・ソート機能のUI/UXパターン
- `CircleListViewModel`: 状態管理の実装パターン
- `CircleRepository`: Repository層のエラーハンドリングパターン
- Material Design 3: TextFieldコンポーネントのガイドライン
- SQLite公式ドキュメント: LIKE演算子の仕様

---

**作成日**: 2025-12-27
**対象バージョン**: Flutter 3.x / Riverpod 2.x / SQLite 3.x
**担当**: Mobile Development Specialist
**設計方針**: Repository層でのSQL検索、仮想リスト対応を見据えたスケーラブル設計
