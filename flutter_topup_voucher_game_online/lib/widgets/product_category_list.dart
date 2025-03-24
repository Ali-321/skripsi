import 'package:flutter/material.dart';
import 'package:flutter_topup_voucher_game_online/providers/game_provider.dart';

import 'package:provider/provider.dart';

import 'build_product_category.dart';

class ProductCategoryList extends StatelessWidget {
  const ProductCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Consumer<GameProvider>(
        builder: (context, provider, child) {
          if (provider.categoryProducts.isEmpty) {
            return const Center(
              child: Text("Pilih Category"),
            ); // Loading indicator
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                provider.categoryProducts.map((category) {
                  return BuildProductCategory(
                    name: category.name ?? "No Name",
                    image: category.image ?? "",
                    id: category.id ?? 0,
                  );
                }).toList(),
          );
        },
      ),
    );
  }
}

