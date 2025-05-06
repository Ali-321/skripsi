import 'package:flutter/material.dart';
import 'package:flutter_topup_voucher_game_online/models/avatar.dart';
import 'package:flutter_topup_voucher_game_online/models/user.dart';
import 'package:flutter_topup_voucher_game_online/widgets/build_avatar.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController usernameController;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user!;
    firstNameController = TextEditingController(text: user.firstName);
    lastNameController = TextEditingController(text: user.lastName);
    emailController = TextEditingController(text: user.email);
    phoneController = TextEditingController(text: user.phone);
    usernameController = TextEditingController(text: user.username); // New
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    usernameController.dispose(); // New
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<AuthProvider>();
      provider.updateProfile(
        User(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          email: emailController.text,
          phone: phoneController.text,
          username: usernameController.text,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
    }
  }

  void _changeAvatar() async {
    // Dummy list of avatars from Strapi (you can fetch this from API)
    final avatars = context.read<AuthProvider>().getAvatars();
    final selected = await showDialog<Avatar>(
      context: context,
      builder:
          (ctx) => SimpleDialog(
            title: const Text("Select Avatar"),
            children:
                avatars
                    .map(
                      (url) => SimpleDialogOption(
                        onPressed: () => Navigator.pop(ctx, url),
                        child: Image.network(
                          url.imageUrl.toString(),
                          height: 50,
                        ),
                      ),
                    )
                    .toList(),
          ),
    );

    if (selected != null) {
      if (!mounted) return;
      final provider = context.read<AuthProvider>();
      provider.setAvatarSelected(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final avatar = context.watch<AuthProvider>().avatarSelected;

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body:
          user == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildAvatar(
                        avatar?.imageUrl?.toString(),
                      ),
                      TextButton(
                        onPressed: _changeAvatar,
                        child: const Text("Change Avatar"),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                        ),
                        validator:
                            (value) => value!.isEmpty ? 'Required' : null,
                      ),
                      TextFormField(
                        controller: firstNameController,
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                        ),
                        validator:
                            (value) => value!.isEmpty ? 'Required' : null,
                      ),
                      TextFormField(
                        controller: lastNameController,
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                        ),
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator:
                            (value) =>
                                value!.contains('@') ? null : 'Invalid email',
                      ),
                      TextFormField(
                        controller: phoneController,
                        decoration: const InputDecoration(labelText: 'Phone'),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _saveProfile,
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
