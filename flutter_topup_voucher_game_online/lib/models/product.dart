class Product {
  final int id;
  final String name;
  final double price;
  final String imageUrl;
  final String currency;
  final String bonus;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.currency,
    required this.bonus,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['product_name'],
      price: json['product_price'].toDouble(),
      currency: json['product_currency'],
      bonus: json['product_bonus'],
      imageUrl: json['product_image_url'].toString(),
    );
  }

  static List<Product> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Product.fromJson(json)).toList();
  }
}
