import 'package:flutter/material.dart';
import 'package:flutter_topup_voucher_game_online/providers/transaction_provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import '../models/transaction.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  List<String> months = [];
  int selectedMonthIndex = 0;
  var formatter = NumberFormat('###,000');
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) => prepareMonthFilter());
    });
  }

  void prepareMonthFilter() {
    final dataTransaction =
        context
            .read<TransactionProvider>()
            .getListTransaction()
            .whereType<Transaction>()
            .toList();

    final seen = <String>{};
    final uniqueMonthsWithDate =
        dataTransaction
            .where((e) => e.transactionDate != null)
            .map((e) {
              final date = e.transactionDate!;
              return {
                'monthName': DateFormat('MMMM', 'id_ID').format(date),
                'monthNumber': date.month,
              };
            })
            .where((monthMap) => seen.add(monthMap['monthName'].toString()))
            .toList();

    uniqueMonthsWithDate.sort(
      (a, b) => (a['monthNumber'] as int).compareTo(b['monthNumber'] as int),
    );

    final uniqueMonths =
        uniqueMonthsWithDate.map((e) => e['monthName'] as String).toList();

    setState(() {
      months = uniqueMonths;
      selectedMonthIndex = months.isNotEmpty ? months.length - 1 : 0;
      isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dataTransaction =
        context
            .watch<TransactionProvider>()
            .getListTransaction()
            .whereType<Transaction>()
            .toList();

    if (!isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (months.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Belum ada data transaksi.",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final selectedMonth = months[selectedMonthIndex];
    final filteredData =
        dataTransaction.where((data) {
          if (data.transactionDate == null) return false;
          final trxMonth =
              DateFormat(
                'MMMM',
                'id_ID',
              ).format(data.transactionDate!).toLowerCase();
          return trxMonth == selectedMonth.toLowerCase();
        }).toList();

    filteredData.sort(
      (a, b) => b.transactionDate!.compareTo(a.transactionDate!),
    );

    final groupedByOrderId = <String, List<Transaction>>{};
    for (var trx in filteredData) {
      final orderId = trx.payment?.orderId ?? '-';
      groupedByOrderId.putIfAbsent(orderId, () => []).add(trx);
    }

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Riwayat Transaksi"),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: months.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => setState(() => selectedMonthIndex = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color:
                          index == selectedMonthIndex
                              ? Colors.deepPurple
                              : Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        months[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          if (groupedByOrderId.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  "Belum ada transaksi di bulan ini.",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          else
            Expanded(
              child: ListView(
                children:
                    groupedByOrderId.entries.map((entry) {
                      final trxList = entry.value;
                      final dateStr = DateFormat(
                        'dd MMM yyyy',
                        'id_ID',
                      ).format(trxList.first.transactionDate!);
                      final statusColor =
                          trxList.first.payment?.paymentStatus == 'Success'
                              ? Colors.green
                              : Colors.red;

                      final total = trxList.fold<int>(0, (sum, trx) {
                        return sum +
                            trx.cartItems.fold<int>(
                              0,
                              (s, item) => s + item.price * item.quantity,
                            );
                      });

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    dateStr,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color:
                                          isDark
                                              ? Colors.white70
                                              : Colors.black,
                                    ),
                                  ),
                                  Chip(
                                    label: Text(
                                      trxList.first.payment?.paymentStatus ??
                                          '-',
                                    ),
                                    backgroundColor: statusColor.withOpacity(
                                      0.1,
                                    ),
                                    labelStyle: TextStyle(color: statusColor),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Order ID: ${entry.key}",
                                style: TextStyle(
                                  fontSize: 13,
                                  color:
                                      isDark ? Colors.white54 : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...trxList.expand(
                                (trx) => trx.cartItems.map(
                                  (item) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 3,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item.productName,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                isDark
                                                    ? Colors.white70
                                                    : Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          "Rp ${formatter.format(item.price)}",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color:
                                          isDark ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "Rp ${formatter.format(total)}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color:
                                          isDark ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
