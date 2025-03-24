import 'package:flutter_topup_voucher_game_online/models/category_product.dart';

class Game {
  final int id;
  final String name;
  final String image;
  final List<CategoryProduct> categoryProducts;

  Game({
    required this.id,
    required this.name,
    required this.image,
    required this.categoryProducts,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      name: json['game_name'],
      image: json['game_img_url'],
      categoryProducts: CategoryProduct.fromJsonList(json['category_products']),
    );
  }

  static List<Game> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Game.fromJson(json)).toList();
  }
}
