import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jannah/features/checkout/domain/usecases/add_item.dart';
import 'package:jannah/features/checkout/domain/usecases/checkout.dart';
import 'package:jannah/features/checkout/domain/usecases/create_cart.dart';
import 'package:jannah/features/checkout/domain/usecases/delete_cart.dart';
import 'package:jannah/features/checkout/domain/usecases/load_cart.dart';
import 'package:jannah/features/checkout/domain/usecases/load_cart_items.dart';
import 'package:jannah/features/checkout/domain/usecases/remove_item.dart';
import 'package:jannah/features/checkout/presentation/cubit/checkout_state.dart';
import 'package:jannah/features/profile/data/address_model.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final LoadCart loadCartUseCase;
  final CreateCart createCartUseCase;
  final DeleteCart deleteCartUseCase;
  final AddItem addItemUseCase;
  final RemoveItem removeItemUseCase;
  final Checkout checkoutUseCase;
  final LoadCartItems loadCartItemsUseCase;

  int currentUserId;

  CheckoutCubit({
    required this.loadCartUseCase,
    required this.createCartUseCase,
    required this.deleteCartUseCase,
    required this.addItemUseCase,
    required this.removeItemUseCase,
    required this.checkoutUseCase,
    required this.loadCartItemsUseCase,
    required this.currentUserId,
  }) : super(const CheckoutState());

  Future<void> loadCart() async {
    emit(
      state.copyWith(status: CheckoutStatus.loading, clearErrorMessage: true),
    );

    try {
      final cart = await loadCartUseCase();
      if (cart == null) {
        emit(
          state.copyWith(
            status: CheckoutStatus.success,
            cart: null,
            cartItems: const [],
            clearErrorMessage: true,
          ),
        );
        return;
      }
      final cartItems = await loadCartItemsUseCase(cart.cartId);
      emit(
        state.copyWith(
          status: CheckoutStatus.success,
          cart: cart,
          cartItems: cartItems,
          clearErrorMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> createCart() async {
    emit(
      state.copyWith(status: CheckoutStatus.loading, clearErrorMessage: true),
    );

    try {
      final cart = await createCartUseCase();
      emit(
        state.copyWith(
          status: CheckoutStatus.success,
          cart: cart,
          cartItems: const [],
          clearErrorMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> deleteCurrentCart() async {
    final cart = state.cart;

    if (cart == null) {
      return;
    }

    emit(
      state.copyWith(status: CheckoutStatus.loading, clearErrorMessage: true),
    );

    try {
      await deleteCartUseCase(cart.cartId);
      emit(
        state.copyWith(
          status: CheckoutStatus.success,
          cartItems: const [],
          clearCart: true,
          clearErrorMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> addCartItem({
    required int productId,
    required int quantity,
    required double price,
  }) async {
    if (quantity <= 0 || state.isPending(productId)) {
      return;
    }

    _setProductPending(productId, isPending: true);

    try {
      await addItemUseCase(
        productId: productId,
        quantity: quantity,
        price: price,
      );

      await _refreshCart();
    } catch (e) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          pendingProductIds: _withoutPendingProduct(productId),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> removeCartItem({required int productId}) async {
    if (state.isPending(productId)) {
      return;
    }

    _setProductPending(productId, isPending: true);

    try {
      await removeItemUseCase(productId: productId);
      await _refreshCart();
    } catch (e) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          pendingProductIds: _withoutPendingProduct(productId),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> completeCheckout({
    required Address deliveryAddress,
    required double deliveryFee,
    required double pakagingFee,
    required String paymentMethod,
  }) async {
    final cart = state.cart;

    if (cart == null || state.cartItems.isEmpty || state.isCheckingOut) {
      return;
    }

    emit(state.copyWith(isCheckingOut: true, clearErrorMessage: true));

    try {
      await checkoutUseCase(
        cartId: cart.cartId,
        addressId: deliveryAddress.addressId,
        paymentMethod: paymentMethod,
      );
      emit(
        state.copyWith(
          status: CheckoutStatus.success,
          cart: cart.copyWith(isOrdered: true),
          cartItems: const [],
          isCheckingOut: false,
          clearErrorMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          isCheckingOut: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void selectDeliveryAddress(Address address) {
    emit(state.copyWith(selectedDeliveryAddress: address));
  }

  Future<void> _refreshCart() async {
    final cart = await loadCartUseCase();
    if (cart == null) {
      emit(
        state.copyWith(
          status: CheckoutStatus.success,
          cart: null,
          cartItems: const [],
          pendingProductIds: const {},
          clearErrorMessage: true,
        ),
      );
      return;
    }
    final cartItems = await loadCartItemsUseCase(cart.cartId);

    emit(
      state.copyWith(
        status: CheckoutStatus.success,
        cart: cart,
        cartItems: cartItems,
        pendingProductIds: const {},
        clearErrorMessage: true,
      ),
    );
  }

  void _setProductPending(int productId, {required bool isPending}) {
    final pendingProductIds = Set<int>.of(state.pendingProductIds);

    if (isPending) {
      pendingProductIds.add(productId);
    } else {
      pendingProductIds.remove(productId);
    }

    emit(state.copyWith(pendingProductIds: pendingProductIds));
  }

  Set<int> _withoutPendingProduct(int productId) {
    return Set<int>.of(state.pendingProductIds)..remove(productId);
  }
}
