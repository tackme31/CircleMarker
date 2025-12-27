import 'package:circle_marker/exceptions/app_exceptions.dart';
import 'package:circle_marker/models/circle_detail.dart';
import 'package:circle_marker/models/map_detail.dart';
import 'package:circle_marker/providers/database_provider.dart';
import 'package:circle_marker/repositories/circle_repository.dart';
import 'package:circle_marker/repositories/image_repository.dart';
import 'package:circle_marker/repositories/map_with_circle_count.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'map_repository.g.dart';

@riverpod
MapRepository mapRepository(Ref ref) {
  return MapRepository(ref);
}

class MapRepository {
  MapRepository(this._ref);

  final Ref _ref;
  final String _tableName = 'map_detail';

  Future<List<MapDetail>> getMapDetails() async {
    try {
      final db = await _ref.read(databaseProvider.future);
      final maps = await db.query(_tableName, orderBy: 'mapId DESC');
      return maps.map(MapDetail.fromJson).toList();
    } on sqflite.DatabaseException catch (e) {
      throw AppException('Failed to load maps', e);
    } on AppException {
      rethrow;
    } on Exception catch (e) {
      throw AppException('Unexpected error while loading maps', e);
    }
  }

  Future<MapDetail> getMapDetail(int mapId) async {
    try {
      final db = await _ref.read(databaseProvider.future);
      final maps = await db.query(
        _tableName,
        where: 'mapId = ?',
        whereArgs: [mapId],
        limit: 1,
      );

      if (maps.isEmpty) {
        throw AppException('Map not found with id: $mapId');
      }

      final map = MapDetail.fromJson(maps.first);
      return map;
    } on sqflite.DatabaseException catch (e) {
      throw AppException('Failed to load map', e);
    } on AppException {
      rethrow;
    } on Exception catch (e) {
      throw AppException('Unexpected error while loading map', e);
    }
  }

  Future<MapDetail> insertMapDetail(MapDetail mapDetail) async {
    try {
      final db = await _ref.read(databaseProvider.future);
      final id = await db.insert(
        'map_detail',
        mapDetail.toJson()..remove('mapId'),
        conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
      );

      return mapDetail.copyWith(mapId: id);
    } on sqflite.DatabaseException catch (e) {
      throw AppException('Failed to insert map', e);
    } on AppException {
      rethrow;
    } on Exception catch (e) {
      throw AppException('Unexpected error while inserting map', e);
    }
  }

  Future<MapDetail> updateMapDetail(MapDetail mapDetail) async {
    try {
      final db = await _ref.read(databaseProvider.future);
      await db.update(
        _tableName,
        mapDetail.toJson(),
        where: 'mapId = ?',
        whereArgs: [mapDetail.mapId],
      );
      return mapDetail;
    } on sqflite.DatabaseException catch (e) {
      throw AppException('Failed to update map', e);
    } on AppException {
      rethrow;
    } on Exception catch (e) {
      throw AppException('Unexpected error while updating map', e);
    }
  }

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

  /// マップ一覧をサークル数付きで取得
  ///
  /// LEFT JOINとCOUNTを使用して各マップのサークル数を効率的に取得
  /// サークルが0件のマップも含まれる
  Future<List<MapWithCircleCount>> getMapDetailsWithCircleCount() async {
    try {
      final db = await _ref.read(databaseProvider.future);

      final query = '''
        SELECT
          m.mapId,
          m.title,
          m.baseImagePath,
          m.thumbnailPath,
          COUNT(c.circleId) AS circleCount
        FROM $_tableName m
        LEFT JOIN circle_detail c ON m.mapId = c.mapId
        GROUP BY m.mapId, m.title, m.baseImagePath, m.thumbnailPath
        ORDER BY m.mapId DESC
      ''';

      final result = await db.rawQuery(query);

      return result.map((row) {
        // Extract count separately as it's not part of MapDetail
        final circleCount = row['circleCount'] as int;

        // Create MapDetail from the row (excluding circleCount)
        final mapData = Map<String, dynamic>.from(row)..remove('circleCount');
        final map = MapDetail.fromJson(mapData);

        return MapWithCircleCount(
          map: map,
          circleCount: circleCount,
        );
      }).toList();
    } on sqflite.DatabaseException catch (e) {
      throw AppException('Failed to load maps with circle count', e);
    } on AppException {
      rethrow;
    } on Exception catch (e) {
      throw AppException(
        'Unexpected error while loading maps with circle count',
        e,
      );
    }
  }

