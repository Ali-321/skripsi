import 'package:flutter_topup_voucher_game_online/models/payment.dart';

import 'cart_item.dart';

class Transaction {
  final String? id;
  final List<int> accountGameIds;
  final List<CartItem> cartItems;
  final DateTime? transactionDate;
  final Payment? payment;

  Transaction({
    this.id,
    required this.accountGameIds,
    required this.cartItems,
    this.transactionDate,
    this.payment,
  });

  // ✅ Convert dari JSON (jika kamu ambil dari API Strapi)
  factory Transaction.fromJson(
    Map<String, dynamic> json,
    Map<String, dynamic> jsonP,
  ) {
    return Transaction(
      id: json['id'].toString(),
      accountGameIds: [],
      cartItems:
          (json['transaction_products'] ?? [])
              .map<CartItem>((item) => CartItem.fromJson(item))
              .toList(),
      transactionDate:
          DateTime.tryParse(json['transaction_date'] ?? '')?.toLocal(),
      payment: Payment.fromJson(jsonP),
    );
  }

  // ✅ Untuk dikirim ke Strapi saat POST transaksi
  Map<String, dynamic> toJson() {
    return {
      "data": {
        "account_games": accountGameIds,
        "cart_items": cartItems.map((item) => item.toJson()).toList(),
      },
    };
  }
}
