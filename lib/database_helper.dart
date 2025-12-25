import 'package:circle_marker/exceptions/app_exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._internal();

  static final DatabaseHelper instance = DatabaseHelper._internal();

  sqflite.Database? _database;
  static const int _version = 4;

  Future<sqflite.Database> get database async {
    try {
      _database ??= await _initDatabase();
      return _database!;
    } on sqflite.DatabaseException catch (e) {
      debugPrint('Database initialization failed: $e');
      throw DatabaseException('Database initialization failed', e);
    } on Exception catch (e) {
      throw DatabaseException('Unexpected database error', e);
    }
  }

  Future<sqflite.Database> _initDatabase() async {
    try {
      final dbPath = await sqflite.getDatabasesPath();
      final path = join(dbPath, 'circlemarker.db');

      return await sqflite.openDatabase(
        path,
        version: _version,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } on sqflite.DatabaseException catch (e) {
      throw DatabaseException('Failed to open database', e);
    }
  }

  Future<void> _onUpgrade(
    sqflite.Database db,
    int oldVersion,
    int newVersion,
  ) async {
    try {
      if (oldVersion < 2) {
        await db.execute('''
          ALTER TABLE circle_detail ADD COLUMN menuImagePath TEXT
        ''');
      }
      if (oldVersion < 3) {
        await db.execute('''
          ALTER TABLE circle_detail ADD COLUMN color TEXT
        ''');
        await db.execute('''
          ALTER TABLE circle_detail ADD COLUMN isDone INTEGER NOT NULL DEFAULT 0
        ''');
      }
      if (oldVersion < 4) {
        await db.execute('''
          ALTER TABLE map_detail ADD COLUMN thumbnailPath TEXT
        ''');
      }
    } on sqflite.DatabaseException catch (e) {
      throw DatabaseException('Database migration failed', e);
    }
  }

  // テーブル作成
  Future<void> _onCreate(sqflite.Database db, int version) async {
    await db.execute('''
  CREATE TABLE map_detail(
    mapId INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    baseImagePath TEXT NOT NULL,
    thumbnailPath TEXT
  )
''');

    await db.execute('''
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
''');
  }

  Future<void> deleteTable(sqflite.Database db) async {
    await db.execute('DROP TABLE IF EXISTS circle_detail');
  }
}
