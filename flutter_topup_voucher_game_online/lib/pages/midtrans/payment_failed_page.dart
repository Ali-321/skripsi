import 'package:flutter/material.dart';

class PaymentFailedPage extends StatelessWidget {
  const PaymentFailedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gagal")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.cancel, color: Colors.red, size: 80),
            SizedBox(height: 16),
            Text(
              "Pembayaran Gagal atau Dibatalkan",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
