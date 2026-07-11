import 'package:jannah/features/products/data/item_model.dart';
import 'package:jannah/features/products/data/products_remote_data_source.dart';
import 'package:jannah/features/products/domain/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource remoteDataSource;

  const ProductsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Product> getProductById({required int productId}) {
    return remoteDataSource.fetchProductById(productId: productId);
  }

  @override
  Future<List<Product>> getProductsByCategoryId({required int categoryId}) {
    return remoteDataSource.fetchProductsByCategoryId(categoryId: categoryId);
  }

  @override
  Future<List<Product>> getProductsByName({required String productName}) {
    return remoteDataSource.fetchProductsByName(productName: productName);
  }
}
