# Circle Marker 推奨コマンド

## 開発に必須のコマンド

### コード生成（重要！）
```bash
# @riverpod, @freezed, @JsonSerializable クラスを変更した後は必ず実行
dart run build_runner build --delete-conflicting-outputs

# 開発中の継続的な生成（ウォッチモード）
dart run build_runner watch --delete-conflicting-outputs
```

### 依存関係管理
```bash
# 依存関係のインストール
flutter pub get

# 依存関係の更新
flutter pub upgrade
```

### アプリの実行
```bash
# 接続されたデバイス/エミュレーターで実行
flutter run

# 特定のデバイスで実行
flutter run -d <device-id>
```

### テスト・リント
```bash
# 静的解析
flutter analyze

# テスト実行
flutter test

# 特定のテストファイルを実行
flutter test test/widget_test.dart
```

### アイコン生成
```bash
# assets/icons/app_icon.png からランチャーアイコンを生成
flutter pub run flutter_launcher_icons
```

## Windows 固有のユーティリティコマンド

```powershell
# ディレクトリ一覧
dir

# ディレクトリ移動
cd <path>

# ファイル検索
dir /s /b <pattern>

# 文字列検索（findstr）
findstr /s /i "検索文字列" *.dart

# Git コマンド
git status
git log --oneline
git diff
```

## タスク完了時に実行すべきコマンド

1. **コード生成が必要な変更の場合**: `dart run build_runner build --delete-conflicting-outputs`
2. **静的解析**: `flutter analyze`
3. **テスト**: `flutter test`
4. **コミット前**: 上記すべてを実行

## プロジェクト特有の注意事項

- `.g.dart` および `.freezed.dart` ファイルは**絶対に手動編集しない**（自動生成ファイル）
- `analysis_options.yaml` で生成ファイルは除外済み
- コード変更後は必ず `build_runner` を実行すること
