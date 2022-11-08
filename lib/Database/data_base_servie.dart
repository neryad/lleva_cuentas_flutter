import 'dart:io';

import 'package:lleva_cuentas/Database/account_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseHelper {
  static final _dbName = 'llevaCuentas.db';

  static final _dbVersion = 1;

  static final DataBaseHelper instance = DataBaseHelper._();
  DataBaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDataBase();
    return _database!;
    // if (_database != null) {
    //   _database = await _initDataBase();

    //   return _database;
    // }
    // return _database;
  }

  _initDataBase() async {
    Directory documentDir = await getApplicationDocumentsDirectory();

    String path = join(documentDir.path, _dbName);

    return await openDatabase(path,
        version: _dbVersion, onOpen: (instance) {}, onCreate: _createDb);
  }

  _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
  }

  Future<List> getTest() async {
    Database db = await instance.database;
    final res = await db.query('Test');
    print(res);
    return res;
  }

  newAccount(Account account) async {
    Database db = await instance.database;
    final res = await db.insert('Test', account.toJson());
  }
}
