class CartItem {
  final int cartItemId;
  final int cartId;
  final int productId;
  final int quantity;
  final double price;

  const CartItem({
    required this.cartItemId,
    required this.cartId,
    required this.productId,
    required this.quantity,
    required this.price,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartItemId: json['CartItemId'],
      cartId: json['CartId'],
      productId: json['ProductId'],
      quantity: json['Quantity'],
      price: (json['Price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CartItemId': cartItemId,
      'CartId': cartId,
      'ProductId': productId,
      'Quantity': quantity,
      'Price': price,
    };
  }

  CartItem copyWith({
    int? cartItemId,
    int? cartId,
    int? productId,
    int? quantity,
    double? price,
  }) {
    return CartItem(
      cartItemId: cartItemId ?? this.cartItemId,
      cartId: cartId ?? this.cartId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }
}
