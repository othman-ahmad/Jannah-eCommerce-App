import 'package:jannah/features/checkout/data/cart_item_model.dart';
import 'package:jannah/features/orders/data/order_details_model.dart';
import 'package:jannah/features/orders/data/order_model.dart';
import 'package:jannah/features/orders/data/orders_remote_data_source.dart';
import 'package:jannah/features/orders/domain/orders_repository.dart';
import 'package:jannah/features/profile/data/address_model.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;

  const OrdersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Order>> fetchOrders() {
    return remoteDataSource.fetchOrders();
  }

  @override
  Future<OrderDetails> fetchOrderDetails({required int orderId}) {
    return remoteDataSource.fetchOrderDetails(orderId: orderId);
  }

  @override
  Future<Order> postOrder({
    required Order order,
    required String paymentMethod,
    required List<CartItem> cartItems,
    required Address deliveryAddress,
  }) {
    return remoteDataSource.postOrder(
      order: order,
      paymentMethod: paymentMethod,
      cartItems: cartItems,
      deliveryAddress: deliveryAddress,
    );
  }
}
