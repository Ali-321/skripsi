class Payment {
  final String paymentId;
  final String orderId;
  final int amount;
  final String paymentStatus;

  Payment({
    required this.paymentId,
    required this.orderId,
    required this.amount,
    required this.paymentStatus,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      paymentId: json['id'].toString(),
      orderId: json['order_id'].toString(),
      amount: json['amount'] as int,
      paymentStatus: json['payment_status'],
    );
  }
}







/*

    "order_id": "INV-1746161998967",
    "amount": 27247,
    "payment_status": "Success"

    */