import 'package:jannah/features/categories/data/category_model.dart';
import 'package:jannah/features/categories/data/categories_remote_data_source.dart';
import 'package:jannah/features/categories/domain/categories_repository.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesRemoteDataSource remoteDataSource;

  const CategoriesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Category>> fetchCategories() {
    return remoteDataSource.fetchCategories();
  }
}
