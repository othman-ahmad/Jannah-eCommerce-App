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
      cartId: json['CartId'],
      userId: json['UserId'],
      createdDate: DateTime.parse(json['CreatedDate']),
      isOrdered: json['IsOrdered'],
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
}
