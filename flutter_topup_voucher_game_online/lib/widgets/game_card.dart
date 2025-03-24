import 'package:flutter/material.dart';
import 'package:flutter_topup_voucher_game_online/models/game.dart';

class GameCard extends StatefulWidget {
  final Game game;
  const GameCard({super.key, required this.game});

  @override
  State<GameCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<GameCard> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width:
          MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1.0)).size.width /
          2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.grey,
      ),
      child: Column(
        children: [
          /* Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => provider.toggleFavorite(widget.product),
                child: Icon(
                  provider.isExist(widget.product)
                      ? Icons.favorite
                      : Icons.favorite_border_outlined,
                  color: Colors.red,
                ),
              ),
            ],
          ),*/
          SizedBox(
            height: 130,
            child: Image.network(
              widget.game.image.toString(),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.game.name.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
