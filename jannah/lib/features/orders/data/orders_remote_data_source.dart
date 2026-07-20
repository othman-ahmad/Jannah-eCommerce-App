// ignore_for_file: avoid_print

import 'package:jannah/features/checkout/data/cart_item_model.dart';
import 'package:jannah/features/checkout/data/checkout_remote_data_source.dart';
import 'package:jannah/features/orders/data/order_details_model.dart';
import 'package:jannah/features/orders/data/order_item_model.dart';
import 'package:jannah/features/orders/data/order_model.dart';
import 'package:jannah/features/orders/data/payment_model.dart';
import 'package:jannah/features/profile/data/address_model.dart';

abstract class OrdersRemoteDataSource {
  Future<List<Order>> fetchOrders({required int userId});

  Future<Order> postOrder({
    required Order order,
    required String paymentMethod,
    required List<CartItem> cartItems,
  });

  // Future<OrderDetails> fetchOrderDetails({required int orderId});
}

class InMemoryOrdersRemoteDataSource implements OrdersRemoteDataSource {
  static final List<Order> _orders = [
    Order(
      orderId: 1,
      userId: 1,
      addressId: 1,
      orderNumber: 'ORD-1001',
      date: DateTime(2026, 7, 14, 12, 30),
      subtotal: 46.50,
      deliveryFee: 0,
      pakagingFee: 2,
      total: 48.50,
      status: 'Delivered',
    ),
  ];
  static final List<Payment> _payments = [];

  static List<OrderItem> _mockOrderItems = [];

  static int _nextOrderId = 2;

  @override
  Future<List<Order>> fetchOrders({required int userId}) async {
    final orders = _orders
        .where((order) => order.userId == userId)
        .map((order) => Order.fromJson(order.toJson()))
        .toList(growable: false);

    print('\n');
    print('==================== MOCK ORDERS DATABASE ====================');
    print('Operation: FETCH ORDERS');
    print('UserId: $userId');
    for (final order in orders) {
      print(
        'OrderId: ${order.orderId}, OrderNumber: ${order.orderNumber}, Date: ${order.date}, Total: ${order.total.toStringAsFixed(2)}, Status: ${order.status}',
      );
    }
    print('Returned rows: ${orders.length}');
    print('==============================================================\n');

    return orders;
  }

  @override
  Future<Order> postOrder({
    required Order order,
    required String paymentMethod,
    required List<CartItem> cartItems,
  }) async {
    final orderId = order.orderId == 0 ? _nextOrderId++ : order.orderId;
    final orderNumber = order.orderNumber.isEmpty
        ? 'ORD-${(1000 + orderId).toString()}'
        : order.orderNumber;
    final orderToSave = order.copyWith(
      orderId: orderId,
      orderNumber: orderNumber,
    );

    _orders.add(Order.fromJson(orderToSave.toJson()));
    for (final cartItem in cartItems) {
      _mockOrderItems.add(
        OrderItem(
          orderItemId: cartItem.cartItemId,
          orderId: orderId,
          productId: cartItem.productId,
          quantity: cartItem.quantity,
          price: cartItem.price,
        ),
      );
    }

    _payments.add(
      Payment(
        orderId: orderId,
        amount: orderToSave.total,
        paymentMethod: paymentMethod,
        transactionId: 'No_Transaction_ID',
        status: 'Success',
        paymentDate: DateTime.now(),
      ),
    );

    _printDatabaseState('POST ORDER');
    return Order.fromJson(orderToSave.toJson());
  }

  // Future<OrderDetails> fetchOrderDetails({required int orderId}) async {
  //   final Order order = _orders.firstWhere(
  //     (order) => order.orderId == orderId,
  //     orElse: () => throw Exception('Order not found'),
  //   );

  //   final payment = _payments.firstWhere(
  //     (payment) => payment.orderId == orderId,
  //     orElse: () => throw Exception('Payment not found for order'),
  //   );

  //   final List<OrderItem> orderItems = _mockOrderItems
  //       .where((item) => item.orderId == orderId)
  //       .toList(growable: false);

  //   final Address
  //   deliveryAddress; // TODO : Fetch the delivery address based on order.addressId

  //   final orderDetails = OrderDetails(
  //     orderId: order.orderId,
  //     userId: order.userId,
  //     addressId: order.addressId,
  //     orderNumber: order.orderNumber,
  //     date: order.date,
  //     subtotal: order.subtotal,
  //     deliveryFee: order.deliveryFee,
  //     pakagingFee: order.pakagingFee,
  //     total: order.total,
  //     status: order.status,
  //     items: orderItems,
  //     deliveryAddress: deliveryAddress,
  //     paymentMethod: payment.paymentMethod,
  //   );
  //   return orderDetails;
  // }

  void _printDatabaseState(String operation) {
    print('\n');
    print('==================== MOCK ORDERS DATABASE ====================');
    print('Operation: $operation');
    print('');
    print('ORDERS TABLE');

    if (_orders.isEmpty) {
      print('(empty)');
    } else {
      print(
        '-------------------------------------------------------------------------------------------------------',
      );
      print(
        '| OrderId | UserId | AddressId | Number   | Date                     | Total      | Status      |',
      );
      print(
        '-------------------------------------------------------------------------------------------------------',
      );

      for (final order in _orders) {
        print(
          '| ${order.orderId.toString().padRight(7)} '
          '| ${order.userId.toString().padRight(6)} '
          '| ${order.addressId.toString().padRight(9)} '
          '| ${order.orderNumber.padRight(8)} '
          '| ${order.date.toString().padRight(24)} '
          '| ${order.total.toStringAsFixed(2).padRight(10)} '
          '| ${order.status.padRight(11)} |',
        );
      }

      print(
        '-------------------------------------------------------------------------------------------------------',
      );
    }
    // Print payments table
    print('');
    print('PAYMENTS TABLE');
    for (final payment in _payments) {
      print(
        'OrderId: ${payment.orderId}, PaymentMethod: ${payment.paymentMethod}, Amount: ${payment.amount.toStringAsFixed(2)}, TransactionId: ${payment.transactionId}, Status: ${payment.status}, PaymentDate: ${payment.paymentDate}',
      );
    }
    print(
      '-------------------------------------------------------------------------------------------------------',
    );

    print('==================== Order Items Table ====================');
    print('| Order Item Id |  Order Id | Product Id | Quantity | Price      |');
    print('-------------------------------------------------------------');
    for (final orderItem in _mockOrderItems) {
      print(
        '| ${orderItem.orderItemId.toString().padRight(14)} | ${orderItem.orderId.toString().padRight(9)} | ${orderItem.productId.toString().padRight(10)} | ${orderItem.quantity.toString().padRight(8)} | \$${orderItem.price.toStringAsFixed(2).padRight(9)} |',
      );
    }
    print('-------------------------------------------------------------');

    print('==============================================================\n');
  }
}
