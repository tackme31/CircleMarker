import 'package:circle_marker/exceptions/app_exceptions.dart';
import 'package:circle_marker/models/circle_detail.dart';
import 'package:circle_marker/providers/database_provider.dart';
import 'package:circle_marker/repositories/circle_with_map_title.dart';
import 'package:circle_marker/utils/enums.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'circle_repository.g.dart';

@riverpod
CircleRepository circleRepository(Ref ref) {
  return CircleRepository(ref);
}

class CircleRepository {
  CircleRepository(this._ref);

  final Ref _ref;
  final String _tableName = 'circle_detail';

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

  Future<List<CircleDetail>> getAllCircles() async {
    try {
      final db = await _ref.read(databaseProvider.future);
      final maps = await db.query(_tableName);

      return maps.map(CircleDetail.fromJson).toList();
    } on sqflite.DatabaseException catch (e) {
      throw AppException('Failed to load all circles', e);
    } on AppException {
      rethrow;
    } on Exception catch (e) {
      throw AppException('Unexpected error while loading all circles', e);
    }
  }

  Future<List<CircleWithMapTitle>> getAllCirclesSorted({
    required SortType sortType, // 'mapName' or 'spaceNo'
    required SortDirection sortDirection, // 'asc' or 'desc'
    List<int>? mapIds, // Filter by map IDs (empty or null = all maps)
    int? offset,
    int? limit,
  }) async {
    // Delegate to searchCirclesSorted with empty query
    return searchCirclesSorted(
      searchQuery: '',
      sortType: sortType,
      sortDirection: sortDirection,
      mapIds: mapIds,
      offset: offset,
      limit: limit,
    );
  }

  Future<List<CircleWithMapTitle>> searchCirclesSorted({
    required String searchQuery,
    required SortType sortType, // 'mapName' or 'spaceNo'
    required SortDirection sortDirection, // 'asc' or 'desc'
    List<int>? mapIds, // Filter by map IDs (empty or null = all maps)
    int? offset,
    int? limit,
  }) async {
    try {
      // Normalize query: trim whitespace
      final normalizedQuery = searchQuery.trim();

      final db = await _ref.read(databaseProvider.future);

      // Build WHERE clause for search (OR) + map filter (AND)
      // If query is empty, WHERE clause will only include map filter
      String whereClause = '';
      final List<Object?> whereArgs = [];

      if (normalizedQuery.isNotEmpty) {
        final searchPattern = '%$normalizedQuery%';
        whereClause = '''
        WHERE (
          LOWER(c.circleName) LIKE LOWER(?) OR
          LOWER(c.spaceNo) LIKE LOWER(?) OR
          LOWER(m.title) LIKE LOWER(?)
        )
      ''';
        whereArgs.addAll([searchPattern, searchPattern, searchPattern]);
      }

      // Add map filter if provided
      if (mapIds != null && mapIds.isNotEmpty) {
        final placeholders = List.filled(mapIds.length, '?').join(', ');
        whereClause += whereClause.isEmpty
            ? 'WHERE c.mapId IN ($placeholders)'
            : ' AND c.mapId IN ($placeholders)';
        whereArgs.addAll(mapIds);
      }

      // Build ORDER BY clause (reuse exact logic from getAllCirclesSorted)
      String orderByClause;
      switch (sortType) {
        // Join with map_detail to sort by map title
        // Handle null map titles by putting them at the end regardless of direction
        case SortType.mapName when sortDirection == SortDirection.asc:
          orderByClause =
              'CASE WHEN m.title IS NULL THEN 1 ELSE 0 END, m.title ASC';
          break;
        case SortType.mapName when sortDirection == SortDirection.desc:
          orderByClause =
              'CASE WHEN m.title IS NULL THEN 1 ELSE 0 END, m.title DESC';
          break;
        // Sort by spaceNo
        // Handle null spaceNo by putting them at the end regardless of direction
        case SortType.spaceNo when sortDirection == SortDirection.asc:
          orderByClause =
              'CASE WHEN c.spaceNo IS NULL OR c.spaceNo = \'\' THEN 1 ELSE 0 END, c.spaceNo ASC';
          break;
        case SortType.spaceNo when sortDirection == SortDirection.desc:
          orderByClause =
              'CASE WHEN c.spaceNo IS NULL OR c.spaceNo = \'\' THEN 1 ELSE 0 END, c.spaceNo DESC';
          break;
        default:
          orderByClause = 'c.circleId ASC';
          break;
      }

      // Build LIMIT/OFFSET clause for future virtual list support
      String limitClause = '';
      if (limit != null) {
        limitClause = 'LIMIT $limit';
        if (offset != null) {
          limitClause += ' OFFSET $offset';
        }
      }

      final query =
          '''
        SELECT c.*, m.title AS mapTitle
        FROM $_tableName c
        LEFT JOIN map_detail m ON c.mapId = m.mapId
        $whereClause
        ORDER BY $orderByClause
        $limitClause
      ''';

      final result = await db.rawQuery(query, whereArgs);
      return result
          .map(
            (row) => CircleWithMapTitle(
              circle: CircleDetail.fromJson(row),
              mapTitle: row['mapTitle'] as String?,
            ),
          )
          .toList();
    } on sqflite.DatabaseException catch (e) {
      throw AppException('Failed to search circles', e);
    } on AppException {
      rethrow;
    } on Exception catch (e) {
      throw AppException('Unexpected error while searching circles', e);
    }
  }

  Future<CircleDetail> getCircle(int circleId) async {
    try {
      final db = await _ref.read(databaseProvider.future);
      final circles = await db.query(
        _tableName,
        where: 'circleId = ?',
        whereArgs: [circleId],
      );

      if (circles.isEmpty) {
        throw AppException('Circle not found: $circleId');
      }

      return CircleDetail.fromJson(circles.first);
    } on sqflite.DatabaseException catch (e) {
      throw AppException('Failed to load circle', e);
    } on AppException {
      rethrow;
    } on Exception catch (e) {
      throw AppException('Unexpected error while loading circle', e);
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
