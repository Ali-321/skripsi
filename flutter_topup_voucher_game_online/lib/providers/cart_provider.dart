import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addToCart(CartItem item) {
    final index = _items.indexWhere((e) => e.productId == item.productId);
    if (index != -1) {
      _items[index] = CartItem(
        productId: item.productId,
        productName: item.productName,
        price: item.price,
        quantity: _items[index].quantity + 1,
      );
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeFromCart(int productId) {
    _items.removeWhere((item) => item.productId == productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  int get totalPrice {
    return _items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }
}
