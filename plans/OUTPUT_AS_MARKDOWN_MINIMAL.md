# サークル一覧 Markdown 出力機能 ミニマル設計書

## 概要

Circle Marker アプリにおいて、マップに含まれるサークル一覧を Markdown 形式で出力する機能を実装する。
**個人用・Android 専用の最低限動作する実装**を目指し、複雑なエラーハンドリングや最適化は後回しにする。

## 前提条件

- **利用者**: 開発者本人のみ
- **対応プラットフォーム**: Android のみ（iOS は考慮不要）
- **品質要件**: エラーが出ても許容、使い勝手は二の次
- **目標**: まず動くものを作る → 後から改善

## ミニマル要件

### 1. Markdown 出力機能

- マップ単位でのサークル一覧出力
    - **SpaceNoの昇順**で出力
- 指定フォーマットでの Markdown 生成
- 共有機能（share_plus）によるテキスト共有
- クリップボードコピー対応

### 2. 出力フォーマット

```markdown
## {map name}
### {circle name} ({space no})
{description}

{note}
```

**フォーマット詳細:**

- マップタイトルは `##`（H2）
- 各サークルは `###`（H3）でサークル名とスペース番号を表示
- description（説明文）を次の行に出力
  - 空の場合は出力しない
- 空行を挟む
  - description または note が空の場合、空行は出力しない
- note（メモ）を次の行に出力
  - 空の場合は出力しない

**出力例:**

```markdown
## C108 東123
### サークル A (A-21b)
新刊のイラスト集を頒布します

当日は東ホールです

### サークル B (B-34a)
要チェック！早めに行く
```

### 3. UI 統合

- **導線**: `MapListScreen` の各マップの `PopupMenuButton` 内に「Markdown で出力」メニュー項目を追加
- **確認ダイアログ**: 不要（タップで即座に出力・共有）
- **共有画面**: システムの共有ダイアログを表示し、クリップボードコピーを選択肢として含める

## データベーススキーマ（再掲）

### map_detail テーブル

```sql
CREATE TABLE map_detail(
  mapId INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  baseImagePath TEXT NOT NULL,
  thumbnailPath TEXT
)
```

### circle_detail テーブル

```sql
CREATE TABLE circle_detail(
  circleId INTEGER PRIMARY KEY AUTOINCREMENT,
  positionX INTEGER NOT NULL,
  positionY INTEGER NOT NULL,
  sizeWidth INTEGER NOT NULL,
  sizeHeight INTEGER NOT NULL,
  pointerX INTEGER NOT NULL,
  pointerY INTEGER NOT NULL,
  mapId INTEGER NOT NULL,
  circleName TEXT NOT NULL,
  spaceNo TEXT NOT NULL,
  imagePath TEXT,
  menuImagePath TEXT,
  note TEXT,
  description TEXT,
  color TEXT,
  isDone INTEGER NOT NULL DEFAULT 0,
  FOREIGN KEY (mapId) REFERENCES map_detail(mapId)
)
```

## 実装設計（ミニマル版）

### 新規作成ファイル

#### 1. `lib/repositories/markdown_output_repository.dart`

Markdown 出力処理を行うリポジトリ。

**主要メソッド:**

- `Future<String> generateMarkdown(int mapId)` - マップ ID からサークル一覧の Markdown を生成

**実装の簡略化ポイント:**

- エラーハンドリングは最低限（throw するだけ、ViewModel でキャッチ）
- ソート順は DB のデフォルト順（circleId 順）
- 空フィールドの扱いは単純に空行として出力

**実装例（概略）:**

```dart
@Riverpod(keepAlive: true)
MarkdownOutputRepository markdownOutputRepository(MarkdownOutputRepositoryRef ref) {
  return MarkdownOutputRepository(
    mapRepository: ref.watch(mapRepositoryProvider),
    circleRepository: ref.watch(circleRepositoryProvider),
  );
}

class MarkdownOutputRepository {
  final MapRepository mapRepository;
  final CircleRepository circleRepository;

  MarkdownOutputRepository({
    required this.mapRepository,
    required this.circleRepository,
  });

  Future<String> generateMarkdown(int mapId) async {
    // 1. データ取得
    final mapDetail = await mapRepository.getMap(mapId);
    final circles = await circleRepository.getCircles(mapId);

    // 2. Markdown 生成
    final buffer = StringBuffer();

    // マップタイトル
    buffer.writeln('## ${mapDetail.title}');

    // 各サークル
    for (final circle in circles) {
      // サークル名とスペース番号
      buffer.writeln('### ${circle.circleName} (${circle.spaceNo})');

      // description（空でも出力）
      buffer.writeln(circle.description ?? '');
      buffer.writeln(); // 空行

      // note（空でも出力）
      buffer.writeln(circle.note ?? '');
      buffer.writeln(); // サークル間の空行
    }

    return buffer.toString();
  }
}
```

#### 2. `lib/viewModels/markdown_output_view_model.dart`

