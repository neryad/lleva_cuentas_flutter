// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:lleva_cuentas/Amount/pages/models/transactions_model.dart';
import 'package:lleva_cuentas/Database/account_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseHelper {
  static const _dbName = 'llevaCuentas.db';

  static const _dbVersion = 1;

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

    List<Account> accounts =
        res.isNotEmpty ? res.map((e) => Account.fromJson(e)).toList() : [];
    return accounts;
  }

  newAccount(Account account) async {
    Database db = await instance.database;
    final res = await db.insert('Accounts', account.toJson());
    return res;
  }

  Future<Account?> getAccountById(int id) async {
    Database db = await instance.database;
    final res = await db.query('Accounts', where: 'id=?', whereArgs: [id]);
    Account account = res.isNotEmpty
        ? res.map((e) => Account.fromJson(e)).first
        : [] as Account;
    return account;
  }

  Future<Transactions> getTransactionById(int id) async {
    Database db = await instance.database;
    final res = await db.query('Transactions', where: 'id=?', whereArgs: [id]);
    Transactions transactions = res.isNotEmpty
        ? res.map((e) => Transactions.fromJson(e)).first
        : [] as Transactions;
    return transactions;
  }

  Future<List<Transactions>> getTransactionsById(int id) async {
    Database db = await instance.database;
    final res =
        await db.query('Transactions', where: 'accountId=?', whereArgs: [id]);

    List<Transactions> transactions =
        res.isNotEmpty ? res.map((e) => Transactions.fromJson(e)).toList() : [];
    return transactions;
  }

  Future<List<Transactions>> getTransactions() async {
    Database db = await instance.database;
    final res = await db.query('Transactions');

    List<Transactions> transactions =
        res.isNotEmpty ? res.map((e) => Transactions.fromJson(e)).toList() : [];
    return transactions;
  }

  addTransaction(Transactions transactions) async {
    Database db = await instance.database;
    final res = await db.insert('Transactions', transactions.toJson());
    return res;
  }

  Future<int> deleteAccount(int id) async {
    final db = await instance.database;

    final res = await db.delete('Accounts', where: 'id = ?', whereArgs: [id]);
    await deleteTransactionByAccountId(id);
    return res;
  }

  Future<int> deleteTransactionByAccountId(int id) async {
    final db = await instance.database;

    final res =
        await db.delete('Transactions', where: 'accountId=?', whereArgs: [id]);

    return res;
  }

  Future<int> deleteTransaction(int id) async {
    final db = await instance.database;

    final res = await db.delete('Transactions', where: 'id=?', whereArgs: [id]);

    return res;
  }

  // Future<int> deleteTransactionByAccountId(int id) async {
  //   final db = await instance.database;

  //   final res =
  //       await db.delete('Transactions', where: 'id = ?', whereArgs: [id]);

  //   return res;
  // }

  updateTransaction(Transactions transaction) async {
    final db = await instance.database;

    final res = await db.update('Transactions', transaction.toJson(),
        where: 'id = ?', whereArgs: [transaction.id]);

    return res;
  }
}
