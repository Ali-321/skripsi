class User {
  final int? id;
  final String? username;
  final String? email;
  final String? phone;

  User({this.id, this.phone, this.username, this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? 'null',
      email: json['email'] ?? 'null',
      phone: json['phone'] ?? 'null',
    );
  }
}
