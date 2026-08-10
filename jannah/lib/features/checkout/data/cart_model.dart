class Cart {
  final int cartId;
  final int userId;
  final DateTime createdDate;
  final bool isOrdered;

  const Cart({
    required this.cartId,
    required this.userId,
    required this.createdDate,
    required this.isOrdered,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      cartId: _readInt(json, const ['cartId', 'CartId', 'cart_id', 'id']),
      userId: _readInt(json, const ['userId', 'UserId', 'user_id']),
      createdDate: _readDateTime(json, const [
        'createdDate',
        'CreatedDate',
        'created_date',
      ]),
      isOrdered: _readBool(json, const [
        'isOrdered',
        'IsOrdered',
        'is_ordered',
      ]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CartId': cartId,
      'UserId': userId,
      'CreatedDate': createdDate.toIso8601String(),
      'IsOrdered': isOrdered,
    };
  }

  Cart copyWith({
    int? cartId,
    int? userId,
    DateTime? createdDate,
    bool? isOrdered,
  }) {
    return Cart(
      cartId: cartId ?? this.cartId,
      userId: userId ?? this.userId,
      createdDate: createdDate ?? this.createdDate,
      isOrdered: isOrdered ?? this.isOrdered,
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

  static bool _readBool(Map<String, dynamic> json, List<String> keys) {
    final value = _readValue(json, keys);
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return false;
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

  static Object? _readValue(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      if (json.containsKey(key)) {
        return json[key];
      }
    }
    return null;
  }
}
