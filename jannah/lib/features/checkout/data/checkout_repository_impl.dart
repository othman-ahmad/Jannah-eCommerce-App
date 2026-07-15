import 'package:jannah/features/checkout/data/cart_item_model.dart';
import 'package:jannah/features/checkout/data/cart_model.dart';
import 'package:jannah/features/checkout/data/checkout_remote_data_source.dart';
import 'package:jannah/features/checkout/domain/checkout_repository.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutRemoteDataSource remoteDataSource;

  const CheckoutRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Cart> loadCart(int userId) async {
    final cart = await remoteDataSource.fetchActiveCart(userId: userId);
    return cart ?? remoteDataSource.createCart(userId: userId);
  }

  @override
  Future<Cart> createCart(int userId) {
    return remoteDataSource.createCart(userId: userId);
  }

  @override
  Future<void> deleteCart(int cartId) {
    return remoteDataSource.deleteCart(cartId: cartId);
  }

  @override
  Future<void> addItem({
    required int userId,
    required int productId,
    required int quantity,
    required double price,
  }) {
    return remoteDataSource.addItem(
      userId: userId,
      productId: productId,
      quantity: quantity,
      price: price,
    );
  }

  @override
  Future<void> removeItem({required int userId, required int productId}) {
    return remoteDataSource.removeItem(userId: userId, productId: productId);
  }

  @override
  Future<void> checkout(int cartId) {
    return remoteDataSource.checkout(cartId: cartId);
  }

  @override
  Future<List<CartItem>> loadCartItems(int cartId) {
    return remoteDataSource.fetchCartItems(cartId: cartId);
  }
}
