import 'package:flutter/material.dart';
import 'package:flutter_topup_voucher_game_online/models/cart_item.dart';
import 'package:flutter_topup_voucher_game_online/models/product.dart';
import 'package:flutter_topup_voucher_game_online/models/transaction.dart';
import 'package:flutter_topup_voucher_game_online/providers/account_provider.dart';
import 'package:flutter_topup_voucher_game_online/providers/cart_provider.dart';
import 'package:flutter_topup_voucher_game_online/providers/game_provider.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../pages/midtrans/web_view_payment_page.dart';
import '../../providers/transaction_provider.dart';

class ItemCard extends StatelessWidget {
  final Product product;

  const ItemCard({super.key, required this.product});

  void _showSelectAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Akun Game Belum Dipilih'),
            content: const Text(
              'Silakan pilih akun game terlebih dahulu sebelum melakukan transaksi.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('###,000');
    final cart = Provider.of<CartProvider>(context);

    final gameName = context.read<GameProvider>().gameName;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 60,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported, size: 40);
                },
              ),
            ),
            const SizedBox(height: 10),
            product.bonus == '0' || product.price == 0
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${product.name} ",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Dari\nRp.${formatter.format(product.price)}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${product.name} ${product.currency} + ${product.bonus} bonus",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Dari\n Rp.${formatter.format(product.price)}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    cart.addToCart(
                      CartItem(
                        productId: product.id,
                        quantity: 1,
                        productName: product.name,
                        price: product.price.toInt(),
                        gameName: gameName,
                      ),
                    );

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        final cartItems = cart.items;
                        final filteredItems =
                            cartItems
                                .where((item) => item.gameName == gameName)
                                .toList();
                        final filteredTotal = filteredItems.fold(
                          0,
                          (sum, item) => sum + (item.price * item.quantity),
                        );

                        return Container(
                          padding: const EdgeInsets.all(16),
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Keranjang ($gameName)',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child:
                                    filteredItems.isEmpty
                                        ? const Center(
                                          child: Text(
                                            'Belum ada item untuk game ini',
                                          ),
                                        )
                                        : ListView.builder(
                                          itemCount: filteredItems.length,
                                          itemBuilder: (context, index) {
                                            final item = filteredItems[index];
                                            return ListTile(
                                              leading: const Icon(
                                                Icons.shopping_cart,
                                              ),
                                              title: Text(item.productName),
                                              subtitle: Text(
                                                "Jumlah: ${item.quantity}",
                                              ),
                                              trailing: Text(
                                                "Rp.${formatter.format(item.price * item.quantity)}",
                                                style: const TextStyle(
                                                  color: Colors.deepOrange,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total: Rp.${formatter.format(filteredTotal)}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final transactionProvider =
                                          context.read<TransactionProvider>();
                                      final accountProvider =
                                          context.read<AccountProvider>();

                                      final accountIds = accountProvider
                                          .getActiveAccountGameId(gameName);
                                      if (accountIds.isEmpty) {
                                        _showSelectAccountDialog(context);
                                        return;
                                      }

                                      transactionProvider.setTotalAmount(
                                        filteredTotal,
                                      );
                                      await transactionProvider
                                          .createTransaction(
                                            transaction: Transaction(
                                              accountGameIds: accountIds,
                                              cartItems: filteredItems,
                                            ),
                                          );

                                      if (transactionProvider.snapUrl != null) {
                                        if (context.mounted) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (_) => WebViewPaymentPage(
                                                    url:
                                                        transactionProvider
                                                            .snapUrl!,
                                                  ),
                                            ),
                                          );
                                        }
                                      } else {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                transactionProvider
                                                        .errorMessage ??
                                                    'Terjadi kesalahan',
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: const Text('Buy Sekarang'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.add, color: Colors.deepOrange),
                ),
                Text(
                  cart.getQuantityByProductId(product.id).toString(),
                  style: const TextStyle(color: Colors.deepOrange),
                ),
                IconButton(
                  onPressed: () {
                    cart.removeFromCart(product.id);
                  },
                  icon: const Icon(Icons.remove, color: Colors.deepOrange),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
