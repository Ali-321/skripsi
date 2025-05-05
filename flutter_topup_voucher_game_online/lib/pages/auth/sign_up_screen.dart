import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../providers/auth_provider.dart';
import '../../toast.dart';
import '../../widgets/form_container_widget.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isSigningUp = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              FormContainerWidget(
                controller: _usernameController,
                hintText: "Name",
                isPasswordField: false,
              ),
              const SizedBox(height: 20),
              FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
              ),
              const SizedBox(height: 20),
              FormContainerWidget(
                controller: _phoneController,
                hintText: "Phone",
                isPasswordField: false,
              ),
              const SizedBox(height: 20),
              FormContainerWidget(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _signUp,
                  child:
                      _isSigningUp
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 16),
                          ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(color: Colors.white70),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const LoginScreen());
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    setState(() => _isSigningUp = true);

    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text;
    String phone = _phoneController.text.trim();

    final response = await Provider.of<AuthProvider>(
      context,
      listen: false,
    ).register(username, email, phone, password);

    setState(() => _isSigningUp = false);

    if (response) {
      showToast(message: "User is Successfully created");
      Get.off(() => const HomePage());
    } else {
      showToast(message: 'Terjadi kesalahan saat membuat akun');
    }
  }
}
