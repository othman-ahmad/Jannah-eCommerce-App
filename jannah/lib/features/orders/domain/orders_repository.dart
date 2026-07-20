import 'package:jannah/features/checkout/data/cart_item_model.dart';
import 'package:jannah/features/orders/data/order_model.dart';

abstract class OrdersRepository {
  Future<List<Order>> fetchOrders({required int userId});

  Future<Order> postOrder({
    required Order order,
    required String paymentMethod,
    required List<CartItem> cartItems,
  });
}
