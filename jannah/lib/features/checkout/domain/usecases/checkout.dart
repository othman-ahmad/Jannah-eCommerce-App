import 'package:jannah/features/checkout/domain/checkout_repository.dart';

class Checkout {
  final CheckoutRepository repository;

  const Checkout(this.repository);

  Future<void> call(int cartId) {
    return repository.checkout(cartId);
  }
}
