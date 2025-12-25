import 'package:circle_marker/exceptions/app_exceptions.dart';
import 'package:circle_marker/models/circle_detail.dart';
import 'package:circle_marker/providers/database_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'circle_repository.g.dart';

@riverpod
CircleRepository circleRepository(Ref ref) {
  return CircleRepository(ref);
}

class CircleRepository {
  final Ref _ref;
  final String _tableName = 'circle_detail';

  CircleRepository(this._ref);

  Future<List<CircleDetail>> getCircles(int mapId) async {
    try {
      final db = await _ref.read(databaseProvider.future);
      final maps = await db.query(
        _tableName,
        where: 'mapId = ?',
        whereArgs: [mapId],
      );

      return maps.map(CircleDetail.fromJson).toList();
    } on sqflite.DatabaseException catch (e) {
      throw AppException('Failed to load circles', e);
    } on AppException {
      rethrow;
    } on Exception catch (e) {
      throw AppException('Unexpected error while loading circles', e);
    }
  }

  Future<CircleDetail> insertCircleDetail(CircleDetail circleDetail) async {
    try {
      final db = await _ref.read(databaseProvider.future);
      final id = await db.insert(
        _tableName,
        circleDetail.toJson()..remove('circleId'),
        conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
      );
      return circleDetail.copyWith(circleId: id);
    } on sqflite.DatabaseException catch (e) {
      throw AppException('Failed to insert circle', e);
    } on AppException {
      rethrow;
    } on Exception catch (e) {
      throw AppException('Unexpected error while inserting circle', e);
    }
  }

  Future<void> updatePosition(
    int circleId,
    int positionX,
    int positionY,
  ) async {
    try {
      final db = await _ref.read(databaseProvider.future);
      await db.update(
        _tableName,
        {'positionX': positionX, 'positionY': positionY},
        where: 'circleId = ?',
        whereArgs: [circleId],
      );
    } on sqflite.DatabaseException catch (e) {
      throw AppException('Failed to update circle position', e);
    } on AppException {
      rethrow;
    } on Exception catch (e) {
      throw AppException('Unexpected error while updating circle position', e);
    }
  }

  Future<void> updatePointer(int circleId, int positionX, int positionY) async {
    try {
      final db = await _ref.read(databaseProvider.future);
      await db.update(
        _tableName,
        {'pointerX': positionX, 'pointerY': positionY},
        where: 'circleId = ?',
        whereArgs: [circleId],
      );
    } on sqflite.DatabaseException catch (e) {
      throw AppException('Failed to update circle pointer', e);
    } on AppException {
      rethrow;
    } on Exception catch (e) {
      throw AppException('Unexpected error while updating circle pointer', e);
    }
  }

  Future<void> deleteCircle(int circleId) async {
    try {
      final db = await _ref.read(databaseProvider.future);
      await db.delete(_tableName, where: 'circleId = ?', whereArgs: [circleId]);
    } on sqflite.DatabaseException catch (e) {
      throw AppException('Failed to delete circle', e);
    } on AppException {
      rethrow;
    } on Exception catch (e) {
      throw AppException('Unexpected error while deleting circle', e);
    }
  }

  Future<void> deleteCircles(int mapId) async {
    try {
      final db = await _ref.read(databaseProvider.future);
      await db.delete(_tableName, where: 'mapId = ?', whereArgs: [mapId]);
    } on sqflite.DatabaseException catch (e) {
      throw AppException('Failed to delete circles', e);
    } on AppException {
      rethrow;
    } on Exception catch (e) {
      throw AppException('Unexpected error while deleting circles', e);
    }
  }

  Future<void> updateCircleName(int circleId, String circleName) async {
    try {
      final db = await _ref.read(databaseProvider.future);
      await db.update(
        _tableName,
        {'circleName': circleName},
        where: 'circleId = ?',
        whereArgs: [circleId],
      );
    } on sqflite.DatabaseException catch (e) {
      throw AppException('Failed to update circle name', e);
    } on AppException {
      rethrow;
    } on Exception catch (e) {
      throw AppException('Unexpected error while updating circle name', e);
    }
  }

  Future<void> updateSpaceNo(int circleId, String spaceNo) async {
    try {
      final db = await _ref.read(databaseProvider.future);
      await db.update(
        _tableName,
        {'spaceNo': spaceNo},
        where: 'circleId = ?',
        whereArgs: [circleId],
      );
    } on sqflite.DatabaseException catch (e) {
      throw AppException('Failed to update space number', e);
    } on AppException {
      rethrow;
    } on Exception catch (e) {
      throw AppException('Unexpected error while updating space number', e);
    }
  }

  Future<void> updateNote(int circleId, String note) async {
    try {
      final db = await _ref.read(databaseProvider.future);
      await db.update(
        _tableName,
        {'note': note},
        where: 'circleId = ?',
        whereArgs: [circleId],
      );
    } on sqflite.DatabaseException catch (e) {
      throw AppException('Failed to update note', e);
    } on AppException {
      rethrow;
    } on Exception catch (e) {
      throw AppException('Unexpected error while updating note', e);
    }
  }

  Future<void> updateDescription(int circleId, String description) async {
    try {
      final db = await _ref.read(databaseProvider.future);
      await db.update(
        _tableName,
        {'description': description},
        where: 'circleId = ?',
        whereArgs: [circleId],
      );
    } on sqflite.DatabaseException catch (e) {
      throw AppException('Failed to update description', e);
    } on AppException {
      rethrow;
    } on Exception catch (e) {
      throw AppException('Unexpected error while updating description', e);
    }
  }

  Future<void> updateImagePath(int circleId, String imagePath) async {
    try {
      final db = await _ref.read(databaseProvider.future);
      await db.update(
        _tableName,
        {'imagePath': imagePath},
        where: 'circleId = ?',
        whereArgs: [circleId],
      );
    } on sqflite.DatabaseException catch (e) {
      throw AppException('Failed to update image path', e);
    } on AppException {
      rethrow;
    } on Exception catch (e) {
      throw AppException('Unexpected error while updating image path', e);
    }
  }

  Future<void> updateMenuImagePath(int circleId, String menuImagePath) async {
    try {
      final db = await _ref.read(databaseProvider.future);
      await db.update(
        _tableName,
        {'menuImagePath': menuImagePath},
        where: 'circleId = ?',
        whereArgs: [circleId],
      );
    } on sqflite.DatabaseException catch (e) {
      throw AppException('Failed to update menu image path', e);
    } on AppException {
      rethrow;
    } on Exception catch (e) {
      throw AppException('Unexpected error while updating menu image path', e);
    }
  }

  Future<void> updateIsDone(int circleId, bool isDone) async {
    try {
      final db = await _ref.read(databaseProvider.future);
      await db.update(
        _tableName,
        {'isDone': isDone ? 1 : 0},
        where: 'circleId = ?',
        whereArgs: [circleId],
      );
    } on sqflite.DatabaseException catch (e) {
      throw AppException('Failed to update done status', e);
    } on AppException {
      rethrow;
    } on Exception catch (e) {
      throw AppException('Unexpected error while updating done status', e);
    }
  }
}
