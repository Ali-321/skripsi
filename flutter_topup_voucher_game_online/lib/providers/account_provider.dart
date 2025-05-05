import 'package:flutter/material.dart';
import 'package:flutter_topup_voucher_game_online/models/account.dart';
import 'package:flutter_topup_voucher_game_online/models/local_data.dart';
import 'package:flutter_topup_voucher_game_online/services/api_service.dart';

class AccountProvider with ChangeNotifier {
  final List<Account> _accounts = [];
  List<Account> get accounts => _accounts;

  
  int? _userId = 0;
  final Map<String, Account> _activeAccounts = {};
  final ApiService _accountService = ApiService();
  LocalData localData = LocalData();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Account? getAccountByGameName(String gameName) {
    try {
      return _accounts.firstWhere((acc) => acc.gameName == gameName);
    } catch (e) {
      return null;
    }
  }

  Account? getActiveAccount(String gameName) {
    return _activeAccounts[gameName];
  }

  void setActiveAccount(Account account) {
    _activeAccounts[account.gameName] = account;
    notifyListeners();
  }

  // ✅ Load semua akun dari Strapi
  Future<void> loadAccounts(int? userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await localData.getToken();
      _userId = userId;
      final loadedAccounts = await _accountService.fetchAccounts(
        token?? "",
        _userId ?? 0,
      );
      _accounts.clear();
      _accounts.addAll(loadedAccounts);
    } catch (e) {
      _errorMessage = 'Gagal memuat akun: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<int> getActiveAccountGameIds() {
    return _activeAccounts
        .values // Ambil semua akun aktif (tanpa nama game)
        .map(
          (acc) => acc.accountId,
        ) // Ubah String "1" jadi int 1 (null kalau gagal)
        .whereType<int>() // Hanya ambil yang berhasil di-convert (bukan null)
        .toList(); // Jadikan List<int>
  }

  List<int> getActiveAccountGameId(String gameName) {
    final activeAccount = _activeAccounts[gameName];
    
    if (activeAccount != null) {
      return [activeAccount.accountId];
    } else {
      return []; // atau bisa juga [0] jika memang diperlukan nilai default
    }
  }

  // ✅ Tambah akun baru ke Strapi
  Future<void> addAccount({
    required Account account,
    required String userIdStrapi,
    required String gameIdStrapi,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await localData.getToken();
      await _accountService.addAccount(
        account,
        userIdStrapi,
        gameIdStrapi,
        token??"",
      );
      // ✅ Optimasi: langsung tambah ke list lokal
      _accounts.add(account);
      await loadAccounts(_userId); //<- update dari database
    } catch (e) {
      _errorMessage = 'Gagal menambahkan akun: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ Hapus akun di Strapi
  Future<void> deleteAccount({required String documentId}) async {
    try {
      final token = await localData.getToken();
      await _accountService.deleteAccount(documentId, token??"");
      await loadAccounts(_userId); // <--- WAJIB setelah delete
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal menghapus akun: $e';
      notifyListeners();
    }
  }

  // ✅ Clear local data
  void clear() {
    _accounts.clear();
    _activeAccounts.clear();
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
