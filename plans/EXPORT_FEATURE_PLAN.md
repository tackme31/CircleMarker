# マップエクスポート・インポート機能 設計書

## 概要

Circle Marker アプリにおいて、マップ単位でのデータのエクスポート・インポート機能を実装する。
エクスポートにはマップのメタデータ、サークル情報、および関連する全ての画像ファイルが含まれる。

## 要件

### 機能要件

1. **エクスポート機能**

   - マップ単位でのエクスポート
   - DB 情報（map_detail、circle_detail）の保存
   - 関連画像の保存（マップ画像、サムネイル、サークル画像、メニュー画像）
   - エクスポートファイルの共有機能

2. **インポート機能**

   - エクスポートファイルからのマップ復元
   - 画像パスの自動調整
   - 既存データとの競合回避
   - 画像の最適化処理

3. **ユーザー体験**
   - プログレス表示
   - エラーハンドリングとユーザーフィードバック
   - キャンセル機能

## データ構造

### 現在のデータベーススキーマ

#### map_detail テーブル

```sql
CREATE TABLE map_detail(
  mapId INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  baseImagePath TEXT NOT NULL,
  thumbnailPath TEXT
)
```

#### circle_detail テーブル

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

### 画像保存場所

- マップ画像: `<documentsDir>/maps/`
- マップサムネイル: `<documentsDir>/maps/thumbnails/`
- サークル画像: `<documentsDir>/circles/`

画像圧縮設定:

- マップ画像: 元画像をそのままコピー
- マップサムネイル: 512x512 最大、品質 85%
- サークル画像: 300x300 最大、品質 90%

## エクスポートファイル形式

### ファイル構造

エクスポートファイルは `.cmzip` 拡張子の ZIP アーカイブとする。

```
map_export_<mapId>_<timestamp>.cmzip
├── manifest.json          # メタデータとバージョン情報
├── map.json              # マップとサークルのデータ
├── images/
│   ├── map_base.jpg      # マップ画像
│   ├── map_thumb.jpg     # マップサムネイル (存在する場合)
│   └── circles/
│       ├── circle_1.jpg  # サークル画像
│       ├── circle_1_menu.jpg  # メニュー画像
│       ├── circle_2.jpg
│       └── ...
```

### manifest.json 構造

```json
{
  "version": "1.0",
  "exportDate": "2025-12-26T12:34:56.789Z",
  "appVersion": "1.0.0",
  "databaseVersion": 4,
  "mapTitle": "コミックマーケット103"
}
```

### map.json 構造

```json
{
  "map": {
    "title": "コミックマーケット103",
    "baseImagePath": "images/map_base.jpg",
    "thumbnailPath": "images/map_thumb.jpg"
  },
  "circles": [
    {
      "positionX": 100,
      "positionY": 200,
      "sizeWidth": 50,
      "sizeHeight": 50,
      "pointerX": 150,
      "pointerY": 250,
      "circleName": "サークル名",
      "spaceNo": "A-12",
      "imagePath": "images/circles/circle_1.jpg",
      "menuImagePath": "images/circles/circle_1_menu.jpg",
      "note": "メモ",
      "description": "説明文",
      "color": "#FF0000",
      "isDone": 1
    }
  ]
}
```

## 実装設計

### アーキテクチャ

```
UI Layer (Screens/Widgets)
    ↓
ViewModel Layer
    ↓
Repository Layer (MapExportRepository)
    ↓
Service Layer (ExportService, ImportService)
    ↓
Data Sources (Database, File System)
```

### 新規作成ファイル

#### 1. `lib/models/map_export_data.dart`

エクスポート用のデータモデル。

