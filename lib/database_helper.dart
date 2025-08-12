import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // データベースのパスを決定
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'circle_marker.db');
    // データベースを開く（なければ作成）
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
    return _database!;
  }

  // テーブル作成
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE map_detail(
        mapId INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        baseImagePath TEXT NOT NULL,
      )

      CREATE TABLE circle_detail(
        circleId INTEGER PRIMARY KEY AUTOINCREMENT,
        positionX INTEGER NOT NULL,
        positionY INTEGER NOT NULL,
        sizeWidth INTEGER NOT NULL,
        sizeHeight INTEGER NOT NULL,
        mapId INTEGER NOT NULL,
        circleName TEXT NOT NULL,
        spaceNo TEXT NOT NULL,
        imagePath TEXT,
        note TEXT,
        description TEXT,
        FOREIGN KEY (mapId) REFERENCES map_detail(mapId)
      )
    ''');
  }
}
