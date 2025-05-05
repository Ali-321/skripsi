import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_topup_voucher_game_online/pages/home_screen.dart';
import 'package:flutter_topup_voucher_game_online/pages/transaction_history_page.dart';
import 'package:flutter_topup_voucher_game_online/pages/profile_screen.dart';
import 'package:flutter_topup_voucher_game_online/pages/auth/login_screen.dart';
import 'package:flutter_topup_voucher_game_online/providers/account_provider.dart';
import 'package:flutter_topup_voucher_game_online/providers/auth_provider.dart';
import 'package:flutter_topup_voucher_game_online/providers/cart_provider.dart';
import 'package:flutter_topup_voucher_game_online/providers/category_product_provider.dart';
import 'package:flutter_topup_voucher_game_online/providers/game_provider.dart';
import 'package:flutter_topup_voucher_game_online/providers/product_provider.dart';
import 'package:flutter_topup_voucher_game_online/providers/report_provider.dart';
import 'package:flutter_topup_voucher_game_online/providers/transaction_provider.dart';
import 'package:flutter_topup_voucher_game_online/widgets/cart_icon_with_badge.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AccountProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Top Up Game App',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7C83FD),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1E1E1E),
          selectedItemColor: Color(0xFF7C83FD),
          unselectedItemColor: Colors.white70,
        ),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF7C83FD),
          secondary: Color(0xFF7C83FD),
        ),
      ),

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

  final List<Widget> screens = [
    const HomeScreen(),
    const TransactionHistoryPage(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Top Up Game"),
        actions: const [CartIconWithBadge()],
      ),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
