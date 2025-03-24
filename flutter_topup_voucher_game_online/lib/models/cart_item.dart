class CartItem {
  final int productId;
  final String productName;
  final int price;
  final int quantity;

  CartItem({
    required this.productId,
    required this.productName,
    required this.price,
    this.quantity = 1,
  });
}
