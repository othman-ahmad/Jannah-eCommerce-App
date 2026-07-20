import 'package:jannah/features/checkout/data/cart_item_model.dart';
import 'package:jannah/features/orders/data/order_model.dart';
import 'package:jannah/features/orders/domain/orders_repository.dart';

class PostOrder {
  final OrdersRepository repository;

  const PostOrder(this.repository);

  Future<Order> call({
    required Order order,
    required String paymentMethod,
    required List<CartItem> cartItems,
  }) {
    return repository.postOrder(
      order: order,
      paymentMethod: paymentMethod,
      cartItems: cartItems,
    );
  }
}
