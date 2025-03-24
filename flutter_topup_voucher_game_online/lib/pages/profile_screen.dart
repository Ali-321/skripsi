import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../toast.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "hello ${authProvider.user!.username}\n",

                    style: TextStyle(color: Colors.amber),
                  ),
                  GestureDetector(
                    onTap: () {
                      authProvider.logout();
                      Get.to(() => const LoginScreen());
                      showToast(message: "User is Successfully Sign Out");
                    },
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
