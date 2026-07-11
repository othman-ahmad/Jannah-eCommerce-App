import 'package:jannah/features/products/data/item_model.dart';
import 'package:jannah/features/products/domain/products_repository.dart';

class GetProductsByName {
  final ProductsRepository repository;

  const GetProductsByName(this.repository);

  Future<List<Product>> call({required String productName}) {
    return repository.getProductsByName(productName: productName);
  }
}
