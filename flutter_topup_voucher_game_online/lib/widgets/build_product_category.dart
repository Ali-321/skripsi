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
        final width = MediaQuery.of(context).size.width;
        final isSmallScreen = width < 350;

        return GestureDetector(
          onTap: () {
            provider.getProductsbyCategory(id);
          },
          child: Container(
            width: isSmallScreen ? 80 : 100,
            height: isSmallScreen ? 90 : 110,
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? const Color(0xFF7C83FD)
                      : const Color(0xFF2C2C2C),
              borderRadius: BorderRadius.circular(10),
              border:
                  isSelected
                      ? Border.all(color: Colors.white24, width: 1.2)
                      : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Image.network(
                    image,
                    fit: BoxFit.contain,
                    height: isSmallScreen ? 40 : 60,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  name,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: FontWeight.w600,
                    fontSize: isSmallScreen ? 11 : 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
