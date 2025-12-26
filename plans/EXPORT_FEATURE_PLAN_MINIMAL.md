# マップエクスポート・インポート機能 ミニマル設計書

## 概要

Circle Marker アプリにおいて、マップ単位でのデータのエクスポート・インポート機能を実装する。
**個人用・Android 専用の最低限動作する実装**を目指し、完璧なエラーハンドリングや最適化は後回しにする。

## 前提条件

- **利用者**: 開発者本人のみ
- **対応プラットフォーム**: Android のみ
- **品質要件**: エラーが出ても許容、使い勝手は二の次
- **目標**: まず動くものを作る → 後から改善

## ミニマル要件

### 1. エクスポート機能

- マップ単位でのエクスポート
- DB 情報（map_detail、circle_detail）の保存
- 関連画像の保存（マップ画像、サムネイル、サークル画像、メニュー画像）
- ファイル共有機能（share_plus）

### 2. インポート機能

- エクスポートファイルからのマップ復元
- 画像パスの自動調整
- 新しい ID の割り当て

## データ構造

### 現在のデータベーススキーマ（再掲）

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

## エクスポートファイル形式

### ファイル構造（簡略版）

エクスポートファイルは `.cmzip` 拡張子の ZIP アーカイブ。

```
map_export_<mapId>_<timestamp>.cmzip
├── manifest.json          # 最低限のメタデータ
├── map.json              # マップとサークルのデータ
└── images/
    ├── map_base.jpg      # マップ画像
    ├── map_thumb.jpg     # マップサムネイル（あれば）
    └── circles/
        ├── circle_1.jpg
        ├── circle_1_menu.jpg
        └── ...
```

### manifest.json 構造（簡略版）

```json
{
  "version": "1.0",
  "exportDate": "2025-12-26T12:34:56.789Z"
}
```

バージョンチェックは**後回し**。最初は読み飛ばす。

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

## 実装設計（ミニマル版）

### 新規作成ファイル

#### 1. `lib/models/map_export_data.dart`

エクスポート用のデータモデル。freezed を使用。

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

**主要メソッド:**

- `Future<String> exportMap(int mapId)` - ZIP を作成して Downloads フォルダに保存、パスを返す
- `Future<int> importMap(String filePath)` - ZIP を読み込んで DB に保存、新しい mapId を返す

**実装の簡略化ポイント:**

- エラーハンドリングは最低限（throw するだけ、ViewModel でキャッチ）
- プログレス表示なし（最初のバージョンでは省略）
- メモリ効率は気にしない（小規模データ前提）
- トランザクションは使う（データ整合性のため）

**実装例（概略）:**

