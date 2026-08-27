import 'package:jannah/features/checkout/domain/checkout_repository.dart';

class AddItem {
  final CheckoutRepository repository;

  const AddItem(this.repository);

  Future<void> call({
    required int productId,
    required int quantity,
    required double price,
  }) {
    return repository.addItem(
      productId: productId,
      quantity: quantity,
      price: price,
    );
  }
}
