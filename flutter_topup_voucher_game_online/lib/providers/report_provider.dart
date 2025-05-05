import 'package:flutter/material.dart';
import 'package:flutter_topup_voucher_game_online/models/local_data.dart';
import 'package:flutter_topup_voucher_game_online/models/report.dart';
import 'package:flutter_topup_voucher_game_online/services/api_service.dart';

class ReportProvider extends ChangeNotifier {
  final Report _report = Report(subject: "", description: "");
  final ApiService _apiService = ApiService();
  final LocalData _localData = LocalData();
  String? errorMessage;
  bool isLoading = false;
  Report get report => _report;

  Future<void> createReport(int? userId, Report report) async {
    try {
      final token = await _localData.getToken();
      await _apiService.createReport(
        report: report,
        token: token ?? "",
        userId: userId?? 0,
      );
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
