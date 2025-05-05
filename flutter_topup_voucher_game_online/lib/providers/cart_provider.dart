import 'package:flutter/material.dart';

import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
 
  List<CartItem> get items => _items;

  void addToCart(CartItem item) {
    final index = _items.indexWhere((i) => i.productId == item.productId);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }


  void removeFromCart(int productId) {
    final index = _items.indexWhere((i) => i.productId == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  int getQuantityByProductId(int productId) {
    final index = _items.indexWhere((i) => i.productId == productId);
    return index >= 0 ? _items[index].quantity : 0;
  }

  int get totalPrice {
    int total = 0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  int get totalItemCount {
    return _items.length;
  }
}
