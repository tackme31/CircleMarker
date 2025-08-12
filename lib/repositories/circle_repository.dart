import 'package:circle_marker/database_helper.dart';
import 'package:circle_marker/models/circle_detail.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'circle_repository.g.dart';

@riverpod
CircleRepository circleRepository(Ref _) {
  return CircleRepository();
}

class CircleRepository {
  final String _tableName = 'circle_detail';

  Future<List<CircleDetail>> getCircles(int mapId) async {
    final db = await DatabaseHelper.instance.database;
    final maps = await db.query(
      _tableName,
      where: 'mapId = ?',
      whereArgs: [mapId],
    );

    return maps.map(CircleDetail.fromJson).toList();

    /* return [
      CircleDetail(
        circleId: 0,
        mapId: mapId,
        circleName: 'Circle A',
        spaceNo: 'A-12b',
        imagePath: '/path/to/imageA.png',
        note: 'Note A',
        description: 'Description A',
      ),
      CircleDetail(
        circleId: 1,
        mapId: mapId,
        circleName: 'Circle B',
        spaceNo: 'カ-04ab',
        imagePath: '/path/to/imageA.png',
        note: 'Note A',
        description: 'Description A',
      ),
    ]; */
  }

  Future<CircleDetail> insertCircleDetail(CircleDetail circleDetail) async {
    final db = await DatabaseHelper.instance.database;
    final id = await db.insert(
      _tableName,
      circleDetail.toJson()..remove('circleId'),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return circleDetail.copyWith(circleId: id);
  }

  Future<void> updatePosition(
    int circleId,
    int positionX,
    int positionY,
  ) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      _tableName,
      {'positionX': positionX, 'positionY': positionY},
      where: 'circleId = ?',
      whereArgs: [circleId],
    );
  }

  Future<void> updatePointer(int circleId, int positionX, int positionY) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      _tableName,
      {'pointerX': positionX, 'pointerY': positionY},
      where: 'circleId = ?',
      whereArgs: [circleId],
    );
  }

  Future<void> deleteCircle(int circleId) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(_tableName, where: 'circleId = ?', whereArgs: [circleId]);
  }

  Future<void> deleteCircles(int mapId) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(_tableName, where: 'mapId = ?', whereArgs: [mapId]);
  }

  Future<void> updateCircleName(int circleId, String circleName) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      _tableName,
      {'circleName': circleName},
      where: 'circleId = ?',
      whereArgs: [circleId],
    );
  }

  Future<void> updateSpaceNo(int circleId, String spaceNo) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      _tableName,
      {'spaceNo': spaceNo},
      where: 'circleId = ?',
      whereArgs: [circleId],
    );
  }

  Future<void> updateNote(int circleId, String note) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      _tableName,
      {'note': note},
      where: 'circleId = ?',
      whereArgs: [circleId],
    );
  }

  Future<void> updateDescription(int circleId, String description) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      _tableName,
      {'description': description},
      where: 'circleId = ?',
      whereArgs: [circleId],
    );
  }

  Future<void> updateImagePath(int circleId, String imagePath) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      _tableName,
      {'imagePath': imagePath},
      where: 'circleId = ?',
      whereArgs: [circleId],
    );
  }
}
