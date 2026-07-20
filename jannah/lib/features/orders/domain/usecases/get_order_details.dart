import 'package:jannah/features/orders/data/order_details_model.dart';
import 'package:jannah/features/orders/domain/orders_repository.dart';

class GetOrderDetails {
  final OrdersRepository repository;

  const GetOrderDetails(this.repository);

  Future<OrderDetails> call({required int orderId}) {
    return repository.fetchOrderDetails(orderId: orderId);
  }
}
