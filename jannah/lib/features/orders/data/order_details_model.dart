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
    return OrderDetails(
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
      items: (json['items'] as List<dynamic>)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      deliveryAddress: Address.fromJson(
        json['deliveryAddress'] as Map<String, dynamic>,
      ),
      paymentMethod: json['paymentMethod'],
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
}
