import 'package:jannah/features/checkout/data/cart_item_model.dart';
import 'package:jannah/features/checkout/data/cart_model.dart';
import 'package:jannah/features/checkout/data/checkout_remote_data_source.dart';
import 'package:jannah/features/checkout/data/guest_cart_local_data_source.dart';
import 'package:jannah/features/checkout/domain/checkout_repository.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutRemoteDataSource remoteDataSource;
  final GuestCartLocalDataSource localDataSource;
  final bool isGuest;
  bool _hasSyncedGuestCart = false;

  CheckoutRepositoryImpl({
    required this.remoteDataSource,
    GuestCartLocalDataSource? localDataSource,
    this.isGuest = false,
  }) : localDataSource = localDataSource ?? GuestCartLocalDataSource();

  @override
  Future<Cart?> loadCart() async {
    if (isGuest) {
      return localDataSource.fetchActiveCart();
    }

    await _syncGuestCartToUser();
    return remoteDataSource.fetchActiveCart();
  }

  @override
  Future<Cart> createCart() {
    if (isGuest) {
      return localDataSource.createCart();
    }

    return remoteDataSource.createCart();
  }

  @override
  Future<void> deleteCart(int cartId) {
    if (isGuest) {
      return localDataSource.deleteCart(cartId: cartId);
    }

    return remoteDataSource.deleteCart(cartId: cartId);
  }

  @override
  Future<void> addItem({
    required int productId,
    required int quantity,
    required double price,
  }) {
    if (isGuest) {
      return localDataSource.addItem(
        productId: productId,
        quantity: quantity,
        price: price,
      );
    }

    return remoteDataSource.addItem(
      productId: productId,
      quantity: quantity,
      price: price,
    );
  }

  @override
  Future<void> removeItem({required int productId}) {
    if (isGuest) {
      return localDataSource.removeItem(productId: productId);
    }

    return remoteDataSource.removeItem(productId: productId);
  }

  @override
  Future<void> checkout({
    required int cartId,
    required int addressId,
    required String paymentMethod,
  }) {
    if (isGuest) {
      return localDataSource.checkout(
        cartId: cartId,
        addressId: addressId,
        paymentMethod: paymentMethod,
      );
    }

    return remoteDataSource.checkout(
      cartId: cartId,
      addressId: addressId,
      paymentMethod: paymentMethod,
    );
  }

  @override
  Future<List<CartItem>> loadCartItems(int cartId) {
    if (isGuest) {
      return localDataSource.fetchCartItems(cartId: cartId);
    }

    return remoteDataSource.fetchCartItems(cartId: cartId);
  }

  Future<void> _syncGuestCartToUser() async {
    if (_hasSyncedGuestCart) {
      return;
    }

    _hasSyncedGuestCart = true;
    final guestItems = await localDataSource.readItemsForSync();

    if (guestItems.isEmpty) {
      return;
    }

    for (final item in guestItems) {
      await remoteDataSource.addItem(
        productId: item.productId,
        quantity: item.quantity,
        price: item.price,
      );
    }

    await localDataSource.clear();
  }
}
