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
  Future<Order> postOrder({required Order order}) {
    return remoteDataSource.postOrder(order: order);
  }
}
