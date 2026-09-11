import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();

  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {
    late String path;

    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;

      path = 'scout.db';
    } else {
      final databasePath = await getDatabasesPath();

      path = join(databasePath, 'scout.db');
    }

    return openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE players(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        position TEXT NOT NULL,
        matches INTEGER NOT NULL,
        goals INTEGER NOT NULL,
        assists INTEGER NOT NULL
      )
    ''');
  }
}
