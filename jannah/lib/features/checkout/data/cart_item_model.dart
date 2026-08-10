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
      cartItemId: _readInt(json, const [
        'cartItemId',
        'CartItemId',
        'cart_item_id',
        'id',
      ]),
      cartId: _readInt(json, const ['cartId', 'CartId', 'cart_id']),
      productId: _readInt(json, const ['productId', 'ProductId', 'product_id']),
      quantity: _readInt(json, const ['quantity', 'Quantity']),
      price: _readDouble(json, const ['price', 'Price']),
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

  static Object? _readValue(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      if (json.containsKey(key)) {
        return json[key];
      }
    }
    return null;
  }
}
