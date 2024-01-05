import 'dart:typed_data';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ImageDatabaseHelper {
  static Database? _database;
  static const String tableName = 'images';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'image_database.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE $tableName (
          id INTEGER PRIMARY KEY,
          image BLOB
        )
      ''');
    });
  }

  Future<void> insertImage(Uint8List imageData) async {
    final Database db = await database;
    await db.insert(
      tableName,
      {'image': imageData},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getImages() async {
    final Database db = await database;
    return await db.query(tableName);
  }
}
