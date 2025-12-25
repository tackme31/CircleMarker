import 'package:circle_marker/exceptions/app_exceptions.dart';
import 'package:circle_marker/models/map_detail.dart';
import 'package:circle_marker/providers/database_provider.dart';
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

  Future<void> deleteMapDetail(int mapId) async {
    try {
      final db = await _ref.read(databaseProvider.future);

      // トランザクションで関連データも削除
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
    } on sqflite.DatabaseException catch (e) {
      throw AppException('Failed to delete map', e);
    } on AppException {
      rethrow;
    } on Exception catch (e) {
      throw AppException('Unexpected error while deleting map', e);
    }
  }
}
