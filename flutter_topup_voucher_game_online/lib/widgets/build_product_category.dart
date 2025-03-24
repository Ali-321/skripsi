import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';

class BuildProductCategory extends StatelessWidget {
  final String name;
  final String image;
  final int id;

  const BuildProductCategory({
    super.key,
    required this.name,
    required this.image,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, provider, child) {
        bool isSelected = provider.selectedCategoryId == id;

        return GestureDetector(
          onTap: () {
            provider.getProductsbyCategory(id);
          },
          child: Container(
            width: 100,
            height: 100,
            margin: const EdgeInsets.only(top: 10, right: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? Colors.amber : Colors.greenAccent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              verticalDirection: VerticalDirection.up,

              children: [
                Image.network(
                  image,
                  fit: BoxFit.fitWidth,
                  height: 60,

                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey,
                    );
                  },
                ),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
