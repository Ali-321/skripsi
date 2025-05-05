import 'package:flutter/material.dart';
import 'package:flutter_topup_voucher_game_online/pages/detail_screen.dart';
import 'package:flutter_topup_voucher_game_online/providers/account_provider.dart';
import 'package:flutter_topup_voucher_game_online/providers/auth_provider.dart';
import 'package:flutter_topup_voucher_game_online/providers/game_provider.dart';
import 'package:flutter_topup_voucher_game_online/providers/transaction_provider.dart';
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
    Future.microtask(_loadAccounts);
    Future.microtask(_loadHistoryTransaction);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Expanded(child: _buildAllProducts(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAllProducts(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        if (gameProvider.games.isEmpty) {
          return const Center(
            child: Text(
              "Tidak ada game tersedia",
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        final crossAxisCount = MediaQuery.of(context).size.width > 600 ? 3 : 2;

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.9,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: gameProvider.games.length,
          itemBuilder: (context, index) {
            final game = gameProvider.games[index];
            return GestureDetector(
              onTap: () {
                Provider.of<GameProvider>(
                  context,
                  listen: false,
                ).getCategoriesByGame(game.id);
                Get.to(() => const DetailScreen());
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
    await provider.fetchGame();
    if (!mounted) return;
    setState(() {});
  }

  void _loadAccounts() async {
    if (!mounted) return;
    final userId = context.read<AuthProvider>().user?.id;
    await context.read<AccountProvider>().loadAccounts(userId);
  }

  void _loadHistoryTransaction() async {
    if (!mounted) return;
    final userId = context.read<AuthProvider>().user?.id;
    await context.read<TransactionProvider>().fetchTransactionsWithPayments(
      userId,
    );
  }
}
