// ignore_for_file: avoid_print

import 'package:jannah/features/orders/data/order_model.dart';
import 'package:jannah/features/orders/data/payment_model.dart';

abstract class OrdersRemoteDataSource {
  Future<List<Order>> fetchOrders({required int userId});

  Future<Order> postOrder({
    required Order order,
    required String paymentMethod,
  });
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
    print('Returned rows: ${orders.length}');
    print('==============================================================\n');

    return orders;
  }

  @override
  Future<Order> postOrder({
    required Order order,
    required String paymentMethod,
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
    print('==============================================================\n');
  }
}
