import 'package:jannah/features/orders/data/order_details_model.dart';
import 'package:jannah/features/orders/data/order_model.dart';

enum OrdersStatus { initial, loading, success, failure }

class OrdersState {
  final OrdersStatus status;
  final OrdersStatus detailsStatus;
  final List<Order> orders;
  final OrderDetails? orderDetails;
  final bool isPosting;
  final String? errorMessage;
  final String? detailsErrorMessage;

  const OrdersState({
    this.status = OrdersStatus.initial,
    this.detailsStatus = OrdersStatus.initial,
    this.orders = const [],
    this.orderDetails,
    this.isPosting = false,
    this.errorMessage,
    this.detailsErrorMessage,
  });

  OrdersState copyWith({
    OrdersStatus? status,
    OrdersStatus? detailsStatus,
    List<Order>? orders,
    OrderDetails? orderDetails,
    bool? isPosting,
    String? errorMessage,
    String? detailsErrorMessage,
    bool clearErrorMessage = false,
    bool clearDetailsErrorMessage = false,
    bool clearOrderDetails = false,
  }) {
    return OrdersState(
      status: status ?? this.status,
      detailsStatus: detailsStatus ?? this.detailsStatus,
      orders: orders ?? this.orders,
      orderDetails: clearOrderDetails
          ? null
          : orderDetails ?? this.orderDetails,
      isPosting: isPosting ?? this.isPosting,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      detailsErrorMessage: clearDetailsErrorMessage
          ? null
          : detailsErrorMessage ?? this.detailsErrorMessage,
    );
  }
}
