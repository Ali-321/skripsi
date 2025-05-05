import 'package:flutter/material.dart';
import 'package:flutter_topup_voucher_game_online/models/category_product.dart';
import 'package:flutter_topup_voucher_game_online/models/game.dart';
import 'package:flutter_topup_voucher_game_online/models/local_data.dart';
import 'package:flutter_topup_voucher_game_online/services/api_service.dart';

class CategoryProductProvider extends ChangeNotifier {
  final LocalData _localData = LocalData();
  final ApiService _apiService = ApiService();
  final Map<int, List<CategoryProduct>> _categoryCache = {};
  List<CategoryProduct> _categoryProduct = [];

  List<CategoryProduct> get categoryProduct => _categoryProduct;
  Map<int, List<CategoryProduct>> get categoryCache => _categoryCache;

  Future<List<CategoryProduct>> fetchCategoryProduct(int idGame) async {
    final token = await _localData.getToken();

    _categoryProduct = await _apiService.fetchCategoryProduct(token??"", idGame);

    return _categoryProduct;
  }

  Future<void> preloadCategories(List<Game> game) async {
    for (var x in game) {
      _categoryCache[x.id] = await fetchCategoryProduct(x.id);
    }
    notifyListeners();
  }

  void getCategoryForGame(int gameId) {
    if (_categoryCache.containsKey(gameId)) {
      _categoryProduct = _categoryCache[gameId]!;
    } else {
      _categoryProduct = []; // 🔥 Pastikan tidak error jika data belum ada
    }
    notifyListeners(); // 🔥 Pastikan UI diperbarui
  }
}