```dart
@freezed
class MapExportData with _$MapExportData {
  const factory MapExportData({
    required MapExportManifest manifest,
    required MapExportContent content,
  }) = _MapExportData;

  factory MapExportData.fromJson(Map<String, dynamic> json) =>
      _$MapExportDataFromJson(json);
}

@freezed
class MapExportManifest with _$MapExportManifest {
  const factory MapExportManifest({
    required String version,
    required String exportDate,
    required String appVersion,
    required int databaseVersion,
    required String mapTitle,
  }) = _MapExportManifest;

  factory MapExportManifest.fromJson(Map<String, dynamic> json) =>
      _$MapExportManifestFromJson(json);
}

@freezed
class MapExportContent with _$MapExportContent {
  const factory MapExportContent({
    required MapExportMapData map,
    required List<CircleExportData> circles,
  }) = _MapExportContent;

  factory MapExportContent.fromJson(Map<String, dynamic> json) =>
      _$MapExportContentFromJson(json);
}

@freezed
class MapExportMapData with _$MapExportMapData {
  const factory MapExportMapData({
    required String title,
    required String baseImagePath,
    String? thumbnailPath,
  }) = _MapExportMapData;

  factory MapExportMapData.fromJson(Map<String, dynamic> json) =>
      _$MapExportMapDataFromJson(json);
}

@freezed
class CircleExportData with _$CircleExportData {
  const factory CircleExportData({
    required int positionX,
    required int positionY,
    required int sizeWidth,
    required int sizeHeight,
    required int pointerX,
    required int pointerY,
    required String circleName,
    required String spaceNo,
    String? imagePath,
    String? menuImagePath,
    String? note,
    String? description,
    String? color,
    required int isDone,
  }) = _CircleExportData;

  factory CircleExportData.fromJson(Map<String, dynamic> json) =>
      _$CircleExportDataFromJson(json);
}
```

#### 2. `lib/repositories/map_export_repository.dart`

エクスポート・インポート処理を行うリポジトリ。

主要メソッド:

- `Future<String> exportMap(int mapId)` - マップをエクスポートしてファイルパスを返す
- `Future<int> importMap(String filePath)` - マップをインポートして新しい mapId を返す
- `Future<MapExportData> _createExportData(int mapId)` - エクスポートデータを作成
- `Future<void> _writeExportFile(MapExportData data, String outputPath)` - ZIP ファイル作成
- `Future<MapExportData> _readImportFile(String filePath)` - ZIP ファイル読み込み
- `Future<int> _saveImportedData(MapExportData data)` - インポートデータを DB に保存

#### 3. `lib/viewModels/map_export_view_model.dart`

エクスポート・インポートの ViewModel。

状態管理:

```dart
@freezed
class MapExportState with _$MapExportState {
  const factory MapExportState({
    @Default(false) bool isExporting,
    @Default(false) bool isImporting,
    @Default(0.0) double progress,
    String? errorMessage,
    String? exportedFilePath,
  }) = _MapExportState;
}
```

主要メソッド:

- `Future<void> exportMap(int mapId)`
- `Future<void> importMap(String filePath)`
- `Future<void> shareExportedMap(String filePath)`

#### 4. `lib/views/widgets/map_export_dialog.dart`

エクスポート・インポート用のダイアログウィジェット。

#### 5. `lib/exceptions/export_exceptions.dart`

エクスポート・インポート関連の例外クラス。

```dart
class ExportException implements Exception {
  final String message;
  final Object? originalException;

  ExportException(this.message, [this.originalException]);
}

class ImportException implements Exception {
  final String message;
  final Object? originalException;

  ImportException(this.message, [this.originalException]);
}

class InvalidExportFormatException extends ImportException {
  InvalidExportFormatException([Object? originalException])
      : super('Invalid export file format', originalException);
}

class UnsupportedVersionException extends ImportException {
  final String fileVersion;
  final String supportedVersion;

  UnsupportedVersionException(this.fileVersion, this.supportedVersion)
      : super('Unsupported export version: $fileVersion (supported: $supportedVersion)');
}
```

### 主要処理フロー

#### エクスポート処理

```
1. ユーザーがエクスポートボタンをタップ
2. MapExportViewModel.exportMap(mapId) を呼び出し
3. MapExportRepository.exportMap(mapId) を実行
   a. MapRepositoryからMapDetailを取得
   b. CircleRepositoryからCircleDetailリストを取得
   c. MapExportDataオブジェクトを作成
   d. 一時ディレクトリにZIPファイルを作成
      - manifest.jsonを書き込み
      - map.jsonを書き込み
      - 画像ファイルをコピー（パスを相対パスに変換）
   e. ZIPファイルを圧縮
   f. 出力先にファイルを移動
4. 成功時、共有ダイアログを表示（share_plus）
5. エラー時、エラーメッセージを表示
```

#### インポート処理

