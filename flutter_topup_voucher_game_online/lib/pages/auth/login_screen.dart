import 'package:flutter/material.dart';
import 'package:flutter_topup_voucher_game_online/providers/auth_provider.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

import '../../toast.dart';
import '../../widgets/form_container_widget.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSigning = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Login",
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            FormContainerWidget(
              controller: _emailController,
              hintText: "Email",
              isPasswordField: false,
            ),
            const SizedBox(height: 30),
            FormContainerWidget(
              controller: _passwordController,
              hintText: "Password",
              isPasswordField: true,
            ),
            const SizedBox(height: 30),
            SizedBox(
              child: ElevatedButton(
                onPressed: _signIn,
                child:
                    _isSigning == true
                        ? const CircularProgressIndicator(color: Colors.indigo)
                        : const Text('Login'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(color: Colors.blue),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const SignUpScreen());
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100),
            const Text(
              'Lab Sistem Cerdas Teknik Informatika ',
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 2, 123, 178),
                fontWeight: FontWeight.w500,
              ),
            ),
            const Text(
              'Universitas Dian Nuswantoro',
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 7, 145, 208),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _signIn() async {
    setState(() {
      _isSigning = true;
    });
    String email = _emailController.text;
    String password = _passwordController.text;

    final response = await context.read<AuthProvider>().login(email, password);

    setState(() {
      _isSigning = false;
    });
    if (response) {
      showToast(message: "User is Successfully Login");
      Get.off(() => const HomePage());
    } else {
      showToast(message: 'some error occured');
    }
  }
}