```dart
@Riverpod(keepAlive: true)
MapExportRepository mapExportRepository(MapExportRepositoryRef ref) {
  return MapExportRepository(
    mapRepository: ref.watch(mapRepositoryProvider),
    circleRepository: ref.watch(circleRepositoryProvider),
  );
}

class MapExportRepository {
  final MapRepository mapRepository;
  final CircleRepository circleRepository;

  MapExportRepository({
    required this.mapRepository,
    required this.circleRepository,
  });

  Future<String> exportMap(int mapId) async {
    // 1. データ取得
    final mapDetail = await mapRepository.getMap(mapId);
    final circles = await circleRepository.getCircles(mapId);

    // 2. エクスポートデータ作成
    final exportData = _createExportData(mapDetail, circles);

    // 3. ZIP ファイル作成
    final archive = Archive();

    // manifest.json
    archive.addFile(ArchiveFile(
      'manifest.json',
      jsonEncode(exportData.manifest.toJson()).length,
      utf8.encode(jsonEncode(exportData.manifest.toJson())),
    ));

    // map.json
    archive.addFile(ArchiveFile(
      'map.json',
      jsonEncode(exportData.content.toJson()).length,
      utf8.encode(jsonEncode(exportData.content.toJson())),
    ));

    // 画像ファイル追加
    await _addImageToArchive(archive, mapDetail.baseImagePath, 'images/map_base.jpg');
    if (mapDetail.thumbnailPath != null) {
      await _addImageToArchive(archive, mapDetail.thumbnailPath!, 'images/map_thumb.jpg');
    }

    int circleIndex = 1;
    for (final circle in circles) {
      if (circle.imagePath != null) {
        await _addImageToArchive(
          archive,
          circle.imagePath!,
          'images/circles/circle_$circleIndex.jpg',
        );
      }
      if (circle.menuImagePath != null) {
        await _addImageToArchive(
          archive,
          circle.menuImagePath!,
          'images/circles/circle_${circleIndex}_menu.jpg',
        );
      }
      circleIndex++;
    }

    // 4. ZIP 圧縮
    final zipData = ZipEncoder().encode(archive)!;

    // 5. Downloads フォルダに保存
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final outputPath = '/storage/emulated/0/Download/map_export_${mapId}_$timestamp.cmzip';
    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(zipData);

    return outputPath;
  }

  Future<int> importMap(String filePath) async {
    // 1. ZIP 解凍
    final zipFile = File(filePath);
    final zipBytes = await zipFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(zipBytes);

    // 2. manifest.json 読み込み（最初は読み飛ばしてもOK）
    final manifestFile = archive.findFile('manifest.json')!;
    final manifestJson = jsonDecode(utf8.decode(manifestFile.content as List<int>));
    final manifest = MapExportManifest.fromJson(manifestJson);

    // 3. map.json 読み込み
    final mapFile = archive.findFile('map.json')!;
    final mapJson = jsonDecode(utf8.decode(mapFile.content as List<int>));
    final content = MapExportContent.fromJson(mapJson);

    // 4. 画像を一時ディレクトリに展開
    final tempDir = await getTemporaryDirectory();
    final extractDir = Directory('${tempDir.path}/import_${DateTime.now().millisecondsSinceEpoch}');
    await extractDir.create();

    for (final file in archive) {
      if (file.isFile && file.name.startsWith('images/')) {
        final outputFile = File('${extractDir.path}/${file.name}');
        await outputFile.create(recursive: true);
        await outputFile.writeAsBytes(file.content as List<int>);
      }
    }

    // 5. 画像を保存（新しいパスに）
    final appDocDir = await getApplicationDocumentsDirectory();
    final newMapBasePath = '${appDocDir.path}/maps/${DateTime.now().millisecondsSinceEpoch}.jpg';
    await File('${extractDir.path}/${content.map.baseImagePath}').copy(newMapBasePath);

    String? newThumbnailPath;
    if (content.map.thumbnailPath != null) {
      newThumbnailPath = '${appDocDir.path}/maps/thumbnails/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await File('${extractDir.path}/${content.map.thumbnailPath}').copy(newThumbnailPath);
    }

    // 6. DB に保存（トランザクション使用）
    final db = await DatabaseHelper.instance.database;
    late int newMapId;

    await db.transaction((txn) async {
      // マップ挿入
      newMapId = await txn.insert('map_detail', {
        'title': content.map.title,
        'baseImagePath': newMapBasePath,
        'thumbnailPath': newThumbnailPath,
      });

      // サークル挿入
      int circleIndex = 1;
      for (final circle in content.circles) {
        String? newCircleImagePath;
        if (circle.imagePath != null) {
          newCircleImagePath = '${appDocDir.path}/circles/${DateTime.now().millisecondsSinceEpoch}_$circleIndex.jpg';
          await File('${extractDir.path}/${circle.imagePath}').copy(newCircleImagePath);
        }

        String? newMenuImagePath;
        if (circle.menuImagePath != null) {
          newMenuImagePath = '${appDocDir.path}/circles/${DateTime.now().millisecondsSinceEpoch}_${circleIndex}_menu.jpg';
          await File('${extractDir.path}/${circle.menuImagePath}').copy(newMenuImagePath);
        }

        await txn.insert('circle_detail', {
          'positionX': circle.positionX,
          'positionY': circle.positionY,
          'sizeWidth': circle.sizeWidth,
          'sizeHeight': circle.sizeHeight,
          'pointerX': circle.pointerX,
          'pointerY': circle.pointerY,
          'mapId': newMapId,
          'circleName': circle.circleName,
          'spaceNo': circle.spaceNo,
          'imagePath': newCircleImagePath,
          'menuImagePath': newMenuImagePath,
          'note': circle.note,
          'description': circle.description,
          'color': circle.color,
          'isDone': circle.isDone,
        });

        circleIndex++;
      }
    });

    // 7. 一時ディレクトリ削除
    await extractDir.delete(recursive: true);

    return newMapId;
  }

  MapExportData _createExportData(MapDetail mapDetail, List<CircleDetail> circles) {
    return MapExportData(
      manifest: MapExportManifest(
        version: '1.0',
        exportDate: DateTime.now().toIso8601String(),
      ),
      content: MapExportContent(
        map: MapExportMapData(
          title: mapDetail.title,
          baseImagePath: 'images/map_base.jpg',
          thumbnailPath: mapDetail.thumbnailPath != null ? 'images/map_thumb.jpg' : null,
        ),
        circles: circles.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final circle = entry.value;
          return CircleExportData(
            positionX: circle.positionX,
            positionY: circle.positionY,
            sizeWidth: circle.sizeWidth,
            sizeHeight: circle.sizeHeight,
            pointerX: circle.pointerX,
            pointerY: circle.pointerY,
            circleName: circle.circleName,
            spaceNo: circle.spaceNo,
            imagePath: circle.imagePath != null ? 'images/circles/circle_$index.jpg' : null,
            menuImagePath: circle.menuImagePath != null ? 'images/circles/circle_${index}_menu.jpg' : null,
            note: circle.note,
            description: circle.description,
            color: circle.color,
            isDone: circle.isDone,
          );
        }).toList(),
      ),
    );
  }

  Future<void> _addImageToArchive(Archive archive, String sourcePath, String archivePath) async {
    final file = File(sourcePath);
    if (await file.exists()) {
      final bytes = await file.readAsBytes();
      archive.addFile(ArchiveFile(archivePath, bytes.length, bytes));
    }
  }
}
```

