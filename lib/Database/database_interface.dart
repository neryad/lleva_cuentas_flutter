// lib/database/database_interface.dart
import 'package:lleva_cuentas/Amount/pages/models/transactions_model.dart';
import 'package:lleva_cuentas/Database/account_model.dart';

/// Interfaz abstracta para la base de datos
/// Permite implementaciones diferentes para móvil y web
abstract class DatabaseInterface {
  // Operaciones de cuentas
  Future<List<Account>> getTest();
  Future<dynamic> newAccount(Account account);
  Future<Account?> getAccountById(int id);
  Future<int> deleteAccount(int id);

  // Operaciones de transacciones
  Future<Transactions> getTransactionById(int id);
  Future<List<Transactions>> getTransactionsById(int id);
  Future<List<Transactions>> getTransactions();
  Future<dynamic> addTransaction(Transactions transactions);
  Future<int> deleteTransaction(int id);
  Future<int> deleteTransactionByAccountId(int id);
  Future<dynamic> updateTransaction(Transactions transaction);
}
