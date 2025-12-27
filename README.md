# Circle Marker

サークル配置図上にサークル情報をマッピングすることができるFlutterアプリです。

完全オフラインで動作するので、回線が不安定な会場でも快適にサークル情報を確認できます。

デモ: https://x.com/tackme31/status/1955931157658526019

> ⚠️ **注意**
>
> 本プロジェクトは個人用として作成されたものです。利用は自己責任でお願いします。

## 主な機能

- 配置図のアップロードと管理
- 配置図上へのサークル情報の配置・移動
- サークル情報の記録（画像、サークル名、スペース番号、説明、メモなど）
- サークル一覧の表示・フィルタリング・ソート
- マップデータのインポート・エクスポート（ZIP形式）
- マークダウン形式での出力

## セットアップ

```bash
# 依存関係のインストール
flutter pub get

# コード生成（Riverpod、Freezed、JSON serialization）
dart run build_runner build --delete-conflicting-outputs

# アプリの実行
flutter run
```

## 作者

Takumi Yamada ([@tackme31](https://x.com/tackme31))