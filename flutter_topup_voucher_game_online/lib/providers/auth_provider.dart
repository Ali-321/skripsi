import 'package:flutter/foundation.dart';
import 'package:flutter_topup_voucher_game_online/models/local_data.dart';
import 'package:flutter_topup_voucher_game_online/models/user.dart';

import 'package:flutter_topup_voucher_game_online/services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  LocalData localData = LocalData();
  bool _isAuthenticated = false;
  User? _user = User();
  String? _token;

  User? get user => _user;
  String? get token => _token;
  bool get isAutheticated => _isAuthenticated;

  Future<bool> login(String email, String password) async {
    final data = await _apiService.loginUser(email, password);
    if (data.user != null) {
      _user = data.user!;
      _token = data.token!;
      _isAuthenticated = true;

      // simpan token jika aplikasi di tutup aplikasi akan tetap keadaan login
      localData.saveToken(_token);

      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> register(
    String username,
    String email,
    String phone,
    String password,
  ) async {
    final data = await _apiService.registerUser(
      email,
      username,
      password,
      phone,
    );
    if (data.user != null) {
      _user = data.user!;
      _token = data.token!;
      _isAuthenticated = true;

      // simpan token jika aplikasi di tutup aplikasi akan tetap keadaan login
      localData.saveToken(_token);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    localData.removeToken();
    _token = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> fetchUserData() async {
    _token = await localData.getToken();
    if (_token != null) {
      _user = await _apiService.fetchUserData(_token!);
      notifyListeners();
    }
  }

  Future<void> checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    _token = await localData.getToken();

    if (_token != null) {
      _isAuthenticated = true;
      await fetchUserData(); // panggil Api untuk mendapatkan data user
    } else {
      _isAuthenticated = false;
    }
    notifyListeners();
  }
}
