import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final latestVersion = 1;
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('reminder.db');
    return _database!;
  }

  _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: latestVersion,
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE todo_item(id INTEGER PRIMARY KEY, title TEXT, status INTEGER, utime DATETIME DEFAULT CURRENT_TIMESTAMP , ctime DATETIME)',
        );
      },
      onOpen: (db) async {
        // 如果不存在，就创建一个
        return await db.execute(
          'CREATE TABLE IF NOT EXISTS todo_item(id INTEGER PRIMARY KEY, title TEXT, status INTEGER)',
        );
      },
    );
  }

  _clear() async {
    _database?.execute('DELETE FROM todo_item');
  }
}