#### 3. `lib/viewModels/map_export_view_model.dart`

エクスポート・インポートの ViewModel。

**状態管理（簡略版）:**

```dart
@freezed
class MapExportState with _$MapExportState {
  const factory MapExportState({
    @Default(false) bool isExporting,
    @Default(false) bool isImporting,
    String? errorMessage,
    String? exportedFilePath,
  }) = _MapExportState;
}
```

**主要メソッド:**

```dart
@riverpod
class MapExportViewModel extends _$MapExportViewModel {
  @override
  MapExportState build() {
    return const MapExportState();
  }

  Future<void> exportMap(int mapId) async {
    state = state.copyWith(isExporting: true, errorMessage: null);

    try {
      final repository = ref.read(mapExportRepositoryProvider);
      final filePath = await repository.exportMap(mapId);

      state = state.copyWith(
        isExporting: false,
        exportedFilePath: filePath,
      );
    } catch (e) {
      state = state.copyWith(
        isExporting: false,
        errorMessage: 'エクスポート失敗: $e',
      );
    }
  }

  Future<void> importMap(String filePath) async {
    state = state.copyWith(isImporting: true, errorMessage: null);

    try {
      final repository = ref.read(mapExportRepositoryProvider);
      final newMapId = await repository.importMap(filePath);

      state = state.copyWith(isImporting: false);

      // マップ詳細画面に遷移（ナビゲーション処理は UI 側で）
    } catch (e) {
      state = state.copyWith(
        isImporting: false,
        errorMessage: 'インポート失敗: $e',
      );
    }
  }

  Future<void> shareExportedMap(String filePath) async {
    await Share.shareXFiles([XFile(filePath)]);
  }
}
```

#### 4. `lib/views/widgets/map_export_dialog.dart`

エクスポート・インポート用のシンプルなダイアログ。

**実装例（簡略版）:**

