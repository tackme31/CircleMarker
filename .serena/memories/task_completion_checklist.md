# Circle Marker タスク完了時のチェックリスト

## 必須ステップ

### 1. コード生成の実行

**以下のファイルを変更した場合は必須**:
- `@riverpod` アノテーションを持つクラス
- `@freezed` アノテーションを持つクラス
- `@JsonSerializable` アノテーションを持つクラス

```bash
dart run build_runner build --delete-conflicting-outputs
```

**確認ポイント**:
- `.g.dart` ファイルが生成・更新されていること
- `.freezed.dart` ファイルが生成・更新されていること（Freezed クラスの場合）
- ビルドエラーがないこと

### 2. 静的解析

```bash
flutter analyze
```

**確認ポイント**:
- 警告・エラーがゼロであること
- `analysis_options.yaml` の全ルールに準拠していること

### 3. テスト実行

```bash
flutter test
```

**確認ポイント**:
- 全テストがパスすること
- 新規機能に対するテストが追加されていること（該当する場合）

### 4. 手動動作確認

**確認項目**:
- アプリが正常に起動すること
- 変更した機能が期待通り動作すること
- 既存機能に影響がないこと（リグレッションテスト）
- UI が正しく表示されること
- 画像の読み込み・保存が正常に動作すること
- データベースの読み書きが正常に動作すること

### 5. データベース変更時の追加確認

**テーブルやカラムを追加・変更した場合**:
- `DatabaseHelper` のバージョン番号を更新済みか
- `_onUpgrade` にマイグレーションロジックを追加済みか
- `_onCreate` に新規カラムを追加済みか
- 対応するモデルクラス（`@freezed`）を更新済みか
- コード生成を実行済みか

### 6. 画像関連の変更時の追加確認

**画像処理を変更した場合**:
- 画像圧縮設定が適切か（マップサムネイル: 512x512、サークル画像: 300x300）
- 画像パスがデータベースに正しく保存されているか
- 画像ファイルが `path_provider` で取得したディレクトリに保存されているか

### 7. コミット前の最終チェック

```bash
# すべてのチェックを一度に実行
dart run build_runner build --delete-conflicting-outputs && flutter analyze && flutter test
```

**確認ポイント**:
- Git ステージングに不要なファイルが含まれていないか（`.g.dart`, `.freezed.dart` はコミットして良い）
- コミットメッセージが明確で適切か
- 変更内容が意図通りか（`git diff` で確認）

## オプション（推奨）

### コードフォーマット
```bash
dart format lib/ test/
```

### 未使用の import の削除
- IDE の機能を使用（VS Code: "Organize Imports"）

### パフォーマンスプロファイリング（大規模変更時）
```bash
flutter run --profile
```

## トラブルシューティング

### コード生成エラーが出る場合
```bash
# キャッシュをクリアして再生成
flutter clean
flutter pub get
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### アナライザーエラーが解決しない場合
- `.g.dart` と `.freezed.dart` ファイルが最新か確認
- `flutter pub get` を再実行
- IDE を再起動

### テストが失敗する場合
- モデルの変更に応じてテストを更新
- モックデータの整合性を確認
- データベースマイグレーションロジックを確認
