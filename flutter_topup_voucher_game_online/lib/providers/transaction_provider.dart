import 'package:flutter/material.dart';
import 'package:flutter_topup_voucher_game_online/models/local_data.dart';
import '../models/transaction.dart';
import '../services/api_service.dart';

class TransactionProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LocalData _localData = LocalData();
  int? _userId = 0;

  List<Transaction?> _listTransaction = [];
  List<Transaction?> get listTransaction => _listTransaction;

  Transaction? _transaction;
  Transaction? get transaction => _transaction;

  bool isLoading = false;
  String? errorMessage;
  String? snapUrl; // Snap Midtrans URL
  String _orderId = "-";
  int _totalAmount = 0;

  String get orderId => _orderId;
  int get totalAmount => _totalAmount;

  void setOrderId(String orderId) {
    _orderId = orderId;
    notifyListeners();
  }

  void setTotalAmount(int totalAmount) {
    _totalAmount = totalAmount;
    notifyListeners();
  }

  List<Transaction?> getListTransaction() {
    return _listTransaction;
  }

  DateTime get transactionDate =>
      _transaction?.transactionDate ?? DateTime.now();

  Future<void> createTransaction({required Transaction transaction}) async {
    isLoading = true;
    errorMessage = null;
    snapUrl = null;
    notifyListeners();

    try {
      final token = await _localData.getToken();
      final response = await _apiService.createTransaction(
        transaction: transaction,
        token: token ?? "",
      );
      fetchTransactionsWithPayments(_userId);
      snapUrl = response['redirect_url']; // Snap URL Midtrans
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTransactionsWithPayments(int? userId) async {
    _userId = userId;
    try {
      final token = await _localData.getToken();
      _listTransaction = await _apiService.fetchTransactionsWithPayments(
        token: token ?? "",
        userId: userId ?? 0,
      );
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setTransaction(Transaction trx) {
    _transaction = trx;
    notifyListeners();
  }

  void clear() {
    _transaction = null;
    snapUrl = null;
    errorMessage = null;
    notifyListeners();
  }
}
