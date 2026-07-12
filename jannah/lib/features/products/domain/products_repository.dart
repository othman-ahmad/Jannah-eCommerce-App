import 'package:jannah/features/products/data/item_model.dart';

abstract class ProductsRepository {
  Future<List<Product>> getProducts();

  Future<Product> getProductById({required int productId});

  Future<List<Product>> getProductsByCategoryId({required int categoryId});

  Future<List<Product>> getProductsByName({required String productName});
}
