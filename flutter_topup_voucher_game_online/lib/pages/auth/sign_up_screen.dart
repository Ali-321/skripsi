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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Sign Up",
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            FormContainerWidget(
              controller: _usernameController,
              hintText: "Name",
              isPasswordField: false,
            ),
            const SizedBox(height: 30),
            FormContainerWidget(
              controller: _emailController,
              hintText: "Email",
              isPasswordField: false,
            ),
            const SizedBox(height: 30),
            FormContainerWidget(
              controller: _phoneController,
              hintText: "Phone",
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
                onPressed: _signUp,
                child:
                    _isSigningUp
                        ? const CircularProgressIndicator(color: Colors.indigo)
                        : const Text('Sign Up'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account? ",
                  style: TextStyle(color: Colors.blue),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const LoginScreen());
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _signUp() async {
    setState(() {
      _isSigningUp = true;
    });

    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String phone = _phoneController.text;

    final response = await Provider.of<AuthProvider>(
      context,
      listen: false,
    ).register(username, email, phone, password);
    setState(() {
      _isSigningUp = false;
    });

    if (response) {
      showToast(message: "User is Successfully created");
      Get.off(() => const HomePage());
    } else {
      showToast(message: 'some error happned');
    }
  }
}
