class OrderItem {
  int orderItemId;
  int orderId;
  int productId;
  int quantity;
  double price;

  OrderItem({
    required this.orderItemId,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      orderItemId: _readInt(json, const [
        'orderItemId',
        'OrderItemId',
        'order_item_id',
        'id',
      ]),
      orderId: _readInt(json, const ['orderId', 'OrderId', 'order_id']),
      productId: _readInt(json, const ['productId', 'ProductId', 'product_id']),
      quantity: _readInt(json, const ['quantity', 'Quantity']),
      price: _readDouble(json, const ['price', 'Price']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderItemId': orderItemId,
      'orderId': orderId,
      'productId': productId,
      'quantity': quantity,
      'price': price,
    };
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