```
1. ユーザーがインポートボタンをタップ
2. file_pickerでファイルを選択
3. MapExportViewModel.importMap(filePath) を呼び出し
4. MapExportRepository.importMap(filePath) を実行
   a. ZIPファイルを解凍
   b. manifest.jsonを読み込み、バージョンチェック
   c. map.jsonを読み込み
   d. トランザクション開始
      i. 画像ファイルを新しいパスにコピー
         - マップ画像: ImageRepository経由で保存（サムネイル再生成）
         - サークル画像: ImageRepository経由で保存（圧縮処理）
      ii. MapDetailをDBに挿入（新しいmapIdを取得）
      iii. CircleDetailリストをDBに挿入（新しいmapIdを使用）
   e. トランザクションコミット
   f. 一時ファイルをクリーンアップ
5. 成功時、新しいマップの詳細画面に遷移
6. エラー時、ロールバックしてエラーメッセージを表示
```

## 考慮事項

### 1. パス管理

**エクスポート時:**

- 絶対パス → ZIP 内の相対パスに変換
- 例: `/data/user/0/.../maps/12345.jpg` → `images/map_base.jpg`

**インポート時:**

- ZIP 内の相対パス → 新しい絶対パスに変換
- ImageRepository の既存ロジックを活用（圧縮・最適化含む）

### 2. データ整合性

**ID の再割り当て:**

- `mapId` と `circleId` は AUTOINCREMENT のため、インポート時に新しい ID が割り当てられる
- エクスポートファイルには元の ID を含めない（不要なため）

**外部キー制約:**

- インポート時、先に MapDetail を挿入して新しい mapId を取得
- 取得した mapId を CircleDetail に設定して挿入

### 3. 画像処理

**メモリ効率:**

- 大量の画像を扱う可能性があるため、ストリーミング処理を使用
- ZIP ライブラリ: `archive` パッケージを使用

**圧縮処理:**

- インポート時、ImageRepository の既存メソッドを再利用
  - `saveMapImageWithThumbnail()`: マップ画像とサムネイル
  - `saveCircleImage()`: サークル画像（圧縮あり）
- これにより、元の画像サイズに関わらず一貫した最適化が適用される

**ファイル名の重複回避:**

- タイムスタンプベースのファイル名を使用（既存の実装と同様）
- 例: `${DateTime.now().millisecondsSinceEpoch}.jpg`

### 4. エラーハンドリング

**部分的な失敗への対応:**

- トランザクションを使用して、失敗時は全てロールバック
- 一時ファイルのクリーンアップを確実に実行（try-finally）

**考えられるエラー:**

- ファイルが見つからない
- ZIP ファイルが破損している
- バージョンの不一致
- ディスク容量不足
- 画像処理の失敗
- データベースエラー

各エラーに対して適切な例外クラスとユーザーメッセージを用意する。

### 5. バージョン管理

**現在のバージョン戦略:**

- `manifest.version`: エクスポートフォーマットのバージョン（"1.0"から開始）
- `manifest.databaseVersion`: データベーススキーマバージョン（現在 4）
- `manifest.appVersion`: アプリバージョン（参考情報）

**互換性チェック:**

- インポート時、manifest のバージョンをチェック
- サポート対象外のバージョンの場合、エラーを表示
- 将来的には、古いバージョンからの移行処理を追加可能

### 6. プログレス表示

**進捗の追跡:**

```dart
enum ExportPhase {
  fetchingData,      // DB読み込み: 10%
  preparingImages,   // 画像準備: 30%
  creatingArchive,   // ZIP作成: 50%
  finalizingExport,  // 完了処理: 10%
}

enum ImportPhase {
  extractingArchive, // ZIP解凍: 20%
  validatingData,    // 検証: 10%
  importingImages,   // 画像処理: 50%
  savingToDatabase,  // DB保存: 20%
}
```

各フェーズで進捗率を更新し、UI に反映。

### 7. ファイル共有

**エクスポート後の共有:**

- `share_plus` パッケージを使用
- プラットフォーム標準の共有ダイアログを表示
- 対応先: メール、クラウドストレージ、メッセージアプリなど

### 8. UI/UX 設計

**エクスポート UI:**

- マップリスト画面: 各マップに「エクスポート」ボタン
- または、マップ詳細画面のメニューに「エクスポート」オプション
- 進捗ダイアログ表示
- 完了後、共有ダイアログ

**インポート UI:**

- マップリスト画面に「インポート」ボタン
- ファイルピッカーで`.cmzip`ファイルを選択
- 進捗ダイアログ表示
- 完了後、新しいマップ詳細画面に遷移

