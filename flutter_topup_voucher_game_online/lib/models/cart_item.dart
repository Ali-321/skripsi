class CartItem {
  final int? productId;
  final String productName;
  final int price;
  int quantity;
  final String? gameName;

  CartItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.gameName,
  });

  // ✅ Untuk dikirim ke Strapi
  Map<String, dynamic> toJson() {
    return {"productId": productId, "quantity": quantity};
  }

  // ✅ Untuk menerima dari Strapi (transaction_products)
  factory CartItem.fromJson(Map<String, dynamic> json) {
    final product = json['product'] ?? {};
    return CartItem(
      productId: product['id'],
      productName: product['product_name'] ?? '-',
      price: (json['product_prices'] ?? 0).toInt(),
      quantity: (json['quantity'] ?? 1).toInt(),
      gameName: product['category_product']?['game']?['game_name'],
    );
  }
}
