// lib/database/data_base_service.dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lleva_cuentas/Database/mobile_database.dart';
import 'package:lleva_cuentas/Database/web_database.dart';
import 'package:lleva_cuentas/database/database_interface.dart';
import 'package:lleva_cuentas/Amount/pages/models/transactions_model.dart';
import 'package:lleva_cuentas/Database/account_model.dart';

// Siempre importa mobile
import 'package:lleva_cuentas/database/mobile_database.dart';

// Import condicional: usa web_database.dart en web, web_database_stub.dart en móvil
import 'package:lleva_cuentas/database/web_database_stub.dart'
    if (dart.library.html) 'package:lleva_cuentas/database/web_database.dart';

class DataBaseHelper {
  static final DataBaseHelper instance = DataBaseHelper._();
  DataBaseHelper._() {
    _database = _createDatabase();
  }

  late final DatabaseInterface _database;

  // Factory que crea la base de datos correcta según la plataforma
  DatabaseInterface _createDatabase() {
    if (kIsWeb) {
      return WebDatabase();
    } else {
      return MobileDatabase();
    }
  }

  // Métodos públicos - mantienen la misma API que antes
  Future<List<Account>> getTest() async {
    return await _database.getTest();
  }

  Future<dynamic> newAccount(Account account) async {
    return await _database.newAccount(account);
  }

  Future<Account?> getAccountById(int id) async {
    return await _database.getAccountById(id);
  }

  Future<Transactions> getTransactionById(int id) async {
    return await _database.getTransactionById(id);
  }

  Future<List<Transactions>> getTransactionsById(int id) async {
    return await _database.getTransactionsById(id);
  }

  Future<List<Transactions>> getTransactions() async {
    return await _database.getTransactions();
  }

  Future<dynamic> addTransaction(Transactions transactions) async {
    return await _database.addTransaction(transactions);
  }

  Future<int> deleteAccount(int id) async {
    return await _database.deleteAccount(id);
  }

  Future<int> deleteTransactionByAccountId(int id) async {
    return await _database.deleteTransactionByAccountId(id);
  }

  Future<int> deleteTransaction(int id) async {
    return await _database.deleteTransaction(id);
  }

  Future<dynamic> updateTransaction(Transactions transaction) async {
    return await _database.updateTransaction(transaction);
  }
}
