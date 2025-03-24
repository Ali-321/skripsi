import 'package:flutter/material.dart';
import 'package:flutter_topup_voucher_game_online/models/product.dart';
import 'package:intl/intl.dart';

class ItemCard extends StatelessWidget {
  final Product product;

  const ItemCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('###,000');

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: const Color.fromARGB(255, 255, 255, 255),
        ),

        child: Column(
          children: [
            // Gambar Produk
            SizedBox(
              height: 80,
              child: Image.network(
                product.imageUrl, // Gunakan URL dari API
                fit: BoxFit.contain,

                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported, size: 40);
                },
              ),
            ),
            const SizedBox(height: 10),

            // Harga dan Informasi Produk
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
                      "${product.name} ${product.currency} +  ${product.bonus} bonus",
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
                ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
