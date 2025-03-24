import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_topup_voucher_game_online/models/auth/login_response.dart';
import 'package:flutter_topup_voucher_game_online/models/category_product.dart';
import 'package:flutter_topup_voucher_game_online/models/game.dart';
import 'package:flutter_topup_voucher_game_online/models/product.dart';
import 'package:flutter_topup_voucher_game_online/models/user.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = dotenv.env['BASE_URL'] ?? "";

  Future<List<Product>> fetchProducts(
    String token,
    int idCategoryProduct,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/products?filters[category_product][id][\$eq]=$idCategoryProduct',
      ),
      headers: {"Authorization": "Bearer<$token>"},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      return Product.fromJsonList(data);
    } else {
      throw Exception("Gagal memuat data");
    }
  }

  Future<LoginResponse> registerUser(
    String email,
    String username,
    String password,
    String phone,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/local/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = LoginResponse.fromJson(jsonDecode(response.body));

      updateUser(email, username, phone, data.user!.id!, data.token!);

      return data;
    } else {
      throw Exception("register gagal: ${response.body}");
    }
  }

  Future<User> updateUser(
    String email,
    String username,
    String phone,
    int userId,
    String token,
  ) async {
    final response = await http.put(
      Uri.parse("$baseUrl/users/$userId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer<$token>",
      },
      body: jsonEncode({"username": username, "email": email, "phone": phone}),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Login gagal: ${response.body}");
    }
  }

  //ambil data user dengan token
  Future<User> fetchUserData(String token) async {
    final response = await http.get(
      Uri.parse("$baseUrl/users/me"),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        "fetch data user failed: ${response.statusCode} - ${response.body}-$token}",
      );
    }
  }

  Future<LoginResponse> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/local"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"identifier": email, "password": password}),
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      // If the request fails, throw an exception with more details
      throw Exception(
        "Login failed: ${response.statusCode} - ${response.body}",
      );
    }
  }

  //fetch game data
  Future<List<Game>> fetchGameData(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/games?populate=category_products.products'),
      headers: {"Authorization": "Bearer<$token>"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return Game.fromJsonList(data);
    } else {
      throw Exception(
        "Failed to fetch game data: ${response.statusCode} - ${response.body}",
      );
    }
  }

  //fetch category product depends on id game
  Future<List<CategoryProduct>> fetchCategoryProduct(
    String token,
    int idGame,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/category-products?filters[game][id][\$eq]=$idGame'),
      headers: {"Authorization": "Bearer<$token>"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['data'];
      return CategoryProduct.fromJsonList(data);
    } else {
      throw Exception(
        "Failed to fetch category product data: ${response.statusCode} - ${response.body}",
      );
    }
  }
}
