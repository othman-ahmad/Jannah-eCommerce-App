class Payment {
  int orderId;
  String paymentMethod;
  double amount;
  String transactionId;
  String status;
  DateTime paymentDate;

  Payment({
    required this.orderId,
    required this.paymentMethod,
    required this.amount,
    required this.transactionId,
    required this.status,
    required this.paymentDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'OrderId': orderId,
      'PaymentMethod': paymentMethod,
      'Amount': amount,
      'TransactionId': transactionId,
      'Status': status,
      'PaymentDate': paymentDate.toIso8601String(),
    };
  }
}
