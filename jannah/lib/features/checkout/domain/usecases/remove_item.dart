import 'package:jannah/features/checkout/domain/checkout_repository.dart';

class RemoveItem {
  final CheckoutRepository repository;

  const RemoveItem(this.repository);

  Future<void> call({required int userId, required int productId}) {
    return repository.removeItem(userId: userId, productId: productId);
  }
}
