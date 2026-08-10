import 'package:jannah/features/orders/data/order_item_model.dart';
import 'package:jannah/features/orders/data/order_model.dart';
import 'package:jannah/features/profile/data/address_model.dart';

class OrderDetails {
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
  List<OrderItem> items;
  Address deliveryAddress;
  String paymentMethod;

  OrderDetails({
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
    required this.items,
    required this.deliveryAddress,
    required this.paymentMethod,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    final order = Order.fromJson(json);
    final itemsJson = _readList(json, const [
      'items',
      'Items',
      'orderItems',
      'OrderItems',
    ]);
    final addressJson = _readMap(json, const [
      'deliveryAddress',
      'DeliveryAddress',
      'address',
      'Address',
    ]);

    return OrderDetails(
      orderId: order.orderId,
      userId: order.userId,
      addressId: order.addressId,
      orderNumber: order.orderNumber,
      date: order.date,
      subtotal: order.subtotal,
      deliveryFee: order.deliveryFee,
      pakagingFee: order.pakagingFee,
      total: order.total,
      status: order.status,
      items: itemsJson.map(OrderItem.fromJson).toList(),
      deliveryAddress: addressJson == null
          ? _fallbackAddressFor(order)
          : Address.fromJson(addressJson),
      paymentMethod:
          _readString(json, const ['paymentMethod', 'PaymentMethod']) ??
          _readString(
            _readMap(json, const ['payment', 'Payment']) ?? const {},
            const ['paymentMethod', 'PaymentMethod', 'method', 'Method'],
          ) ??
          'Unknown',
    );
  }

  factory OrderDetails.fromOrder({
    required Order order,
    required List<OrderItem> items,
    required Address deliveryAddress,
    required String paymentMethod,
  }) {
    return OrderDetails(
      orderId: order.orderId,
      userId: order.userId,
      addressId: order.addressId,
      orderNumber: order.orderNumber,
      date: order.date,
      subtotal: order.subtotal,
      deliveryFee: order.deliveryFee,
      pakagingFee: order.pakagingFee,
      total: order.total,
      status: order.status,
      items: items,
      deliveryAddress: deliveryAddress,
      paymentMethod: paymentMethod,
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
      'items': items.map((item) => item.toJson()).toList(),
      'deliveryAddress': deliveryAddress.toJson(),
      'paymentMethod': paymentMethod,
    };
  }

  Order toOrder() {
    return Order(
      orderId: orderId,
      userId: userId,
      addressId: addressId,
      orderNumber: orderNumber,
      date: date,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      pakagingFee: pakagingFee,
      total: total,
      status: status,
    );
  }

  OrderDetails copyWith({
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
    List<OrderItem>? items,
    Address? deliveryAddress,
    String? paymentMethod,
  }) {
    return OrderDetails(
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
      items: items ?? this.items,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  static Address _fallbackAddressFor(Order order) {
    return Address(
      addressId: order.addressId,
      userId: order.userId,
      addressType: 'Delivery',
      addressLine: 'Address #${order.addressId}',
      city: '',
      state: '',
      country: '',
      postalCode: '',
      latitude: 0,
      longitude: 0,
      isDefault: false,
    );
  }

  static Map<String, dynamic>? _readMap(
    Map<String, dynamic> json,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = json[key];
      if (value is Map) {
        return Map<String, dynamic>.from(value);
      }
    }
    return null;
  }

  static List<Map<String, dynamic>> _readList(
    Map<String, dynamic> json,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = json[key];
      if (value is List) {
        return value
            .whereType<Map>()
            .map((itemJson) => Map<String, dynamic>.from(itemJson))
            .toList(growable: false);
      }
    }
    return const [];
  }

  static String? _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      final stringValue = value?.toString();
      if (stringValue != null && stringValue.isNotEmpty) {
        return stringValue;
      }
    }
    return null;
  }
}
