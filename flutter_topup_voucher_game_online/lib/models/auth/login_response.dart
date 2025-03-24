
import 'package:flutter_topup_voucher_game_online/models/user.dart';

class LoginResponse {
  final String? token;
  final User? user;

  LoginResponse({required this.token, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['jwt'] ?? "null",
      user: User.fromJson(json['user']),
    );
  }
}
