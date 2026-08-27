import 'package:jannah/features/checkout/data/cart_model.dart';
import 'package:jannah/features/checkout/domain/checkout_repository.dart';

class CreateCart {
  final CheckoutRepository repository;

  const CreateCart(this.repository);

  Future<Cart> call() {
    return repository.createCart();
  }
}
