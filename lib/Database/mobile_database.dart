import 'dart:io';

import 'package:lleva_cuentas/Amount/pages/models/transactions_model.dart';
import 'package:lleva_cuentas/Database/account_model.dart';
import 'package:lleva_cuentas/Database/database_interface.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MobileDatabase implements DatabaseInterface {
  static const _dbName = 'llevaCuentas.db';
  static const _dbVersion = 1;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDataBase();
    return _database!;
  }

  _initDataBase() async {
    Directory documentDir = await getApplicationDocumentsDirectory();
    String path = join(documentDir.path, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onOpen: (instance) {},
      onCreate: _createDb,
    );
  }

  _createDb(Database db, int version) async {
    await db
        .execute('CREATE TABLE Accounts (id INTEGER PRIMARY KEY, name TEXT)');
    await db.execute(
        'CREATE TABLE Transactions (id INTEGER PRIMARY KEY, type TEXT, amount REAL, date TEXT, comment TEXT, accountId INT)');
  }

  @override
  Future<List<Account>> getTest() async {
    Database db = await database;
    final res = await db.query('Accounts');
    List<Account> accounts =
        res.isNotEmpty ? res.map((e) => Account.fromJson(e)).toList() : [];
    return accounts;
  }

  @override
  Future<dynamic> newAccount(Account account) async {
    Database db = await database;
    final res = await db.insert('Accounts', account.toJson());
    return res;
  }

  @override
  Future<Account?> getAccountById(int id) async {
    Database db = await database;
    final res = await db.query('Accounts', where: 'id=?', whereArgs: [id]);
    Account? account =
        res.isNotEmpty ? res.map((e) => Account.fromJson(e)).first : null;
    return account;
  }

  @override
  Future<Transactions> getTransactionById(int id) async {
    Database db = await database;
    final res = await db.query('Transactions', where: 'id=?', whereArgs: [id]);
    Transactions transactions = res.isNotEmpty
        ? res.map((e) => Transactions.fromJson(e)).first
        : throw Exception('Transaction not found');
    return transactions;
  }

  @override
  Future<List<Transactions>> getTransactionsById(int id) async {
    Database db = await database;
    final res =
        await db.query('Transactions', where: 'accountId=?', whereArgs: [id]);
    List<Transactions> transactions =
        res.isNotEmpty ? res.map((e) => Transactions.fromJson(e)).toList() : [];
    return transactions;
  }

  @override
  Future<List<Transactions>> getTransactions() async {
    Database db = await database;
    final res = await db.query('Transactions');
    List<Transactions> transactions =
        res.isNotEmpty ? res.map((e) => Transactions.fromJson(e)).toList() : [];
    return transactions;
  }

  @override
  Future<dynamic> addTransaction(Transactions transactions) async {
    Database db = await database;
    final res = await db.insert('Transactions', transactions.toJson());
    return res;
  }

  @override
  Future<int> deleteAccount(int id) async {
    final db = await database;
    final res = await db.delete('Accounts', where: 'id = ?', whereArgs: [id]);
    await deleteTransactionByAccountId(id);
    return res;
  }

  @override
  Future<int> deleteTransactionByAccountId(int id) async {
    final db = await database;
    final res =
        await db.delete('Transactions', where: 'accountId=?', whereArgs: [id]);
    return res;
  }

  @override
  Future<int> deleteTransaction(int id) async {
    final db = await database;
    final res = await db.delete('Transactions', where: 'id=?', whereArgs: [id]);
    return res;
  }

  @override
  Future<dynamic> updateTransaction(Transactions transaction) async {
    final db = await database;
    final res = await db.update(
      'Transactions',
      transaction.toJson(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
    return res;
  }
}
