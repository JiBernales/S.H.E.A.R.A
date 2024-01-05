import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class VideoDatabase {
  late Database _database;

  Future<void> initialize() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'videos_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE videos(id INTEGER PRIMARY KEY, path TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertVideo(String videoPath) async {
    await _database.insert(
      'videos',
      {'path': videoPath},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<String>> getAllVideos() async {
    final List<Map<String, dynamic>> maps = await _database.query('videos');

    return List.generate(maps.length, (i) {
      return maps[i]['path'] as String;
    });
  }
}
