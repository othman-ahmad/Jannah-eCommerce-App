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
    final orderId = _readInt(json, const [
      'orderId',
      'OrderId',
      'order_id',
      'id',
    ]);
    return Order(
      orderId: orderId,
      userId: _readInt(json, const ['userId', 'UserId', 'user_id']),
      addressId: _readInt(json, const ['addressId', 'AddressId', 'address_id']),
      orderNumber:
          _readString(json, const [
            'orderNumber',
            'OrderNumber',
            'order_number',
          ]) ??
          (orderId == 0 ? '' : 'ORD-$orderId'),
      date: _readDateTime(json, const [
        'date',
        'Date',
        'orderDate',
        'OrderDate',
        'createdDate',
        'CreatedDate',
      ]),
      subtotal: _readDouble(json, const ['subtotal', 'Subtotal']),
      deliveryFee: _readDouble(json, const [
        'deliveryFee',
        'DeliveryFee',
        'delivery_fee',
      ]),
      pakagingFee: _readDouble(json, const [
        'pakagingFee',
        'PakagingFee',
        'packagingFee',
        'PackagingFee',
        'serviceFee',
        'ServiceFee',
      ]),
      total: _readDouble(json, const ['total', 'Total']),
      status:
          _readString(json, const ['status', 'Status', 'orderStatus']) ??
          'Pending',
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

  static int _readInt(Map<String, dynamic> json, List<String> keys) {
    final value = _readValue(json, keys);
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  static double _readDouble(Map<String, dynamic> json, List<String> keys) {
    final value = _readValue(json, keys);
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value) ?? 0;
    }
    return 0;
  }

  static DateTime _readDateTime(Map<String, dynamic> json, List<String> keys) {
    final value = _readValue(json, keys);
    if (value is DateTime) {
      return value;
    }
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }

  static String? _readString(Map<String, dynamic> json, List<String> keys) {
    final value = _readValue(json, keys);
    final stringValue = value?.toString();
    if (stringValue == null || stringValue.isEmpty) {
      return null;
    }
    return stringValue;
  }

  static Object? _readValue(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      if (json.containsKey(key)) {
        return json[key];
      }
    }
    return null;
  }
}
