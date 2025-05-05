import 'package:flutter/material.dart';
import 'package:flutter_topup_voucher_game_online/pages/report_problem_screen.dart';
import 'package:flutter_topup_voucher_game_online/providers/account_provider.dart';
import 'package:flutter_topup_voucher_game_online/providers/auth_provider.dart';
import 'package:flutter_topup_voucher_game_online/toast.dart';
import 'package:flutter_topup_voucher_game_online/pages/auth/login_screen.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan'), centerTitle: false),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.user;

          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.account_circle,
                      size: 100,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Halo, ${user.username ?? 'Pengguna'}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email ?? 'Email tidak tersedia',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const Text(
                "Pengaturan Akun",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Profil Saya"),
                onTap: () {
                  // TODO: navigasi ke halaman profil
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text("Ganti Password"),
                onTap: () {
                  // TODO: navigasi ke halaman ubah password
                },
              ),
              const SizedBox(height: 20),
              const Divider(),
              const Text(
                "Laporan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text("Laporkan Masalah"),
                onTap: () {
                  Get.to(ReportProblemScreen());
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text("Keluar"),
                onPressed: () {
                  context.read<AccountProvider>().clear();
                  authProvider.logout();
                  Get.offAll(() => const LoginScreen());
                  showToast(message: "Berhasil keluar");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
