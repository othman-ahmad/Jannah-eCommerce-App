import 'package:jannah/features/orders/data/order_model.dart';
import 'package:jannah/features/orders/domain/orders_repository.dart';

class GetOrders {
  final OrdersRepository repository;

  const GetOrders(this.repository);

  Future<List<Order>> call() {
    return repository.fetchOrders();
  }
}
