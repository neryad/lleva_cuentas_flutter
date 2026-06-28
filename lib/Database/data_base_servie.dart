// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:lleva_cuentas/Amount/pages/models/transactions_model.dart';
import 'package:lleva_cuentas/Database/account_model.dart';
import 'package:lleva_cuentas/Database/category_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DataBaseHelper {
  static const _dbName = 'llevaCuentas.db';

  static const _dbVersion = 2;

  static final DataBaseHelper instance = DataBaseHelper._();
  DataBaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDataBase();
    return _database!;
  }

  _initDataBase() async {
    if (kIsWeb) {
      return await databaseFactoryFfiWeb.openDatabase(_dbName,
          options: OpenDatabaseOptions(
              version: _dbVersion,
              onOpen: (instance) {},
              onCreate: _createDb,
              onUpgrade: _onUpgrade));
    }
    Directory documentDir = await getApplicationDocumentsDirectory();

    String path = join(documentDir.path, _dbName);

    return await openDatabase(path,
        version: _dbVersion,
        onOpen: (instance) {},
        onCreate: _createDb,
        onUpgrade: _onUpgrade);
  }

  _createDb(Database db, int version) async {
    await db
        .execute('CREATE TABLE Accounts (id INTEGER PRIMARY KEY, name TEXT)');

    await db.execute(
        'CREATE TABLE Transactions (id INTEGER PRIMARY KEY, type TEXT, amount REAL, date TEXT, comment TEXT, accountId INT, categoria_id INTEGER)');

    await _createCategoriesTable(db);
    await _insertPredefinedCategories(db);
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add categoria_id column to Transactions if it doesn't exist
      try {
        await db.execute('ALTER TABLE Transactions ADD COLUMN categoria_id INTEGER');
      } catch (e) {
        // Column already exists
      }

      await _createCategoriesTable(db);
      await _insertPredefinedCategories(db);
    }
  }

  _createCategoriesTable(Database db) async {
    await db.execute('''
      CREATE TABLE Categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        tipo TEXT NOT NULL,
        color TEXT NOT NULL,
        es_predefinida INTEGER DEFAULT 0
      )
    ''');
  }

  _insertPredefinedCategories(Database db) async {
    for (var category in Category.predefinedCategories) {
      await db.insert('Categories', category.toJson());
    }
  }

  // ===== CATEGORY METHODS =====

  Future<List<Category>> getCategories() async {
    Database db = await instance.database;
    final res = await db.query('Categories');
    return res.map((e) => Category.fromJson(e)).toList();
  }

  Future<List<Category>> getCategoriesByType(String tipo) async {
    Database db = await instance.database;
    final res = await db.query('Categories', where: 'tipo = ?', whereArgs: [tipo]);
    return res.map((e) => Category.fromJson(e)).toList();
  }

  Future<Category?> getCategoryById(int id) async {
    Database db = await instance.database;
    final res = await db.query('Categories', where: 'id = ?', whereArgs: [id]);
    if (res.isNotEmpty) {
      return Category.fromJson(res.first);
    }
    return null;
  }

  Future<int> addCategory(Category category) async {
    Database db = await instance.database;
    // Check for duplicate name (case-insensitive)
    final existing = await db.query(
      'Categories',
      where: 'LOWER(nombre) = LOWER(?) AND tipo = ?',
      whereArgs: [category.nombre, category.tipo],
    );
    if (existing.isNotEmpty) {
      throw Exception('Ya existe una categoría con ese nombre en este tipo');
    }
    return await db.insert('Categories', category.toJson());
  }

  Future<int> updateCategory(Category category) async {
    Database db = await instance.database;
    return await db.update('Categories', category.toJson(),
        where: 'id = ?', whereArgs: [category.id]);
  }

  Future<int> deleteCategory(int id) async {
    Database db = await instance.database;
    // Set transactions with this category to null
    await db.update(
      'Transactions',
      {'categoria_id': null},
      where: 'categoria_id = ?',
      whereArgs: [id],
    );
    return await db.delete('Categories', where: 'id = ?', whereArgs: [id]);
  }

  // ===== ACCOUNT METHODS =====

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

  // ===== TRANSACTION METHODS =====

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

  Future<List<Map<String, dynamic>>> getMonthlyTransactions(int accountId) async {
    Database db = await instance.database;
    final res = await db.rawQuery('''
      SELECT 
        strftime('%Y-%m', date) as month,
        type,
        SUM(amount) as total
      FROM Transactions 
      WHERE accountId = ?
      GROUP BY strftime('%Y-%m', date), type
      ORDER BY month DESC
    ''', [accountId]);
    return res;
  }

  Future<List<Map<String, dynamic>>> getTransactionsByCategory(int accountId) async {
    Database db = await instance.database;
    final res = await db.rawQuery('''
      SELECT 
        c.nombre as category,
        c.color as color,
        SUM(t.amount) as total,
        COUNT(*) as count
      FROM Transactions t
      LEFT JOIN Categories c ON t.categoria_id = c.id
      WHERE t.accountId = ?
      GROUP BY t.categoria_id
      ORDER BY total DESC
    ''', [accountId]);
    return res;
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

  updateTransaction(Transactions transaction) async {
    final db = await instance.database;

    final res = await db.update('Transactions', transaction.toJson(),
        where: 'id = ?', whereArgs: [transaction.id]);

    return res;
  }
}