  /// タイトルによる部分一致検索（サークル数付き）
  ///
  /// [query]が空の場合は全件取得と同じ動作
  /// LEFT JOINとCOUNTを使用して各マップのサークル数を効率的に取得
  Future<List<MapWithCircleCount>> searchMapsByTitleWithCircleCount(
    String query,
  ) async {
    try {
      final db = await _ref.read(databaseProvider.future);

      final normalizedQuery = query.trim();

      if (normalizedQuery.isEmpty) {
        // 検索クエリが空の場合は全件取得
        return getMapDetailsWithCircleCount();
      }

      final sqlQuery = '''
        SELECT
          m.mapId,
          m.title,
          m.baseImagePath,
          m.thumbnailPath,
          COUNT(c.circleId) AS circleCount
        FROM $_tableName m
        LEFT JOIN circle_detail c ON m.mapId = c.mapId
        WHERE LOWER(m.title) LIKE LOWER(?)
        GROUP BY m.mapId, m.title, m.baseImagePath, m.thumbnailPath
        ORDER BY m.mapId DESC
      ''';

      final result = await db.rawQuery(sqlQuery, ['%$normalizedQuery%']);

      return result.map((row) {
        final circleCount = row['circleCount'] as int;
        final mapData = Map<String, dynamic>.from(row)..remove('circleCount');
        final map = MapDetail.fromJson(mapData);

        return MapWithCircleCount(
          map: map,
          circleCount: circleCount,
        );
      }).toList();
    } on sqflite.DatabaseException catch (e) {
      throw AppException('Failed to search maps with circle count', e);
    } on AppException {
      rethrow;
    } on Exception catch (e) {
      throw AppException(
        'Unexpected error while searching maps with circle count',
        e,
      );
    }
  }

  Future<void> deleteMapDetail(int mapId) async {
    try {
      final db = await _ref.read(databaseProvider.future);

      // 1. 画像パスを取得（削除前に取得）
      MapDetail? mapDetail;
      List<CircleDetail> circles = [];

      try {
        mapDetail = await getMapDetail(mapId);
        circles = await _ref.read(circleRepositoryProvider).getCircles(mapId);
      } on AppException catch (e) {
        debugPrint('Failed to fetch data for deletion: $e');
        // データが見つからない場合は削除済みと判断して続行
      }

      // 2. トランザクションでDBレコード削除（先にDBを削除）
      await db.transaction((txn) async {
        // サークルデータ削除
        await txn.delete(
          'circle_detail',
          where: 'mapId = ?',
          whereArgs: [mapId],
        );
        // マップデータ削除
        await txn.delete('map_detail', where: 'mapId = ?', whereArgs: [mapId]);
      });

      // 3. DB削除成功後に画像ファイルを削除
      // DB削除が失敗した場合は、ここに到達せずファイルは残る（次回削除可能）
      if (mapDetail != null) {
        try {
          final deletedCount = await _ref
              .read(imageRepositoryProvider.notifier)
              .deleteMapImages(
                originalPath: mapDetail.baseImagePath,
                thumbnailPath: mapDetail.thumbnailPath,
              );
          debugPrint('Deleted $deletedCount map image files');
        } catch (e) {
          debugPrint('Failed to delete map images: $e');
          // エラーログのみ、DBは削除済みなので孤立ファイルとして残る
        }
      }

      // 4. サークル画像を削除
      if (circles.isNotEmpty) {
        try {
          final imagePaths = circles
              .expand((circle) => [circle.imagePath, circle.menuImagePath])
              .toList();
          final deletedCount = await _ref
              .read(imageRepositoryProvider.notifier)
              .deleteCircleImages(imagePaths);
          debugPrint('Deleted $deletedCount circle image files');
        } catch (e) {
          debugPrint('Failed to delete circle images: $e');
          // エラーログのみ、DBは削除済みなので孤立ファイルとして残る
        }
      }
    } on sqflite.DatabaseException catch (e) {
      throw AppException('Failed to delete map', e);
    } on AppException {
      rethrow;
    } on Exception catch (e) {
      throw AppException('Unexpected error while deleting map', e);
    }
  }

  Future<void> updateBaseImagePath(
    int mapId,
    String newPath,
    String? thumbnailPath,
  ) async {
    try {
      final db = await _ref.read(databaseProvider.future);
      await db.update(
        _tableName,
        {'baseImagePath': newPath, 'thumbnailPath': thumbnailPath},
        where: 'mapId = ?',
        whereArgs: [mapId],
      );
    } on sqflite.DatabaseException catch (e) {
      throw AppException('Failed to update base image path', e);
    } on AppException {
      rethrow;
    } on Exception catch (e) {
      throw AppException('Unexpected error while updating base image path', e);
    }
  }
}
