import 'package:jannah/features/products/data/item_model.dart';
import 'package:jannah/features/products/domain/products_repository.dart';

class GetProducts {
  final ProductsRepository repository;

  const GetProducts(this.repository);

  Future<List<Product>> call() {
    return repository.getProducts();
  }
}
