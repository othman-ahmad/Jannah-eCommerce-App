import 'package:jannah/features/products/data/item_model.dart';
import 'package:jannah/features/products/domain/products_repository.dart';

class GetProductsByCategoryId {
  final ProductsRepository repository;

  const GetProductsByCategoryId(this.repository);

  Future<List<Product>> call({required int categoryId}) {
    return repository.getProductsByCategoryId(categoryId: categoryId);
  }
}
