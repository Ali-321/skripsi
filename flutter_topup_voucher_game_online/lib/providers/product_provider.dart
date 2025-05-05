import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_topup_voucher_game_online/models/category_product.dart';
import 'package:flutter_topup_voucher_game_online/models/local_data.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LocalData _localData = LocalData();
  final Map<int, List<Product>> _productCache = {};
  List<Product> _products = [];

  List<Product> get products => _products;
  Map<int, List<Product>> get productCache => _productCache;

  Future<List<Product>> fetchProducts(int idCategoryProduct) async {
    final token = await _localData.getToken();
    try {
      _products = await _apiService.fetchProducts(token??"", idCategoryProduct);
      return _products;
    } catch (e) {
      throw Exception("Gagal memuat data: $e");
    }
  }

  Future<void> preloadProducts(List<CategoryProduct> categoryProducts) async {
    for (var x in categoryProducts) {
      _productCache[x.id ?? 0] = await fetchProducts(x.id ?? 0);
    }
    notifyListeners();
  }

  void getProductForGame(int categoryProductId) {
    if (_productCache.containsKey(categoryProductId)) {
      _products = _productCache[categoryProductId]!;
    } else {
      _products = []; // 🔥 Pastikan tidak error jika data belum ada
    }
    notifyListeners(); // 🔥 Pastikan UI diperbarui
  }
}
