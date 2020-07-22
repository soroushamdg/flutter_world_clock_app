import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:WorldClock/services/world_time.dart';

class DatabaseProvider {
  static final String tableName = 'WCLOCKS';

  // init database
  final Future<Database> database = openDatabase(
    join(getDatabasesPath().toString(), 'world_clocks.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE $tableName(id INTEGER PRIMARY KEY, location TEXT,urlepoint TEXT, clockAppereance INTEGER)');
    },
    version: 1,
  );

  // insert new item
  Future<void> insertWorldTime(WorldTime worldtime) async {
    final Database db = await database;
    print(db);
    await db.insert(tableName, worldtime.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // get number of all rows
  Future<int> queryRowCount() async {
    Database db = await database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tableName'));
  }

  // read full query of database
  Future<List<WorldTime>> readDatabase() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      WorldTime wt = WorldTime(
        id: maps[i]['id'],
        location: maps[i]['location'],
        urlEndpoint: maps[i]['urlepoint'],
        flagURL: maps[i]['location'],
      );
      wt.clockAppearance = (maps[i]['clockAppereance'] == 0)
          ? ClockAppearanceMode.digital
          : ClockAppearanceMode.analog;
      return wt;
    });
  }

  // update item in database
  Future<void> updateWorldtime(WorldTime worldtime) async {
    final db = await database;

    await db.update(
      tableName,
      worldtime.toMap(),
      where: "id = ?",
      whereArgs: [worldtime.id],
    );
  }

  // delete item from database
  Future<void> deleteWorldtime(int id) async {
    final db = await database;

    await db.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
