import 'package:flutter_topup_voucher_game_online/models/product.dart';

class CategoryProduct {
  int? id;
  String? image;
  String? name;
  String? note;
  final List<Product> products;
  CategoryProduct({this.id, this.image, this.name, this.note,required this.products});

  factory CategoryProduct.fromJson(Map<String, dynamic> json) {
    return CategoryProduct(
      id: json['id'],
      name: json['category_product_name'] ?? "null",
      image: json['category_image_url'] ?? "null",
      note: json['note'] ?? '',
      products: Product.fromJsonList(json['products']),
    );
  }

  static List<CategoryProduct> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => CategoryProduct.fromJson(json)).toList();
  }
}
