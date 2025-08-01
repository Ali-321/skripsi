import 'package:flutter/material.dart';
import 'package:flutter_topup_voucher_game_online/models/report.dart';
import 'package:flutter_topup_voucher_game_online/providers/auth_provider.dart';
import 'package:flutter_topup_voucher_game_online/providers/report_provider.dart';
import 'package:provider/provider.dart';

class ReportProblemPage extends StatefulWidget {
  const ReportProblemPage({super.key});

  @override
  State<ReportProblemPage> createState() => _ReportProblemPageState();
}

class _ReportProblemPageState extends State<ReportProblemPage> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _reportController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _subjectController.dispose();
    _reportController.dispose();
    super.dispose();
  }

  void  _submitReport() {
    if (_formKey.currentState!.validate()) {
      final subject = _subjectController.text.trim().toString();
      final report = _reportController.text.trim().toString();

      context.read<ReportProvider>().createReport(
        context.read<AuthProvider>().user?.id,
        Report(subject: subject, description: report),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Laporan berhasil dikirim!')),
      );

      _subjectController.clear();
      _reportController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("Laporkan Masalah")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Subject',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(
                  hintText: 'Tulis subjek laporan...',
                  filled: true,
                  fillColor:
                      isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator:
                    (val) =>
                        val == null || val.isEmpty
                            ? 'Subject tidak boleh kosong'
                            : null,
              ),
              const SizedBox(height: 20),
              const Text(
                'Deskripsi Masalah',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _reportController,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: 'Tuliskan detail masalah Anda di sini...',
                  filled: true,
                  fillColor:
                      isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator:
                    (val) =>
                        val == null || val.isEmpty
                            ? 'Deskripsi tidak boleh kosong'
                            : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitReport,
                  child: const Text("Kirim Laporan"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
