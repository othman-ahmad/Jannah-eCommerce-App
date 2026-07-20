import 'package:jannah/features/checkout/data/cart_item_model.dart';
import 'package:jannah/features/orders/data/order_details_model.dart';
import 'package:jannah/features/orders/data/order_model.dart';
import 'package:jannah/features/profile/data/address_model.dart';

abstract class OrdersRepository {
  Future<List<Order>> fetchOrders({required int userId});

  Future<OrderDetails> fetchOrderDetails({required int orderId});

  Future<Order> postOrder({
    required Order order,
    required String paymentMethod,
    required List<CartItem> cartItems,
    required Address deliveryAddress,
  });
}
