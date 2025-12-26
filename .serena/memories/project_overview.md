# Circle Marker プロジェクト概要

## プロジェクト目的

Circle Marker は、イベントマップ（同人誌即売会のフロアレイアウトなど）を管理するための Flutter アプリケーションです。
ユーザーはマップ画像をアップロードし、特定の場所（サークル/ブース）にマーカーを配置して、各サークルの情報（画像、説明、完了ステータス）を追跡できます。

## テックスタック

### フレームワーク・言語
- **Flutter** (Dart SDK: ^3.8.1)
- **アプリバージョン**: 1.0.0+1

### 主要ライブラリ

#### 状態管理・コード生成
- `hooks_riverpod` (2.6.1): 状態管理（React フック風 API）
- `riverpod_annotation` + `riverpod_generator`: Riverpod コード生成
- `freezed` + `freezed_annotation`: 不変モデルの生成
- `json_serializable`: JSON シリアライゼーション

#### データ永続化
- `sqflite` (2.4.2): SQLite データベース（現在のバージョン: 4）
- `path_provider` (2.1.5): ファイルシステムパス取得

#### ルーティング
- `go_router` (16.1.0): 宣言的ルーティング

#### UI・画像関連
- `image_picker` (1.1.2): 画像選択（ギャラリー/カメラ）
- `photo_view` (0.15.0): ズーム可能な画像ビューアー
- `flutter_image_compress` (2.1.0): 画像圧縮
- `flutter_linkify` + `url_launcher`: 説明文内のクリック可能なリンク
- `gap` (3.0.1): スペーシングウィジェット

#### 開発ツール
- `flutter_lints` (5.0.0): 推奨リントセット
- `build_runner` (2.4.12): コード生成ランナー
- `flutter_launcher_icons` (0.14.4): アプリアイコン生成

## アーキテクチャ概要

### ディレクトリ構成
```
lib/
├── models/           # Freezed による不変データモデル
├── states/           # Freezed による状態クラス
├── viewModels/       # @riverpod による ViewModel（ビジネスロジック）
├── repositories/     # @riverpod によるデータアクセス層
├── providers/        # Riverpod プロバイダー
├── views/
│   ├── screens/      # 画面単位の UI
│   └── widgets/      # 再利用可能なウィジェット
├── utils/            # ユーティリティ関数
├── exceptions/       # カスタム例外クラス
├── database_helper.dart  # SQLite データベース管理（シングルトン）
└── app_router.dart   # go_router ルーティング定義
```

### データベース構造
- **map_detail テーブル**: マップ情報（mapId, title, baseImagePath, thumbnailPath）
- **circle_detail テーブル**: サークル/ブースマーカー（位置、サイズ、ポインター、画像、メタデータ、isDone ステータス）

### 座標系
1. **元画像座標**: データベースに保存（positionX/Y, pointerX/Y, sizeWidth/Height）
2. **表示座標**: BoxFit.contain を考慮して実行時に計算

`PixelPositioned` ウィジェットがこの変換を透過的に処理します。

## プラットフォーム
- Android
- iOS
- Windows
- macOS
- Linux
- Web

（開発環境: Windows）
