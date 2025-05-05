import 'package:flutter/material.dart';
import 'package:flutter_topup_voucher_game_online/models/game.dart';

class GameCard extends StatelessWidget {
  final Game game;
  const GameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AspectRatio(
              aspectRatio: 1.5,
              child: Image.network(
                game.image,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      color: Colors.grey[800],
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.red),
                      ),
                    ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Text(
              game.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