```dart
class MapExportDialog extends HookConsumerWidget {
  final int mapId;

  const MapExportDialog({required this.mapId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(mapExportViewModelProvider);

    return AlertDialog(
      title: const Text('マップエクスポート'),
      content: viewModel.isExporting
          ? const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                Gap(16),
                Text('エクスポート中...'),
              ],
            )
          : viewModel.errorMessage != null
              ? Text(viewModel.errorMessage!)
              : const Text('このマップをエクスポートしますか？'),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('キャンセル'),
        ),
        if (!viewModel.isExporting && viewModel.exportedFilePath == null)
          TextButton(
            onPressed: () async {
              await ref.read(mapExportViewModelProvider.notifier).exportMap(mapId);
              if (viewModel.exportedFilePath != null) {
                await ref.read(mapExportViewModelProvider.notifier).shareExportedMap(viewModel.exportedFilePath!);
                if (context.mounted) context.pop();
              }
            },
            child: const Text('エクスポート'),
          ),
      ],
    );
  }
}

class MapImportDialog extends HookConsumerWidget {
  const MapImportDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(mapExportViewModelProvider);

    return AlertDialog(
      title: const Text('マップインポート'),
      content: viewModel.isImporting
          ? const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                Gap(16),
                Text('インポート中...'),
              ],
            )
          : viewModel.errorMessage != null
              ? Text(viewModel.errorMessage!)
              : const Text('インポートするファイルを選択してください'),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('キャンセル'),
        ),
        if (!viewModel.isImporting)
          TextButton(
            onPressed: () async {
              final result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['cmzip'],
              );

              if (result != null && result.files.single.path != null) {
                await ref.read(mapExportViewModelProvider.notifier).importMap(result.files.single.path!);
                if (context.mounted && viewModel.errorMessage == null) {
                  context.pop();
                  // 成功メッセージ表示
                }
              }
            },
            child: const Text('ファイル選択'),
          ),
      ],
    );
  }
}
```

## UI 統合

### マップリスト画面に追加

- 「エクスポート」ボタンを各マップに追加（タップで `MapExportDialog` 表示）
- 「インポート」ボタンを画面上部に追加（タップで `MapImportDialog` 表示）

## 依存パッケージ

```yaml
dependencies:
  archive: ^3.4.0 # ZIP圧縮・解凍
  share_plus: ^7.2.0 # ファイル共有
  file_picker: ^6.1.0 # ファイル選択
```

## 実装順序（ミニマル版）

### Phase 1: モデル作成

1. `map_export_data.dart` 作成
2. `dart run build_runner build --delete-conflicting-outputs` 実行

### Phase 2: リポジトリ実装

1. `map_export_repository.dart` 作成
2. エクスポート機能実装
3. インポート機能実装
4. 簡単な動作確認（デバッグプリント等）

### Phase 3: ViewModel 実装

1. `map_export_view_model.dart` 作成
2. 状態管理実装
3. エクスポート・インポートメソッド実装

### Phase 4: UI 実装

1. `map_export_dialog.dart` 作成
2. マップリスト画面にボタン追加
3. 動作確認

### Phase 5: 動作テスト

1. エクスポート実行 → Downloads フォルダに ZIP が作成されることを確認
2. ファイル共有実行 → 共有ダイアログが表示されることを確認
3. インポート実行 → 新しいマップが作成されることを確認
4. インポートしたマップの画像・サークル情報が正しいことを確認

## 省略する機能（後回し）

以下は最初のバージョンでは**実装しない**：

- プログレス表示（バイトベース）
- キャンセル機能
- 空き容量チェック
- メモリ最適化（ストリーミング処理）
- 詳細なエラーハンドリング（ユーザーフレンドリーなメッセージ）
- バージョンチェック
- 大容量ファイル警告
- ユニットテスト・統合テスト

## 今後の改善

ミニマル版が動いた後、以下の優先順位で改善：

1. **エラーハンドリング改善** - ユーザーフレンドリーなメッセージ
2. **プログレス表示** - 処理中の進捗が分かるように
3. **メモリ最適化** - 大量画像でもクラッシュしないように
4. **バージョンチェック** - 将来のフォーマット変更に対応
5. **テスト追加** - 信頼性向上

## 注意事項

- **Android 専用**のため、iOS の考慮は不要
- **個人用**のため、セキュリティ・バリデーションは最低限
- **エラーが出ても許容**のため、例外はそのまま throw
- **まず動かす**ことが最優先、完璧を目指さない

---

## 改訂履歴

- **2025-12-26**: ミニマル版設計書作成
