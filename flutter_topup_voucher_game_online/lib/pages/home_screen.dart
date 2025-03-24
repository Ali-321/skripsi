import 'package:flutter/material.dart';
import 'package:flutter_topup_voucher_game_online/pages/detail_screen.dart';

import 'package:flutter_topup_voucher_game_online/providers/game_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';


import '../widgets/game_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    fetchGame();
    /* WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<CategoryProductProvider>(
        context,
        listen: false,
      );
      final gameProvider = Provider.of<GameProvider>(context, listen: false);
      await provider.preloadCategories(
        gameProvider.games,
      ); // 🔥 Tunggu preload selesai
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      final categoryProductProvider = Provider.of<CategoryProductProvider>(
        context,
        listen: false,
      );
      await provider.preloadProducts(
        categoryProductProvider.categoryProduct,
      ); // 🔥 Tunggu preload selesai
    }); */
  }

  int isSelected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Up Games',
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildProductCategory(index: 0, name: 'All Products'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildAllProducts(context)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  _buildProductCategory({required int index, required String name}) {
    return GestureDetector(
      onTap: () => setState(() => isSelected = index),
      child: Container(
        width: 100,
        height: 40,
        margin: const EdgeInsets.only(top: 10, right: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected == index ? Colors.amber : Colors.greenAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(name, style: const TextStyle(color: Colors.black)),
      ),
    );
  }

  _buildAllProducts(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        if (gameProvider.games.isEmpty) {
          return const Center(child: Text("Tidak ada game tersedia"));
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: (100 / 100),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          scrollDirection: Axis.vertical,
          itemCount:
              gameProvider.games.length, // ✅ Ambil jumlah data dari provider
          itemBuilder: (context, index) {
            final game =
                gameProvider.games[index]; // ✅ Ambil data dari provider
            return GestureDetector(
              onTap: () {
                // Tambahkan aksi jika game diklik
                Provider.of<GameProvider>(
                  context,
                  listen: false,
                ).getCategoriesByGame(game.id);
                print("Game Dipilih: ${game.name} ");
                Get.to(DetailScreen());
              },
              child: GameCard(game: game),
            );
          },
        );
      },
    );
  }

  Future<void> fetchGame() async {
    final provider = Provider.of<GameProvider>(context, listen: false);
    provider.fetchGame(); // 👈 Async gap here
    if (!mounted) return; // ✅ Ensure widget is still active before updating UI

    setState(() {}); // 👈 This is safe now
  }

  /*_buildMl() => GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: (100 / 140),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        scrollDirection: Axis.vertical,
        itemCount: MyProducts.MlList.length,
        itemBuilder: (context, index) {
          final mList = MyProducts.MlList[index];
          return GestureDetector(
              onTap: () {
                Get.to(() => DetailScreen(p: mList));
              },
              child: ProductCard(product: mList));
        },
      );
 
 _buildEt() => GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: (100 / 140),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        scrollDirection: Axis.vertical,
        itemCount: MyProducts.EtList.length,
        itemBuilder: (context, index) {
          final eList = MyProducts.EtList[index];
          return GestureDetector(
              onTap: () {
                Get.to(() => DetailScreen(p: eList));
              },
              child: ProductCard(product: eList));
        },
      );
      */
}
