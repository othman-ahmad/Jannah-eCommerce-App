import 'package:jannah/features/checkout/data/cart_item_model.dart';
import 'package:jannah/features/checkout/data/cart_model.dart';

abstract class CheckoutRepository {
  Future<Cart?> loadCart();

  Future<Cart> createCart();

  Future<void> deleteCart(int cartId);

  Future<void> addItem({
    required int productId,
    required int quantity,
    required double price,
  });

  Future<void> removeItem({required int productId});

  Future<void> checkout({
    required int cartId,
    required int addressId,
    required String paymentMethod,
  });

  Future<List<CartItem>> loadCartItems(int cartId);
}