### 9. セキュリティ

**検証:**

- インポート時、ファイルフォーマットの検証
- JSON スキーマの検証
- 画像ファイルの妥当性チェック（破損ファイルの除外）

**サニタイゼーション:**

- ファイル名からパストラバーサル攻撃を防ぐ
- JSON から読み込んだデータのバリデーション

### 10. テスト戦略

**ユニットテスト:**

- MapExportRepository の各メソッド
- データ変換ロジック（MapDetail → MapExportData など）
- パス変換ロジック

**統合テスト:**

- エクスポート → インポートのラウンドトリップテスト
- エラーケースのテスト

**テストデータ:**

- 画像あり・なしの両パターン
- 大量のサークルデータ
- 特殊文字を含むタイトル・説明文

## 依存パッケージ

新たに追加が必要なパッケージ:

```yaml
dependencies:
  archive: ^3.4.0 # ZIP圧縮・解凍
  share_plus: ^7.2.0 # ファイル共有
  file_picker: ^6.1.0 # ファイル選択
  package_info_plus: ^5.0.0 # アプリバージョン取得

dev_dependencies:
  # 既存のテスト関連パッケージを継続使用
```

## 実装順序

1. **Phase 1: モデルと例外クラス**

   - `map_export_data.dart` 作成
   - `export_exceptions.dart` 作成
   - コード生成実行

2. **Phase 2: リポジトリ層**

   - `map_export_repository.dart` 作成
   - エクスポート機能実装
   - インポート機能実装
   - ユニットテスト作成

3. **Phase 3: ViewModel 層**

   - `map_export_view_model.dart` 作成
   - 状態管理実装
   - プログレス管理実装

4. **Phase 4: UI 層**

   - `map_export_dialog.dart` 作成
   - マップリスト画面にボタン追加
   - マップ詳細画面にメニュー追加

5. **Phase 5: 統合とテスト**
   - 統合テスト実施
   - エラーハンドリングの確認
   - UX 改善

## 将来的な拡張

1. **複数マップの一括エクスポート**

   - 選択した複数のマップを 1 つのファイルに

2. **クラウド同期**

   - Google Drive、Dropbox などと連携
   - 自動バックアップ機能

3. **共有プラットフォーム**

   - ユーザー間でマップを共有できるコミュニティ機能

4. **差分インポート**

   - 既存マップへのマージ機能
   - 重複検出とスキップ

5. **圧縮オプション**
   - エクスポート時の画質・サイズ選択

## 参考情報

### 現在の画像圧縮設定

ImageRepository (lib/repositories/image_repository.dart):

- マップサムネイル: 512x512 最大、品質 85%
- サークル画像: 300x300 最大、品質 90%

### データベースバージョン履歴

- Version 1: 初期スキーマ
- Version 2: `circle_detail.menuImagePath` 追加
- Version 3: `circle_detail.color`, `circle_detail.isDone` 追加
- Version 4: `map_detail.thumbnailPath` 追加

この設計により、将来のスキーマ変更にも対応可能な柔軟なエクスポート・インポート機能を実現できます。

---

## モバイル最適化に関する重要な考慮事項

### ⚠️ Critical: メモリ管理の最適化

**問題**: 大量画像の同時読み込みで OOM（Out of Memory）リスク

- 100 サークル × 5MB 画像 = 500MB メモリ使用でクラッシュの可能性

**必須対応**:

#### ストリーミング処理の実装

```dart
// ❌ 全画像を同時にメモリに載せる（危険）
for (final circle in allCircles) {
  archive.addFile(File(circle.circleImagePath!));
}

// ✅ ストリーミング処理で1ファイルずつ処理
for (final circle in allCircles) {
  if (circle.circleImagePath != null) {
    final file = File(circle.circleImagePath!);
    final bytes = await file.readAsBytes();
    archive.addFile(ArchiveFile.stream(
      'images/circles/circle_${circle.circleId}.jpg',
      bytes.length,
      InputStream(bytes),
    ));
    // bytesはスコープ外で自動解放
  }
}
```

#### ZIP 作成もストリーミング

```dart
// ❌ 全データをメモリに保持
final zipData = ZipEncoder().encode(archive);
await File(zipPath).writeAsBytes(zipData!);

// ✅ 直接ファイルに書き込み
final output = OutputFileStream(zipPath);
ZipEncoder().encode(archive, output: output);
await output.close();
```

