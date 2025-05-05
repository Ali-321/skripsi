import 'package:flutter/material.dart';

import 'package:flutter_topup_voucher_game_online/models/cart_item.dart';
import 'package:provider/provider.dart';
import 'package:flutter_topup_voucher_game_online/providers/cart_provider.dart';
import 'package:flutter_topup_voucher_game_online/providers/account_provider.dart';
// kamu lupa import ini tadi
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import 'midtrans/web_view_payment_page.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    var formatter = NumberFormat('###,000');

    final groupedItems = <String, List<CartItem>>{};

    for (var item in cart.items) {
      groupedItems.putIfAbsent(item.gameName??"", () => []).add(item);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang')),
      body:
          groupedItems.isEmpty
              ? const Center(child: Text('Keranjang kosong'))
              : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ...groupedItems.entries.map((entry) {
                    final gameName = entry.key;
                    final items = entry.value;

                    // ✅ Ambil akun aktif dari AccountProvider
                    final activeAccount = context
                        .watch<AccountProvider>()
                        .getActiveAccount(gameName);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1B1F),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              gameName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (activeAccount != null)
                              Text(
                                'ID: ${activeAccount.userId} (Server ${activeAccount.serverId})',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              )
                            else
                              const Text(
                                'Belum pilih akun',
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 14,
                                ),
                              ),
                            const SizedBox(height: 8),
                            ...items.map((item) {
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  backgroundColor: Colors.deepPurple,
                                  child: Text(
                                    '${item.quantity}x',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(
                                  item.productName,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  'Rp ${formatter.format(item.price)}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    cart.removeFromCart(item.productId ?? 0);
                                  },
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: Rp.${formatter.format(cart.totalPrice)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final transactionProvider =
                              context.read<TransactionProvider>();
                          final accountProvider =
                              context.read<AccountProvider>();

                          transactionProvider.setTotalAmount(cart.totalPrice);

                          await transactionProvider.createTransaction(
                            transaction: Transaction(
                              accountGameIds:
                                  accountProvider.getActiveAccountGameIds(),
                              cartItems: cart.items,
                            ),
                          );

                          if (transactionProvider.snapUrl != null) {
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => WebViewPaymentPage(
                                        url: transactionProvider.snapUrl!,
                                      ),
                                ),
                              );
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    transactionProvider.errorMessage ??
                                        'Terjadi kesalahan',
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text('Checkout'),
                      ),
                    ],
                  ),
                ],
              ),
    );
  }
}
