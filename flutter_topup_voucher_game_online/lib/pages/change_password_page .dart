import 'package:flutter/material.dart';
import 'package:flutter_topup_voucher_game_online/models/user.dart';
import 'package:flutter_topup_voucher_game_online/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    setState(() => isLoading = true);

    final success = await authProvider.changePassword(
      User(
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
        passwordConfirmation: confirmPasswordController.text,
      ),
    );

    setState(() => isLoading = false);

    final message =
        success ? "Password berhasil diubah" : "Gagal mengubah password";
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ganti Password")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password Saat Ini",
                ),
                validator: (value) => value!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password Baru"),
                validator:
                    (value) => value!.length < 6 ? "Minimal 6 karakter" : null,
              ),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Konfirmasi Password Baru",
                ),
                validator:
                    (value) =>
                        value != newPasswordController.text
                            ? "Password tidak cocok"
                            : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _changePassword,
                child:
                    isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Ganti Password"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
