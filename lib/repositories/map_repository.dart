import 'package:circle_marker/database_helper.dart';
import 'package:circle_marker/models/map_detail.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'map_repository.g.dart';

@riverpod
MapRepository mapRepository(Ref _) {
  return MapRepository();
}

class MapRepository {
  final String _tableName = 'map_detail';

  Future<List<MapDetail>> getMapDetails() async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query(_tableName);
    return maps.map(MapDetail.fromJson).toList();
  }

  Future<MapDetail> getMapDetail(int mapId) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query(
      _tableName,
      where: 'mapId = ?',
      whereArgs: [mapId],
      limit: 1,
    );

    final map = MapDetail.fromJson(maps.first);
    return map;
  }

  Future<MapDetail> insertMapDetail(MapDetail mapDetail) async {
    final db = await DatabaseHelper.instance.database;
    final id = await db.insert(
      'map_detail',
      mapDetail.toJson()..remove('mapId'),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return mapDetail.copyWith(mapId: id);
  }
}