**効果**: メモリ使用量を 90%削減（500MB → 50MB）

---

### 📱 プラットフォーム固有の対応

#### iOS: Share Extension 制限

**問題**: バックグラウンドでの大容量 ZIP 生成が制限される

**対応**:

```dart
// ✅ ファイルサイズチェックと警告
Future<void> shareExportedMap(String filePath) async {
  final zipFile = File(filePath);
  final zipSize = await zipFile.length();

  if (zipSize > 100 * 1024 * 1024) { // 100MB
    final shouldContinue = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('大容量ファイル'),
        content: const Text(
          'ファイルサイズが大きいため、共有に時間がかかる場合があります。',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: const Text('続行'),
          ),
        ],
      ),
    );

    if (shouldContinue != true) return;
  }

  // タイムアウト設定
  await Share.shareXFiles([XFile(filePath)]).timeout(
    const Duration(seconds: 30),
    onTimeout: () => throw TimeoutException('共有がタイムアウトしました'),
  );
}
```

#### Android: Scoped Storage 対応（Android 10+）

**対応**:

```dart
// ✅ Downloadsフォルダを使用（ユーザーアクセス容易）
Future<String> _getExportDirectory() async {
  if (Platform.isAndroid) {
    // Android: Downloadsフォルダ内にアプリ専用フォルダを作成
    final directory = Directory('/storage/emulated/0/Download/CircleMarker');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory.path;
  } else if (Platform.isIOS) {
    // iOS: Documents Directory
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  } else {
    // その他のプラットフォーム
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
```

**権限設定（android/app/src/main/AndroidManifest.xml）**:

```xml
<!-- Android 10以下用 -->
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
    android:maxSdkVersion="29" />
<!-- Android 11+では不要（Scoped Storageで自動対応） -->
```

---

### 📊 プログレス表示の精度向上

**問題**: ファイル数ベースの進捗のため、大きな画像で止まったように見える

**改善**:

#### バイトベースの進捗計算

```dart
// モデル追加
@freezed
class ExportProgress with _$ExportProgress {
  const factory ExportProgress({
    required int processedBytes,
    required int totalBytes,
    required String currentOperation,
  }) = _ExportProgress;

  const ExportProgress._();

  double get percentage => totalBytes > 0 ? processedBytes / totalBytes : 0.0;
  String get displayText => '${(percentage * 100).toInt()}% - $currentOperation';
}

// ViewModelの状態を更新
@freezed
class MapExportState with _$MapExportState {
  const factory MapExportState({
    @Default(false) bool isExporting,
    @Default(false) bool isImporting,
    ExportProgress? progress,
    String? errorMessage,
    String? exportedFilePath,
  }) = _MapExportState;
}
```

#### 使用例

```dart
// 総バイト数を事前に計算
Future<int> _calculateTotalSize(int mapId) async {
  int totalBytes = 0;

  // マップ画像サイズ
  final mapDetail = await mapRepository.getMap(mapId);
  totalBytes += await File(mapDetail.baseImagePath).length();
  if (mapDetail.thumbnailPath != null) {
    totalBytes += await File(mapDetail.thumbnailPath!).length();
  }

  // サークル画像サイズ
  final circles = await circleRepository.getCircles(mapId);
  for (final circle in circles) {
    if (circle.imagePath != null) {
      totalBytes += await File(circle.imagePath!).length();
    }
    if (circle.menuImagePath != null) {
      totalBytes += await File(circle.menuImagePath!).length();
    }
  }

  // JSON ファイルサイズ（推定）
  totalBytes += 10 * 1024; // 約10KB

  return totalBytes;
}

// 進捗更新
int processedBytes = 0;
final totalBytes = await _calculateTotalSize(mapId);

for (final circle in allCircles) {
  if (circle.imagePath != null) {
    final file = File(circle.imagePath!);
    final fileSize = await file.length();

    // 処理...

    processedBytes += fileSize;
    state = state.copyWith(
      progress: ExportProgress(
        processedBytes: processedBytes,
        totalBytes: totalBytes,
        currentOperation: circle.circleName ?? 'サークル${circle.circleId}',
      ),
    );
  }
}
```

---

### 🛡️ エラーハンドリングの改善

**ユーザーフレンドリーなエラーメッセージ**:

