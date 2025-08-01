// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:flutter_topup_voucher_game_online/providers/account_provider.dart';
import 'package:flutter_topup_voucher_game_online/providers/auth_provider.dart';
import 'package:flutter_topup_voucher_game_online/providers/game_provider.dart';
import 'package:flutter_topup_voucher_game_online/widgets/cart_icon_with_badge.dart';
import 'package:flutter_topup_voucher_game_online/widgets/product_category_list.dart';

import '../models/account.dart';
import '../widgets/detail_screen/item_card.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Account? selectedAccount;

  @override
  void initState() {
    super.initState();
    _loadLastAccount();
  }

  double getWidth() {
    FlutterView view = PlatformDispatcher.instance.views.first;
    return view.physicalSize.width / view.devicePixelRatio;
  }

  void _loadLastAccount() {
    final account = context.read<AccountProvider>().getActiveAccount(
      context.read<GameProvider>().gameName,
    );
    if (account != null) {
      selectedAccount = account;
    }
  }

  void _showAccountSelectionDialog(List<Account> accounts) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Pilih Akun Game'),
          children:
              accounts.map((account) {
                return ListTile(
                  title: Text(
                    'ID: ${account.userId} | Server: ${account.serverId}',
                  ),
                  leading: Radio<String>(
                    value: account.accountId.toString(),
                    groupValue: selectedAccount?.accountId.toString(),
                    onChanged: (value) {
                      setState(() {
                        selectedAccount = account;
                      });
                      context.read<AccountProvider>().setActiveAccount(account);
                      Navigator.pop(context); // Tutup dialog setelah pilih
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await context.read<AccountProvider>().deleteAccount(
                        documentId: account.documentId,
                      );

                      if (!mounted) return; // Proteksi context

                      if (selectedAccount?.accountId == account.accountId) {
                        setState(() {
                          selectedAccount = null;
                        });
                      }
                      if (context.mounted) {
                        Navigator.pop(context); // Tutup dialog setelah hapus
                      }
                    },
                  ),
                );
              }).toList(),
        );
      },
    );
  }

  void _showAddAccountDialog() {
    final TextEditingController idController = TextEditingController();
    final TextEditingController serverController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Akun Game'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idController,
                decoration: const InputDecoration(labelText: 'Masukkan ID'),
              ),
              TextField(
                controller: serverController,
                decoration: const InputDecoration(
                  labelText: 'Masukkan Server ID',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final uid = idController.text.trim();
                final sid = serverController.text.trim();
                final gameName = context.read<GameProvider>().gameName;
                final userIdStrapi = context.read<AuthProvider>().user?.id;
                final gameIdStrapi = context.read<GameProvider>().gameId;

                if (uid.isNotEmpty && sid.isNotEmpty && userIdStrapi != null) {
                  final newAccount = Account(
                    accountId: 0,
                    documentId: "",
                    userId: uid,
                    serverId: sid,
                    gameName: gameName,
                  );

                  await context.read<AccountProvider>().addAccount(
                    account: newAccount,
                    userIdStrapi: userIdStrapi.toString(),
                    gameIdStrapi: gameIdStrapi,
                  );

                  if (context.mounted) {
                    Navigator.of(context).pop(); // Tutup dialog
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();
    final gameName = context.read<GameProvider>().gameName;
    final accounts =
        accountProvider.accounts
            .where((acc) => acc.gameName == gameName)
            .toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (accountProvider.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(accountProvider.errorMessage!),
            backgroundColor: Colors.redAccent,
          ),
        );
        accountProvider.clear();
      }
    });

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Detail'),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                context.read<GameProvider>().removeProduct();
                Get.back();
              },
              icon: const Icon(Icons.arrow_back),
            ),
            actions: const [CartIconWithBadge()],
          ),
          body: Column(
            children: [
              const SizedBox(height: 20),

              // Tombol pilih akun dan tambah akun
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _showAccountSelectionDialog(accounts),
                        child: const Text('Pilih Akun Game'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _showAddAccountDialog,
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Akun yang terpilih
              if (selectedAccount != null)
                Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.account_circle, size: 36),
                    title: Text('ID: ${selectedAccount!.userId}'),
                    subtitle: Text('Server: ${selectedAccount!.serverId}'),
                  ),
                ),

              const ProductCategoryList(),

              Expanded(
                child: Consumer<GameProvider>(
                  builder: (context, provider, child) {
                    if (provider.products.isEmpty) {
                      return const Center(child: Text("Pilih Produk Category"));
                    }
                    final products =
                        provider.products
                          ..sort((a, b) => a.price.compareTo(b.price));
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.6,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return GestureDetector(
                          onTap: () {},
                          child: ItemCard(product: product),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        if (accountProvider.isLoading)
          const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
