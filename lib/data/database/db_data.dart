import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../mode/data_all.dart';

class DataDB {
  static final DataDB _instance = DataDB._internal();

  Database? _db;

  DataDB._internal();

  factory DataDB() {
    return _instance;
  }

  /// 創造DB
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    return _db ??= await openDatabase(
      join(dbPath, 'travel.sqlite'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE travel(id INTEGER PRIMARY KEY, by TEXT, msg TEXT, mid TEXT, time INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future insert(DataAll data) async {
    final db = await _initDB();
    await db.insert(
      'travel',
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the dogs from the dogs table.
  // Future<List<DataAll>> dogs() async {
  //   // Get a reference to the database.
  //   final db = _db;
  //
  //   // Query the table for all The Dogs.
  //   final List<Map<String, dynamic>> maps = await db.query('travel');
  //
  //   // Convert the List<Map<String, dynamic> into a List<Dog>.
  //   return List.generate(maps.length, (i) {
  //     return DataAll(
  //       id: maps[i]['id'],
  //       // name: maps[i]['name'],
  //       // age: maps[i]['age'],
  //     );
  //   });
  // }

  Future<void> close() async {
    final db = await _initDB();
    await db.close();
  }
}
