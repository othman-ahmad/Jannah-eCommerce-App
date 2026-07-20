import 'package:jannah/features/checkout/data/cart_item_model.dart';
import 'package:jannah/features/orders/data/order_model.dart';
import 'package:jannah/features/orders/data/orders_remote_data_source.dart';
import 'package:jannah/features/orders/domain/orders_repository.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;

  const OrdersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Order>> fetchOrders({required int userId}) {
    return remoteDataSource.fetchOrders(userId: userId);
  }

  @override
  Future<Order> postOrder({
    required Order order,
    required String paymentMethod,
    required List<CartItem> cartItems,
  }) {
    return remoteDataSource.postOrder(
      order: order,
      paymentMethod: paymentMethod,
      cartItems: cartItems,
    );
  }
}
