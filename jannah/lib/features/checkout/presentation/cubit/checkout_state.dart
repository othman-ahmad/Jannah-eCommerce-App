import 'package:jannah/features/checkout/data/cart_item_model.dart';
import 'package:jannah/features/checkout/data/cart_model.dart';

enum CheckoutStatus { initial, loading, success, failure }

class CheckoutState {
  final CheckoutStatus status;
  final Cart? cart;
  final List<CartItem> cartItems;
  final Set<int> pendingProductIds;
  final bool isCheckingOut;
  final String? errorMessage;

  const CheckoutState({
    this.status = CheckoutStatus.initial,
    this.cart,
    this.cartItems = const [],
    this.pendingProductIds = const {},
    this.isCheckingOut = false,
    this.errorMessage,
  });

  double get total {
    return cartItems.fold(
      0.0,
      (previousValue, item) => previousValue + item.price * item.quantity,
    );
  }

  int quantityForProduct(int productId) {
    for (final item in cartItems) {
      if (item.productId == productId) {
        return item.quantity;
      }
    }

    return 0;
  }

  bool isPending(int productId) {
    return pendingProductIds.contains(productId);
  }

  CheckoutState copyWith({
    CheckoutStatus? status,
    Cart? cart,
    List<CartItem>? cartItems,
    Set<int>? pendingProductIds,
    bool? isCheckingOut,
    String? errorMessage,
    bool clearCart = false,
    bool clearErrorMessage = false,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      cart: clearCart ? null : cart ?? this.cart,
      cartItems: cartItems ?? this.cartItems,
      pendingProductIds: pendingProductIds ?? this.pendingProductIds,
      isCheckingOut: isCheckingOut ?? this.isCheckingOut,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}
