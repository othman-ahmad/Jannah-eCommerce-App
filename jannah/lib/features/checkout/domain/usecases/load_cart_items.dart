import 'package:jannah/features/checkout/data/cart_item_model.dart';
import 'package:jannah/features/checkout/domain/checkout_repository.dart';

class LoadCartItems {
  final CheckoutRepository repository;

  const LoadCartItems(this.repository);

  Future<List<CartItem>> call(int cartId) {
    return repository.loadCartItems(cartId);
  }
}
