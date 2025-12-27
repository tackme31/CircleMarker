import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:circle_marker/database_helper.dart';
import 'package:circle_marker/models/circle_detail.dart';
import 'package:circle_marker/models/map_detail.dart';
import 'package:circle_marker/models/map_export_data.dart';
import 'package:circle_marker/repositories/circle_repository.dart';
import 'package:circle_marker/repositories/map_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_export_repository.g.dart';

@Riverpod(keepAlive: true)
MapExportRepository mapExportRepository(Ref ref) {
  return MapExportRepository(
    mapRepository: ref.watch(mapRepositoryProvider),
    circleRepository: ref.watch(circleRepositoryProvider),
  );
}

class MapExportRepository {
  MapExportRepository({
    required this.mapRepository,
    required this.circleRepository,
  });

  final MapRepository mapRepository;
  final CircleRepository circleRepository;

  Future<String> exportMap(int mapId) async {
    // 1. データ取得
    final mapDetail = await mapRepository.getMapDetail(mapId);
    final circles = await circleRepository.getCircles(mapId);

    // 2. エクスポートデータ作成
    final exportData = _createExportData(mapDetail, circles);

    // 3. ZIP ファイル作成
    final archive = Archive();

    // manifest.json
    final manifestJson = jsonEncode(exportData.manifest.toJson());
    archive.addFile(
      ArchiveFile(
        'manifest.json',
        manifestJson.length,
        utf8.encode(manifestJson),
      ),
    );

    // map.json
    final mapJson = jsonEncode(exportData.content.toJson());
    archive.addFile(
      ArchiveFile('map.json', mapJson.length, utf8.encode(mapJson)),
    );

    // 画像ファイル追加
    await _addImageToArchive(
      archive,
      mapDetail.baseImagePath!,
      'images/map_base.jpg',
    );
    if (mapDetail.thumbnailPath != null) {
      await _addImageToArchive(
        archive,
        mapDetail.thumbnailPath!,
        'images/map_thumb.jpg',
      );
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
    final zipData = ZipEncoder().encode(archive);

    // 5. Downloads フォルダに保存
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final sanitizedTitle = _sanitizeFileName(exportData.content.map.title);
    final outputPath =
        '/storage/emulated/0/Download/circle_marker_${sanitizedTitle}_${mapId}_$timestamp.cmzip';
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
    final manifestJson = jsonDecode(
      utf8.decode(manifestFile.content as List<int>),
    );

    // マニフェストは今のところ使用しないが、将来の互換性のために読み込んでおく
    final _ = MapExportManifest.fromJson(manifestJson);

    // 3. map.json 読み込み
    final mapFile = archive.findFile('map.json')!;
    final mapJson = jsonDecode(utf8.decode(mapFile.content as List<int>));
    final content = MapExportContent.fromJson(mapJson);

    // 4. 画像を一時ディレクトリに展開
    final tempDir = await getTemporaryDirectory();
    final extractDir = Directory(
      '${tempDir.path}/import_${DateTime.now().millisecondsSinceEpoch}',
    );
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

    // 必要なディレクトリを事前作成
    final mapsDir = Directory('${appDocDir.path}/maps');
    final thumbnailsDir = Directory('${appDocDir.path}/maps/thumbnails');
    final circlesDir = Directory('${appDocDir.path}/circles');

    await mapsDir.create(recursive: true);
    await thumbnailsDir.create(recursive: true);
    await circlesDir.create(recursive: true);

    final newMapBasePath =
        '${appDocDir.path}/maps/${DateTime.now().millisecondsSinceEpoch}.jpg';

    // ファイル存在確認してからコピー
    final mapBaseFile = File('${extractDir.path}/${content.map.baseImagePath}');
    if (!await mapBaseFile.exists()) {
      throw Exception(
        'Map base image not found: ${content.map.baseImagePath}\n'
        'Expected at: ${mapBaseFile.path}',
      );
    }
    await mapBaseFile.copy(newMapBasePath);

    String? newThumbnailPath;
    if (content.map.thumbnailPath != null) {
      newThumbnailPath =
          '${appDocDir.path}/maps/thumbnails/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final thumbnailFile = File(
        '${extractDir.path}/${content.map.thumbnailPath}',
      );
      if (await thumbnailFile.exists()) {
        await thumbnailFile.copy(newThumbnailPath);
      }
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
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      int circleIndex = 1;

      for (final circle in content.circles) {
        String? newCircleImagePath;
        if (circle.imagePath != null) {
          final circleImageFile = File(
            '${extractDir.path}/${circle.imagePath}',
          );

          // ファイルが存在する場合のみコピー（古いバグのあるZIPファイルにも対応）
          if (await circleImageFile.exists()) {
            newCircleImagePath =
                '${appDocDir.path}/circles/${timestamp}_$circleIndex.jpg';
            await circleImageFile.copy(newCircleImagePath);
          } else {
            // ファイルが見つからない場合は警告のみ（処理は続行）
            print(
              'Warning: Circle image not found: ${circle.imagePath}, skipping',
            );
          }
        }

        String? newMenuImagePath;
        if (circle.menuImagePath != null) {
          final menuImageFile = File(
            '${extractDir.path}/${circle.menuImagePath}',
          );

          if (await menuImageFile.exists()) {
            newMenuImagePath =
                '${appDocDir.path}/circles/${timestamp}_${circleIndex}_menu.jpg';
            await menuImageFile.copy(newMenuImagePath);
          } else {
            print(
              'Warning: Menu image not found: ${circle.menuImagePath}, skipping',
            );
          }
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

  MapExportData _createExportData(
    MapDetail mapDetail,
    List<CircleDetail> circles,
  ) {
    // エクスポート時と同じインデックス付けロジックを使用
    int circleIndex = 1;
    final circleExportDataList = <CircleExportData>[];

    for (final circle in circles) {
      circleExportDataList.add(
        CircleExportData(
          positionX: circle.positionX!,
          positionY: circle.positionY!,
          sizeWidth: circle.sizeWidth!,
          sizeHeight: circle.sizeHeight!,
          pointerX: circle.pointerX!,
          pointerY: circle.pointerY!,
          circleName: circle.circleName!,
          spaceNo: circle.spaceNo!,
          imagePath: circle.imagePath != null
              ? 'images/circles/circle_$circleIndex.jpg'
              : null,
          menuImagePath: circle.menuImagePath != null
              ? 'images/circles/circle_${circleIndex}_menu.jpg'
              : null,
          note: circle.note,
          description: circle.description,
          color: circle.color,
          isDone: circle.isDone!,
        ),
      );
      circleIndex++;
    }

    return MapExportData(
      manifest: MapExportManifest(
        version: '1.0',
        exportDate: DateTime.now().toIso8601String(),
      ),
      content: MapExportContent(
        map: MapExportMapData(
          title: mapDetail.title!,
          baseImagePath: 'images/map_base.jpg',
          thumbnailPath: mapDetail.thumbnailPath != null
              ? 'images/map_thumb.jpg'
              : null,
        ),
        circles: circleExportDataList,
      ),
    );
  }

  Future<void> _addImageToArchive(
    Archive archive,
    String sourcePath,
    String archivePath,
  ) async {
    final file = File(sourcePath);
    if (await file.exists()) {
      final bytes = await file.readAsBytes();
      archive.addFile(ArchiveFile(archivePath, bytes.length, bytes));
    }
  }

  String _sanitizeFileName(String input) {
    final illegalChars = RegExp(r'[\\/:*?"<>|]');
    return input.replaceAll(illegalChars, '_').trim();
  }
}
