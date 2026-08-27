import 'package:jannah/features/checkout/data/cart_model.dart';
import 'package:jannah/features/checkout/domain/checkout_repository.dart';

class LoadCart {
  final CheckoutRepository repository;

  const LoadCart(this.repository);

  Future<Cart?> call() {
    return repository.loadCart();
  }
}
