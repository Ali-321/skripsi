import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_topup_voucher_game_online/models/account.dart';
import 'package:flutter_topup_voucher_game_online/models/auth/login_response.dart';
import 'package:flutter_topup_voucher_game_online/models/category_product.dart';
import 'package:flutter_topup_voucher_game_online/models/game.dart';
import 'package:flutter_topup_voucher_game_online/models/product.dart';
import 'package:flutter_topup_voucher_game_online/models/report.dart';
import 'package:flutter_topup_voucher_game_online/models/transaction.dart';
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

  Future<List<Account>> fetchAccounts(String token, int user) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/account-games?filters[user][id][\$eq]=$user&&populate=game',
      ),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((e) => Account.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat akun game dari Strapi');
    }
  }

  Future<void> addAccount(
    Account account,
    String userIdStrapi,
    String gameIdStrapi,
    String token,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/account-games'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },

      body: json.encode(
        account.toJson(userIdStrapi: userIdStrapi, gameIdStrapi: gameIdStrapi),
      ),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Gagal menambahkan akun game');
    }
  }

  Future<void> updateAccount(
    String accountId,
    Account account,
    String gameIdStrapi,
    String token,
  ) async {
    final response = await http.put(
      Uri.parse(
        '$baseUrl/account-games/account-games?filters[id][\$eq]=$accountId',
      ),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: json.encode(account.toUpdateJson(gameIdStrapi: gameIdStrapi)),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengupdate akun game');
    }
  }

  Future<void> deleteAccount(String documentId, String token) async {
    const targetTable = "account-game";

    final response = await http.post(
      Uri.parse('$baseUrl/delete-requests'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "data": {"targetTable": targetTable, "targetDocumentId": documentId},
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal menghapus akun. Status code: ${response.statusCode}',
      );
    }
  }

  Future<Map<String, dynamic>> createTransaction({
    required Transaction transaction,
    required String token,
  }) async {
    final uri = Uri.parse('$baseUrl/transactions');

    final body = jsonEncode(transaction.toJson());

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal membuat transaksi: ${response.body}');
    }

    return jsonDecode(response.body);
  }

  //fetch Transaction
  Future<List<Transaction>> fetchTransactionsWithPayments({
    required String token,
    required int userId,
  }) async {
    final transactionUrl =
        '$baseUrl/transactions?filters[account_games][user][id][\$eq]=$userId&populate[0]=transaction_products.product.category_product.game';

    print("🔍 Fetching transactions for user: $userId");

    final trxResponse = await http.get(
      Uri.parse(transactionUrl),
      headers: {"Authorization": "Bearer $token"},
    );

    print("📥 Transaction response status: ${trxResponse.statusCode}");

    if (trxResponse.statusCode != 200) {
      throw Exception(
        'Failed to fetch transactions: ${trxResponse.statusCode}',
      );
    }

    final List<dynamic> trxData = jsonDecode(trxResponse.body)['data'];
    print("📊 Total transactions fetched: ${trxData.length}");

    List<Transaction> transactions = [];

    for (var trx in trxData) {
      final trxId = trx['id'];
      Map<String, dynamic>? paymentData;

      print("🔄 Fetching payment for transaction ID: $trxId");

      try {
        final paymentRes = await http.get(
          Uri.parse('$baseUrl/payment-by-transaction/$trxId'),
          headers: {"Authorization": "Bearer $token"},
        );

        print(
          "🔍 Payment response status for trx $trxId: ${paymentRes.statusCode}",
        );

        if (paymentRes.statusCode == 200) {
          paymentData = jsonDecode(paymentRes.body);
          print("✅ Payment data for trx $trxId: $paymentData");
        } else {
          print(
            "⚠️ Payment fetch failed for trx $trxId. Defaulting to dummy data.",
          );
          paymentData = {
            'id': 0,
            'order_id': '-',
            'amount': 0,
            'payment_status': 'Pending',
          };
        }
      } catch (e) {
        print("❌ Exception while fetching payment for trx \$trxId: \$e");
        paymentData = {
          'id': 0,
          'order_id': '-',
          'amount': 0,
          'payment_status': 'Pending',
        };
      }

      try {
        final transaction = Transaction.fromJson(trx, paymentData!);
        transactions.add(transaction);
        print("🟢 Transaction added for trx $trxId");
      } catch (e) {
        print("❌ Error parsing transaction for trx $trxId: $e");
      }
    }

    print("✅ Total processed transactions: ${transactions.length}");

    return transactions;
  }

  //post report

  Future<void> createReport({
    required Report report,
    required String token,
    required int userId,
  }) async {
    final uri = Uri.parse('$baseUrl/reports');

    final body = jsonEncode(report.toJson(userId));

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal membuat report: ${response.body}');
    }

    return jsonDecode(response.body);
  }
}
