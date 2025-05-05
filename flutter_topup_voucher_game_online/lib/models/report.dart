class Report {
  final String? subject;
  final String? description;
  Report({required this.subject, required this.description});

  Map<String, dynamic> toJson(int userId) {
    return {
      "data": {
        "user": userId,
        "subject": subject,
        "description": description,
        "report_date": DateTime.now().toIso8601String(),
        "report_status": "Pending",
      },
    };
  }
}
