import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jannah/features/orders/data/order_model.dart';
import 'package:jannah/features/orders/domain/usecases/get_orders.dart';
import 'package:jannah/features/orders/domain/usecases/post_order.dart';
import 'package:jannah/features/orders/presentation/cubit/orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final GetOrders getOrders;
  final PostOrder postOrder;

  int currentUserId;

  OrdersCubit({
    required this.getOrders,
    required this.postOrder,
    required this.currentUserId,
  }) : super(const OrdersState());

  Future<void> loadOrders({int? userId}) async {
    final effectiveUserId = userId ?? currentUserId;
    currentUserId = effectiveUserId;

    emit(state.copyWith(status: OrdersStatus.loading, clearErrorMessage: true));

    try {
      final orders = await getOrders(userId: effectiveUserId);
      emit(
        state.copyWith(
          status: OrdersStatus.success,
          orders: _sortOrders(orders),
          clearErrorMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OrdersStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<Order?> postUserOrder({
    required Order order,
    required String paymentMethod,
  }) async {
    emit(state.copyWith(isPosting: true, clearErrorMessage: true));

    try {
      final postedOrder = await postOrder(
        order: order,
        paymentMethod: paymentMethod,
      );
      final orders = await getOrders(userId: postedOrder.userId);
      currentUserId = postedOrder.userId;
      emit(
        state.copyWith(
          status: OrdersStatus.success,
          orders: _sortOrders(orders),
          isPosting: false,
          clearErrorMessage: true,
        ),
      );
      return postedOrder;
    } catch (e) {
      emit(
        state.copyWith(
          status: OrdersStatus.failure,
          isPosting: false,
          errorMessage: e.toString(),
        ),
      );
      return null;
    }
  }

  List<Order> _sortOrders(List<Order> orders) {
    final sortedOrders = List<Order>.of(orders);
    sortedOrders.sort((a, b) => b.date.compareTo(a.date));
    return sortedOrders;
  }
}
