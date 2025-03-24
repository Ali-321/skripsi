import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_topup_voucher_game_online/pages/cart_details.dart';

import 'package:flutter_topup_voucher_game_online/pages/home_screen.dart';
import 'package:flutter_topup_voucher_game_online/providers/cart_provider.dart';
import 'package:flutter_topup_voucher_game_online/providers/category_product_provider.dart';
import 'package:flutter_topup_voucher_game_online/providers/game_provider.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';
import 'pages/auth/login_screen.dart';
import 'pages/history_screen.dart';
import './pages/profile_screen.dart';
import 'Providers/favorite_provider.dart';

import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(brightness: Brightness.dark),
      home: FutureBuilder(
        future:
            Provider.of<AuthProvider>(context, listen: false).checkAuthStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else {
            final authProvider = Provider.of<AuthProvider>(
              context,
              listen: false,
            );
            return authProvider.isAutheticated
                ? const HomePage()
                : const LoginScreen();
          }
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  List screens = [
    const HomeScreen(),
    const HistoryScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("E - Commerce Shop"),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: IconButton(
              onPressed: () {
                Get.to(CartDetails());
              },
              icon: Icon(Icons.add_shopping_cart, color: Colors.greenAccent),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: 'History', icon: Icon(Icons.history)),
          BottomNavigationBarItem(label: 'Profile', icon: Icon(Icons.person)),
        ],
        currentIndex: currentIndex,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.greenAccent,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
    );
  }
}
