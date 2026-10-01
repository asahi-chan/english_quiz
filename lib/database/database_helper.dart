import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('new60words.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    if (!await databaseExists(path)) {
      await _copyDatabaseFromAssets(path, filePath);
    }

    return await openDatabase(path);
  }

  Future<void> _copyDatabaseFromAssets(String path, String filePath) async {
    await Directory(dirname(path)).create(recursive: true);

    final data = await rootBundle.load('assets/data/$filePath');
    final bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );

    await File(path).writeAsBytes(bytes, flush: true);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