```dart
// 例外クラスに追加
class InsufficientStorageException extends ExportException {
  InsufficientStorageException(String message)
      : super(message);
}

class CancelledException extends ExportException {
  CancelledException() : super('操作がキャンセルされました');
}

// エラーハンドリング
try {
  // エクスポート処理
} on FileSystemException catch (e) {
  final userMessage = switch (e.osError?.errorCode) {
    28 => 'ストレージの空き容量が不足しています。\n不要なファイルを削除してください。',
    13 => 'ファイルへのアクセス権限がありません。\nアプリの設定を確認してください。',
    _ => 'ファイル操作に失敗しました。\n再度お試しください。',
  };

  state = state.copyWith(
    isExporting: false,
    errorMessage: userMessage,
  );

  // ログ記録（デバッグ用）
  debugPrint('FileSystemException: ${e.osError?.errorCode} - ${e.toString()}');
} on TimeoutException {
  state = state.copyWith(
    isExporting: false,
    errorMessage: '処理がタイムアウトしました。\nファイルサイズが大きすぎる可能性があります。',
  );
} on InsufficientStorageException catch (e) {
  state = state.copyWith(
    isExporting: false,
    errorMessage: e.message,
  );
} on CancelledException {
  // キャンセルは正常系として扱う
  state = state.copyWith(
    isExporting: false,
    errorMessage: null,
  );
} catch (e, stackTrace) {
  debugPrint('Unexpected export error: $e\n$stackTrace');
  state = state.copyWith(
    isExporting: false,
    errorMessage: '予期しないエラーが発生しました。\n開発者に報告してください。',
  );
}
```

---

### ⏸️ キャンセル機能の実装

```dart
// CancellationToken パターン
class ExportCancellationToken {
  bool _isCancelled = false;
  bool get isCancelled => _isCancelled;
  void cancel() => _isCancelled = true;
}

// ViewModelに追加
class MapExportViewModel extends _$MapExportViewModel {
  ExportCancellationToken? _currentToken;

  Future<void> cancelExport() async {
    _currentToken?.cancel();
    await _cleanup(); // 一時ファイル削除
    state = state.copyWith(
      isExporting: false,
      progress: null,
    );
  }

  Future<void> exportMap(int mapId) async {
    _currentToken = ExportCancellationToken();

    try {
      state = state.copyWith(isExporting: true);

      // データ取得
      final circles = await circleRepository.getCircles(mapId);

      for (final circle in circles) {
        // キャンセルチェック
        if (_currentToken!.isCancelled) {
          throw CancelledException();
        }

        // 処理...
      }

      // 成功
      state = state.copyWith(
        isExporting: false,
        exportedFilePath: exportPath,
      );
    } catch (e) {
      // エラーハンドリング
    } finally {
      _currentToken = null;
    }
  }

  Future<void> _cleanup() async {
    // 一時ファイルの削除
    final tempDir = await getTemporaryDirectory();
    final exportTempDir = Directory('${tempDir.path}/export_temp');
    if (await exportTempDir.exists()) {
      await exportTempDir.delete(recursive: true);
    }
  }
}
```

---

### ✅ 事前チェックの追加

#### 空き容量チェック

```dart
import 'package:disk_space/disk_space.dart';

Future<void> _checkAvailableSpace(int estimatedSize) async {
  try {
    final freeSpace = await DiskSpace.getFreeDiskSpace;
    if (freeSpace == null) {
      // 空き容量取得失敗時は警告のみ
      debugPrint('Warning: Could not get free disk space');
      return;
    }

    final requiredSpace = estimatedSize * 1.2; // 20%のマージン
    final freeSpaceBytes = (freeSpace * 1024 * 1024).toInt(); // MBをバイトに変換

    if (freeSpaceBytes < requiredSpace) {
      throw InsufficientStorageException(
        'ストレージの空き容量が不足しています。\n'
        '必要: ${_formatBytes(requiredSpace.toInt())}\n'
        '空き: ${_formatBytes(freeSpaceBytes)}',
      );
    }
  } catch (e) {
    if (e is InsufficientStorageException) rethrow;
    debugPrint('Warning: Failed to check disk space: $e');
  }
}

String _formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
}

// エクスポート前に実行
Future<void> exportMap(int mapId) async {
  final estimatedSize = await _calculateTotalSize(mapId);
  await _checkAvailableSpace(estimatedSize);

  // エクスポート処理...
}
```

