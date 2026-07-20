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
    required Address deliveryAddress,
  });

  Future<OrderDetails> fetchOrderDetails({required int orderId});
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
  static final List<Payment> _payments = [
    Payment(
      orderId: 1,
      amount: 48.50,
      paymentMethod: 'Cash',
      transactionId: 'MOCK-ORD-1001',
      status: 'Success',
      paymentDate: DateTime(2026, 7, 14, 12, 30),
    ),
  ];

  static final List<OrderItem> _mockOrderItems = [
    OrderItem(
      orderItemId: 1,
      orderId: 1,
      productId: 1,
      quantity: 10,
      price: 2.89,
    ),
    OrderItem(
      orderItemId: 2,
      orderId: 1,
      productId: 6,
      quantity: 5,
      price: 3.52,
    ),
  ];

  static final Map<int, Address> _deliveryAddresses = {
    1: Address(
      addressId: 1,
      userId: 1,
      addressType: 'Home',
      addressLine: 'Al Madina Street, Building 12',
      city: 'Amman',
      state: 'Amman',
      country: 'Jordan',
      postalCode: '11118',
      latitude: 31.9539,
      longitude: 35.9106,
      isDefault: true,
    ),
  };

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
    required Address deliveryAddress,
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
    _deliveryAddresses[orderId] = Address.fromJson(deliveryAddress.toJson());
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

  @override
  Future<OrderDetails> fetchOrderDetails({required int orderId}) async {
    final order = _orders.firstWhere(
      (order) => order.orderId == orderId,
      orElse: () => throw Exception('Order not found'),
    );

    final payment = _payments.firstWhere(
      (payment) => payment.orderId == orderId,
      orElse: () => Payment(
        orderId: orderId,
        amount: order.total,
        paymentMethod: 'Unknown',
        transactionId: 'No_Transaction_ID',
        status: 'Unknown',
        paymentDate: order.date,
      ),
    );

    final orderItems = _mockOrderItems
        .where((item) => item.orderId == orderId)
        .map((item) => OrderItem.fromJson(item.toJson()))
        .toList(growable: false);
    final deliveryAddress =
        _deliveryAddresses[orderId] ?? _fallbackAddressForOrder(order);

    print('\n');
    print('==================== MOCK ORDER DETAILS ====================');
    print('Operation: FETCH ORDER DETAILS');
    print(
      'OrderId: ${order.orderId}, Items: ${orderItems.length}, PaymentMethod: ${payment.paymentMethod}, AddressId: ${deliveryAddress.addressId}',
    );
    print('============================================================\n');

    return OrderDetails.fromOrder(
      order: Order.fromJson(order.toJson()),
      items: orderItems,
      deliveryAddress: Address.fromJson(deliveryAddress.toJson()),
      paymentMethod: payment.paymentMethod,
    );
  }

  Address _fallbackAddressForOrder(Order order) {
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
