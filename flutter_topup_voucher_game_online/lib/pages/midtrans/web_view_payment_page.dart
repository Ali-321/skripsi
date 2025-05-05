import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

import '../../providers/transaction_provider.dart';
import 'payment_success_page.dart';
import 'payment_failed_page.dart'; // pastikan ini ada

class WebViewPaymentPage extends StatefulWidget {
  final String url;

  const WebViewPaymentPage({super.key, required this.url});

  @override
  State<WebViewPaymentPage> createState() => _WebViewPaymentPageState();
}

class _WebViewPaymentPageState extends State<WebViewPaymentPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (request) {
                final url = request.url;
                print("🔍 Navigating to: $url");

                if (url.contains('transaction_status=settlement')) {
                  final uri = Uri.parse(request.url);
                  final orderId = uri.queryParameters['order_id'];
                  final transactionProvider =
                      context.read<TransactionProvider>();
                  transactionProvider.setOrderId(orderId.toString());

                  Future.microtask(() {
                    if (mounted) {
                      Get.back(); // Tutup WebView
                      print("bbbbbbbbbbbbbbbbbbbbbbbb");
                      _showResult(success: true);
                    }
                  });
                  return NavigationDecision.prevent;
                }

                if (url.contains('transaction_status=cancel') ||
                    url.contains('transaction_status=deny') ||
                    url.contains('transaction_status=expire')) {
                  Future.microtask(() {
                    if (mounted) {
                      Get.back(); // Tutup WebView
                      _showResult(success: false);
                    }
                  });
                  return NavigationDecision.prevent;
                }

                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.url));
  }

  void _showResult({required bool success}) {
    final color = success ? Colors.green : Colors.red;
    final message =
        success ? 'Pembayaran berhasil!' : 'Pembayaran gagal atau dibatalkan.';

    if (!mounted) return;

    // ✅ Tampilkan snackbar
    Get.snackbar(
      'Status Transaksi',
      message,
      backgroundColor: color,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );

    Future.delayed(const Duration(seconds: 1), () {
      print("ababbababa");
      if (success) {
        print('✅ PEMBAYARAN BERHASIL');
        Get.off(() => PaymentSuccessPage());
      } else {
        print('❌ PEMBAYARAN GAGAL');
        Get.off(() => const PaymentFailedPage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pembayaran")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
