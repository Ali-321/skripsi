import 'package:flutter/foundation.dart';
import 'package:flutter_topup_voucher_game_online/models/avatar.dart';
import 'package:flutter_topup_voucher_game_online/models/local_data.dart';
import 'package:flutter_topup_voucher_game_online/models/user.dart';

import 'package:flutter_topup_voucher_game_online/services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  LocalData localData = LocalData();
  bool _isAuthenticated = false;
  User? _user = User();
  String? _token;
  List<Avatar> _avatars = [];

  List<Avatar> get avatar => _avatars;
  Avatar? _avatarSelected = Avatar(id: 0, name: "", imageUrl: "");

  Avatar? get avatarSelected => _avatarSelected;

  User? get user => _user;
  String? get token => _token;
  bool get isAutheticated => _isAuthenticated;
  bool isLoading = false;
  String? errorMessage;

  List<Avatar> getAvatars() {
    return _avatars;
  }

  Future<void> fetchAvatar() async {
    try {
      _avatars = await _apiService.fetchAvatar(token!);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

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

  void setAvatarSelected(Avatar? avatarSelected) {
    _avatarSelected = avatarSelected;
    notifyListeners();
  }

  Future<bool> changePassword(User? user) async {
    try {
      return await _apiService.changePassword(token, user);
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<void> updateProfile(User user) async {
    try {
      await _apiService.updateUser(
        user.email,
        user.username,
        user.phone,
        user.firstName,
        user.lastName,
        _user!.id,
        _avatarSelected?.id,
        token,
      );
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;

      fetchUserData();
      notifyListeners();
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
      final data = await _apiService.fetchUserData(_token!);

      if (data.id != null) {
        _avatarSelected = data.avatar;
        _user = data;
      }

      notifyListeners();
    }
  }

  Future<void> checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    _token = await localData.getToken();

    if (_token != null && _token != "") {
      _isAuthenticated = true;
      await fetchUserData(); // panggil Api untuk mendapatkan data user
    } else {
      _isAuthenticated = false;
    }
    notifyListeners();
  }
}