Markdown 出力の ViewModel。

**状態管理（簡略版）:**

```dart
@freezed
class MarkdownOutputState with _$MarkdownOutputState {
  const factory MarkdownOutputState({
    @Default(false) bool isGenerating,
    String? errorMessage,
  }) = _MarkdownOutputState;
}
```

**主要メソッド:**

```dart
@riverpod
class MarkdownOutputViewModel extends _$MarkdownOutputViewModel {
  @override
  MarkdownOutputState build() {
    return const MarkdownOutputState();
  }

  Future<void> generateAndShare(int mapId) async {
    state = state.copyWith(isGenerating: true, errorMessage: null);

    try {
      final repository = ref.read(markdownOutputRepositoryProvider);
      final markdown = await repository.generateMarkdown(mapId);

      // 共有
      await Share.share(
        markdown,
        subject: 'サークル一覧',
      );

      state = state.copyWith(isGenerating: false);
    } catch (e) {
      state = state.copyWith(
        isGenerating: false,
        errorMessage: 'Markdown 出力失敗: $e',
      );
    }
  }
}
```

### 既存ファイルの修正

#### 3. `lib/views/screens/map_list_screen.dart`

`PopupMenuButton` に「Markdown で出力」メニュー項目を追加。

**修正箇所:**

各マップの `PopupMenuButton` の `itemBuilder` に新しいメニュー項目を追加：

```dart
PopupMenuButton<String>(
  onSelected: (value) async {
    if (value == 'delete') {
      // 既存の削除処理
      final shouldDelete = await showDialog<bool>(/* ... */);
      // ...
    } else if (value == 'markdown') {
      // Markdown 出力処理
      await ref
          .read(markdownOutputViewModelProvider.notifier)
          .generateAndShare(mapDetail.mapId);

      // エラー時のスナックバー表示（オプション）
      final state = ref.read(markdownOutputViewModelProvider);
      if (state.errorMessage != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.errorMessage!)),
        );
      }
    }
  },
  itemBuilder: (context) => [
    const PopupMenuItem(
      value: 'markdown',
      child: Text('Markdown で出力'),
    ),
    const PopupMenuItem(
      value: 'delete',
      child: Text('削除'),
    ),
  ],
)
```

## 依存パッケージ

既存の `share_plus` パッケージを使用（追加不要）。

```yaml
dependencies:
  share_plus: ^7.2.0 # 既に追加済み
```

## 実装順序（ミニマル版）

### Phase 1: リポジトリ実装

1. `markdown_output_repository.dart` 作成
2. `generateMarkdown` メソッド実装
3. 簡単な動作確認（デバッグプリント等）

### Phase 2: ViewModel 実装

1. `markdown_output_view_model.dart` 作成
2. 状態管理実装
3. `generateAndShare` メソッド実装
4. `dart run build_runner build --delete-conflicting-outputs` 実行

### Phase 3: UI 統合

1. `map_list_screen.dart` に `PopupMenuButton` の項目追加
2. ViewModel の呼び出し実装
3. エラー表示（オプション）

### Phase 4: 動作テスト

1. マップリスト画面でメニューから「Markdownで出力」を選択
2. 共有ダイアログが表示されることを確認
3. クリップボードにコピーして内容を確認
4. フォーマットが正しいことを確認

## 省略する機能（後回し）

以下は最初のバージョンでは**実装しない**：

- プログレス表示（ローディングインジケーター）
- フィルタリング（isDone のみ、など）
- Markdown フォーマットのカスタマイズ
- ファイル保存機能（共有のみ）
- プレビュー画面
- ユニットテスト・統合テスト

## 今後の改善

ミニマル版が動いた後、以下の優先順位で改善：

1. **フィルタリング** - 未訪問のみ出力など
1. **プレビュー画面** - 共有前に内容を確認
1. **ファイル保存** - テキストファイルとして保存
1. **フォーマットカスタマイズ** - ユーザーが出力形式を選択可能に
1. **テスト追加** - 信頼性向上

## 注意事項

- **Android 専用**のため、iOS の考慮は不要
- **個人用**のため、セキュリティ・バリデーションは最低限
- **エラーが出ても許容**のため、例外はそのまま throw
- **まず動かす**ことが最優先、完璧を目指さない
- Markdown 内の特殊文字エスケープは考慮しない（ユーザーが手動修正）

## 実装時の留意点

### Markdown フォーマットの詳細

- **空フィールドの扱い**: `description` や `note` が null または空文字列の場合でも、空行として出力する
- **改行の扱い**: フィールド内の改行はそのまま保持
- **特殊文字**: Markdown の特殊文字（`#`, `*`, `_` など）はエスケープしない（ミニマル版では省略）

### share_plus の使用

- `Share.share()` は単純にテキストを共有
- Android では自動的にクリップボードコピーが選択肢として表示される
- `subject` パラメータは共有時のタイトルとして使用

---

## 改訂履歴

- **2025-12-26**: ミニマル版設計書作成
