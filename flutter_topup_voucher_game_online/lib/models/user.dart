// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_topup_voucher_game_online/models/avatar.dart';

class User {
  final int? id;
  final String? username;
  final String? email;
  final String? phone;
  final String? firstName;
  final String? lastName;
  final Avatar? avatar;
  final String? currentPassword;
  final String? newPassword;
  final String? passwordConfirmation;
  User({
    this.id,
    this.username,
    this.email,
    this.phone,
    this.firstName,
    this.lastName,
    this.avatar,
    this.currentPassword,
    this.newPassword,
    this.passwordConfirmation,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? 'null',
      email: json['email'] ?? 'null',
      phone: json['phone'] ?? 'null',
      avatar: Avatar.fromJson(json['avatar']),
      firstName: json['first_name'] ?? 'null',
      lastName: json['last_name'] ?? 'null',
    );
  }

  factory User.fromJsonLogin(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? 'null',
      email: json['email'] ?? 'null',
      phone: json['phone'] ?? 'null',
      firstName: json['first_name'] ?? 'null',
      lastName: json['last_name'] ?? 'null',
    );
  }
}
