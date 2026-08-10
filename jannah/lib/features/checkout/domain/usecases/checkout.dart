import 'package:jannah/features/checkout/domain/checkout_repository.dart';

class Checkout {
  final CheckoutRepository repository;

  const Checkout(this.repository);

  Future<void> call({
    required int cartId,
    required int addressId,
    required String paymentMethod,
  }) {
    return repository.checkout(
      cartId: cartId,
      addressId: addressId,
      paymentMethod: paymentMethod,
    );
  }
}