---

### 🎯 修正後のパフォーマンス目標

| 指標             | 目標値             | 測定方法                         |
| ---------------- | ------------------ | -------------------------------- |
| メモリ使用量     | < 100MB            | Flutter DevTools Memory Profiler |
| エクスポート時間 | < 5 秒/10 サークル | Stopwatch で測定                 |
| ZIP 圧縮率       | > 50%              | ファイルサイズ比較               |
| UI フリーズ      | 0 回               | compute() で重い処理を隔離       |

---

### 🧪 モバイル特化テスト計画

#### デバイステスト

- **iOS**: iPhone SE (2GB RAM), iPhone 14 Pro (6GB RAM)
- **Android**: Pixel 4a (6GB RAM), Galaxy A52 (4GB RAM)

#### テストケース

1. **メモリ**: 100 サークル × 5MB 画像で OOM 発生しないこと
2. **プラットフォーム**: iOS/Android で正常に共有できること
3. **キャンセル**: 途中キャンセルで一時ファイルが残らないこと
4. **エラー**: 空き容量不足時に適切なメッセージ表示
5. **進捗**: 大きな画像でも進捗が滑らかに更新されること
6. **バックグラウンド**: アプリがバックグラウンドに移行しても処理が継続すること（Android）

---

### 📋 実装優先順位（修正版）

#### Phase 1: Core Implementation（必須 - モバイル最適化含む）

1. ✅ メモリ効率的な ZIP 作成（ストリーミング処理）
2. ✅ プラットフォーム別ファイルアクセス（iOS/Android 対応）
3. ✅ バイトベースのプログレス表示
4. ✅ 事前の空き容量チェック
5. ✅ モデルと例外クラスの作成

#### Phase 2: Repository & ViewModel（必須）

1. ✅ MapExportRepository の実装
2. ✅ MapExportViewModel の実装
3. ✅ ユーザーフレンドリーなエラーハンドリング

#### Phase 3: UI & UX Enhancement（推奨）

1. ✅ エクスポート/インポートダイアログ
2. ✅ キャンセル機能
3. ✅ 大容量ファイル警告
4. ✅ マップリスト/詳細画面への UI 統合

#### Phase 4: Testing & Polish（必須）

1. ✅ ユニットテスト
2. ✅ 統合テスト
3. ✅ 実機テスト（iOS/Android）
4. ✅ パフォーマンス測定・最適化

#### Phase 5: Advanced Features（オプション）

1. 部分的インポート（エラー時のロールバック）
2. バックグラウンドエクスポート（iOS: Background Tasks）
3. クラウド同期（Firebase Storage 等）

---

### 📦 修正版: 依存パッケージ

```yaml
dependencies:
  archive: ^3.4.0 # ZIP圧縮・解凍
  share_plus: ^7.2.0 # ファイル共有
  file_picker: ^6.1.0 # ファイル選択
  package_info_plus: ^5.0.0 # アプリバージョン取得
  disk_space: ^0.2.1 # 空き容量チェック（新規追加）

dev_dependencies:
  # 既存のテスト関連パッケージを継続使用
```

---

### 🏪 ストア審査ガイドライン準拠

#### iOS App Store

✅ **準拠**:

- ファイル共有は `share_plus` 使用で問題なし
- 権限要求は最小限（写真ライブラリのみ）

⚠️ **注意点**:

- App Store Connect のメタデータで「データエクスポート機能」について説明
- プライバシーポリシーに「ユーザーデータの外部共有機能」を記載

#### Google Play

✅ **準拠**:

- Scoped Storage 対応（Android 10+）
- `MANAGE_EXTERNAL_STORAGE` 権限は不要（通常のファイルアクセスで十分）

⚠️ **注意点**:

- Data Safety セクションで「ユーザーがデータをエクスポート可能」と明記

---

## 改訂履歴

- **2025-12-26**: 初版作成
- **2025-12-26**: モバイル開発専門家によるレビュー・修正版反映
  - メモリ管理の最適化（ストリーミング処理）
  - プラットフォーム固有の対応（iOS/Android）
  - プログレス表示の精度向上（バイトベース）
  - エラーハンドリングの改善
  - キャンセル機能の追加
  - 事前チェック（空き容量）の追加
  - disk_space パッケージの追加
