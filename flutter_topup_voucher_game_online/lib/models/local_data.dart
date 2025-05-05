import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  Future<void> saveToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token!);
  }

  Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token'); // Akan mengembalikan null jika tidak ada
}


  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
