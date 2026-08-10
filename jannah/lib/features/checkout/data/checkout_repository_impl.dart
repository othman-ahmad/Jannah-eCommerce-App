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
  Future<Cart?> loadCart(int userId) async {
    if (isGuest) {
      return localDataSource.fetchActiveCart(userId: userId);
    }

    await _syncGuestCartToUser(userId);
    return remoteDataSource.fetchActiveCart(userId: userId);
  }

  @override
  Future<Cart> createCart(int userId) {
    if (isGuest) {
      return localDataSource.createCart(userId: userId);
    }

    return remoteDataSource.createCart(userId: userId);
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
    required int userId,
    required int productId,
    required int quantity,
    required double price,
  }) {
    if (isGuest) {
      return localDataSource.addItem(
        userId: userId,
        productId: productId,
        quantity: quantity,
        price: price,
      );
    }

    return remoteDataSource.addItem(
      userId: userId,
      productId: productId,
      quantity: quantity,
      price: price,
    );
  }

  @override
  Future<void> removeItem({required int userId, required int productId}) {
    if (isGuest) {
      return localDataSource.removeItem(userId: userId, productId: productId);
    }

    return remoteDataSource.removeItem(userId: userId, productId: productId);
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

  Future<void> _syncGuestCartToUser(int userId) async {
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
        userId: userId,
        productId: item.productId,
        quantity: item.quantity,
        price: item.price,
      );
    }

    await localDataSource.clear();
  }
}
