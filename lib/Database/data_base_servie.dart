import 'dart:io';

import 'package:lleva_cuentas/Amount/pages/models/transactions_model.dart';
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
    await db
        .execute('CREATE TABLE Accounts (id INTEGER PRIMARY KEY, name TEXT)');

    await db.execute(
        'CREATE TABLE Transactions (id INTEGER PRIMARY KEY, type TEXT, amount REAL, date TEXT, comment TEXT, accountId INT)');
  }

  Future<List<Account>> getTest() async {
    Database db = await instance.database;
    final res = await db.query('Accounts');
    print(res);
    List<Account> accounts =
        res.isNotEmpty ? res.map((e) => Account.fromJson(e)).toList() : [];
    return accounts;
  }

  newAccount(Account account) async {
    Database db = await instance.database;
    final res = await db.insert('Accounts', account.toJson());
  }

//TODO: arrelgar que sea por el id

  Future<List<Transactions>> getTransactionsById(int id) async {
    Database db = await instance.database;
    final res =
        await db.query('Transactions', where: 'accountId=?', whereArgs: [id]);
    print(res);
    List<Transactions> transactions =
        res.isNotEmpty ? res.map((e) => Transactions.fromJson(e)).toList() : [];
    return transactions;
  }
  // Future<List<ProductModel>> getArticlesTmp(String id) async {
  //   final db = await database;
  //   final res = await db.query('product', where: 'listId=?', whereArgs: [id]);

  //   List<ProductModel> art =
  //       res.isNotEmpty ? res.map((e) => ProductModel.fromJson(e)).toList() : [];
  //   return art;
  // }
  Future<List<Transactions>> getTransactions() async {
    Database db = await instance.database;
    final res = await db.query('Transactions');
    print(res);
    List<Transactions> transactions =
        res.isNotEmpty ? res.map((e) => Transactions.fromJson(e)).toList() : [];
    return transactions;
  }

  addTransaction(Transactions transactions) async {
    Database db = await instance.database;
    final res = await db.insert('Transactions', transactions.toJson());
  }
}
