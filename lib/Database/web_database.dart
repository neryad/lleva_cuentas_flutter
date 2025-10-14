import 'dart:convert';
import 'dart:html' as html;
import 'package:lleva_cuentas/Amount/pages/models/transactions_model.dart';
import 'package:lleva_cuentas/Database/account_model.dart';
import 'package:lleva_cuentas/database/database_interface.dart';

class WebDatabase implements DatabaseInterface {
  static const String _accountsKey = 'accounts_storage';
  static const String _transactionsKey = 'transactions_storage';
  static const String _accountCounterKey = 'account_id_counter';
  static const String _transactionCounterKey = 'transaction_id_counter';

  final html.Storage _localStorage = html.window.localStorage;

  List<Map<String, dynamic>> _getList(String key) {
    final data = _localStorage[key];
    if (data == null || data.isEmpty) return [];
    try {
      final List<dynamic> decoded = json.decode(data);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error parsing $key: $e');
      return [];
    }
  }

  void _saveList(String key, List<Map<String, dynamic>> list) {
    _localStorage[key] = json.encode(list);
  }

  int _getCounter(String key) {
    final value = _localStorage[key];
    return value != null ? int.tryParse(value) ?? 1 : 1;
  }

  void _saveCounter(String key, int value) {
    _localStorage[key] = value.toString();
  }

  int _getNextId(String counterKey) {
    int current = _getCounter(counterKey);
    _saveCounter(counterKey, current + 1);
    return current;
  }

  @override
  Future<List<Account>> getTest() async {
    final accountsList = _getList(_accountsKey);
    return accountsList.map((json) => Account.fromJson(json)).toList();
  }

  @override
  Future<dynamic> newAccount(Account account) async {
    final accountsList = _getList(_accountsKey);
    final newId = _getNextId(_accountCounterKey);
    final accountWithId = Account(
      id: newId,
      name: account.name,
    );
    accountsList.add(accountWithId.toJson());
    _saveList(_accountsKey, accountsList);
    return newId;
  }

  @override
  Future<Account?> getAccountById(int id) async {
    final accountsList = _getList(_accountsKey);
    try {
      final accountJson = accountsList.firstWhere(
        (acc) => acc['id'] == id,
      );
      return Account.fromJson(accountJson);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<int> deleteAccount(int id) async {
    final accountsList = _getList(_accountsKey);
    final initialLength = accountsList.length;
    accountsList.removeWhere((acc) => acc['id'] == id);
    _saveList(_accountsKey, accountsList);
    await deleteTransactionByAccountId(id);
    return initialLength - accountsList.length;
  }

  @override
  Future<Transactions> getTransactionById(int id) async {
    final transactionsList = _getList(_transactionsKey);
    final transactionJson = transactionsList.firstWhere(
      (trans) => trans['id'] == id,
      orElse: () => throw Exception('Transaction not found'),
    );
    return Transactions.fromJson(transactionJson);
  }

  @override
  Future<List<Transactions>> getTransactionsById(int accountId) async {
    final transactionsList = _getList(_transactionsKey);
    final filtered = transactionsList
        .where((trans) => trans['accountId'] == accountId)
        .map((json) => Transactions.fromJson(json))
        .toList();
    return filtered;
  }

  @override
  Future<List<Transactions>> getTransactions() async {
    final transactionsList = _getList(_transactionsKey);
    return transactionsList.map((json) => Transactions.fromJson(json)).toList();
  }

  @override
  Future<dynamic> addTransaction(Transactions transaction) async {
    final transactionsList = _getList(_transactionsKey);
    final newId = _getNextId(_transactionCounterKey);
    final transactionWithId = Transactions(
      id: newId,
      type: transaction.type,
      amount: transaction.amount,
      date: transaction.date,
      comment: transaction.comment,
      accountId: transaction.accountId,
    );
    transactionsList.add(transactionWithId.toJson());
    _saveList(_transactionsKey, transactionsList);
    return newId;
  }

  @override
  Future<int> deleteTransaction(int id) async {
    final transactionsList = _getList(_transactionsKey);
    final initialLength = transactionsList.length;
    transactionsList.removeWhere((trans) => trans['id'] == id);
    _saveList(_transactionsKey, transactionsList);
    return initialLength - transactionsList.length;
  }

  @override
  Future<int> deleteTransactionByAccountId(int accountId) async {
    final transactionsList = _getList(_transactionsKey);
    final initialLength = transactionsList.length;
    transactionsList.removeWhere((trans) => trans['accountId'] == accountId);
    _saveList(_transactionsKey, transactionsList);
    return initialLength - transactionsList.length;
  }

  @override
  Future<dynamic> updateTransaction(Transactions transaction) async {
    final transactionsList = _getList(_transactionsKey);
    final index =
        transactionsList.indexWhere((trans) => trans['id'] == transaction.id);
    if (index == -1) {
      throw Exception('Transaction not found');
    }
    transactionsList[index] = transaction.toJson();
    _saveList(_transactionsKey, transactionsList);
    return 1;
  }
}
