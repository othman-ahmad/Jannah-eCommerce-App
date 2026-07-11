import 'package:jannah/features/products/data/item_model.dart';
import 'package:jannah/features/products/domain/products_repository.dart';

class GetProductById {
  final ProductsRepository repository;

  const GetProductById(this.repository);

  Future<Product> call({required int productId}) {
    return repository.getProductById(productId: productId);
  }
}
