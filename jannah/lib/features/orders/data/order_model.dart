class Order {
  int orderId;
  int userId;
  int addressId;
  String orderNumber;
  DateTime date;
  double subtotal;
  double deliveryFee;
  double pakagingFee;
  double total;
  String status;

  Order({
    required this.orderId,
    required this.userId,
    required this.addressId,
    required this.orderNumber,
    required this.date,
    required this.subtotal,
    required this.deliveryFee,
    required this.pakagingFee,
    required this.total,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      userId: json['userId'],
      addressId: json['addressId'],
      orderNumber: json['orderNumber'],
      date: DateTime.parse(json['date']),
      subtotal: (json['subtotal'] as num).toDouble(),
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      pakagingFee: (json['pakagingFee'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'userId': userId,
      'addressId': addressId,
      'orderNumber': orderNumber,
      'date': date.toIso8601String(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'pakagingFee': pakagingFee,
      'total': total,
      'status': status,
    };
  }

  Order copyWith({
    int? orderId,
    int? userId,
    int? addressId,
    String? orderNumber,
    DateTime? date,
    double? subtotal,
    double? deliveryFee,
    double? pakagingFee,
    double? total,
    String? status,
  }) {
    return Order(
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      addressId: addressId ?? this.addressId,
      orderNumber: orderNumber ?? this.orderNumber,
      date: date ?? this.date,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      pakagingFee: pakagingFee ?? this.pakagingFee,
      total: total ?? this.total,
      status: status ?? this.status,
    );
  }
}
