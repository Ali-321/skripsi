import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataProveder extends ChangeNotifier {
  String? _token;

  String? get token => _token;

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    notifyListeners();
  }

  String getToken() {
    return _token ?? "Null";
  }
}
