import 'package:flutter/material.dart';
import 'package:flutter_topup_voucher_game_online/models/local_data.dart';
import 'package:flutter_topup_voucher_game_online/models/product.dart';

import 'package:flutter_topup_voucher_game_online/services/api_service.dart';

import '../models/category_product.dart';
import '../models/game.dart';

class GameProvider extends ChangeNotifier {
  LocalData localData = LocalData();
  ApiService apiService = ApiService();

  int? _selectedCategoryId;
  List<Product> _products = [];
  List<CategoryProduct> _categoryProducts = [];
  List<Game> _games = [];
  String _gameName = '';
  String _gameId = '';

  String get gameName => _gameName;
  String get gameId => _gameId;
  List<Game> get games => _games;
  List<Product> get products => _products;
  List<CategoryProduct> get categoryProducts => _categoryProducts;
  int? get selectedCategoryId => _selectedCategoryId;

  Future<void> fetchGame() async {
    final token = await localData.getToken();
    _games = await apiService.fetchGameData(token??"");
    notifyListeners();
  }

  void setGameName(String name) {
    _gameName = name;
    notifyListeners();
  }

  /// 🔥 Ambil `category-products` langsung dari game yang dipilih
  void getCategoriesByGame(int gameId) {
    final game = _games.firstWhere(
      (g) => g.id == gameId,
      orElse:
          () => Game(id: 0, name: "null", image: "null", categoryProducts: []),
    );
    _categoryProducts = game.categoryProducts;
    _gameName = game.name;
    _gameId = game.id.toString();

    notifyListeners();
  }

  void getProductsbyCategory(int categoryId) {
    selectCategory(categoryId);
    final game = _categoryProducts.firstWhere(
      (c) => c.id == categoryId,
      orElse:
          () => CategoryProduct(
            id: 0,
            image: "",
            name: "",
            note: "",
            products: [],
          ),
    );

    _products = game.products;
    notifyListeners();
  }

  void selectCategory(int id) {
    _selectedCategoryId = id;
    notifyListeners();
  }

  void removeProduct() {
    _products = [];
    notifyListeners();
  }
}
