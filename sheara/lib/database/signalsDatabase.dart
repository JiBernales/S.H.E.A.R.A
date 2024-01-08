import 'package:latlong2/latlong.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/helpSignal.dart';

class helpSignalsDatabase {
  static final helpSignalsDatabase instance = helpSignalsDatabase._init();

  static Database? _database;

  helpSignalsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('helpSignals.db');
    return _database!;
  }

  Future<bool> isDatabaseEmpty() async {
    final db = await instance.database;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $signalsTable'));

    return count == 0;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createDB, onUpgrade: _onUpgrade);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      if (oldVersion == 1) {
      }
      await db.execute('PRAGMA user_version = $newVersion');
    }
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER';
    const realType = 'REAL';

    await db.execute('''
    CREATE TABLE $signalsTable ( 
      ${signalsFields.id} $idType,
      ${signalsFields.victimName} $textType,
      ${signalsFields.urgencyLevel} $textType,
      ${signalsFields.lastSeenLatitude} $realType,
      ${signalsFields.lastSeenLongitude} $realType,
      ${signalsFields.lastSeenTime} $textType
    )
  ''');
  }

  Future<helpSignal> create(helpSignal helpSignal) async {
    final db = await instance.database;
    final id = await db.insert(signalsTable, helpSignal.toJson());

    return helpSignal.copy(id: id);
  }

  Future<List<helpSignal>> getAllHelpSignals() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(signalsTable);

    return List.generate(maps.length, (i) {
      return helpSignal(
        id: maps[i][signalsFields.id],
        victimName: maps[i][signalsFields.victimName],
        urgencyLevel: maps[i][signalsFields.urgencyLevel],
        lastSeenLatitude: maps[i][signalsFields.lastSeenLatitude],
        lastSeenLongitude: maps[i][signalsFields.lastSeenLongitude],
        lastSeenTime: DateTime.parse(maps[i][signalsFields.lastSeenTime]),
      );
    });
  }

  Future<void> close() async {
    final db = await instance.database;

    db.close();
  }
}
