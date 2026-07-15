import 'package:jannah/features/checkout/domain/checkout_repository.dart';

class DeleteCart {
  final CheckoutRepository repository;

  const DeleteCart(this.repository);

  Future<void> call(int cartId) {
    return repository.deleteCart(cartId);
  }
}
