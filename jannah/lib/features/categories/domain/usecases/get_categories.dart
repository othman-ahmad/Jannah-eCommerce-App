import 'package:jannah/features/categories/data/category_model.dart';
import 'package:jannah/features/categories/domain/categories_repository.dart';

class GetCategories {
  final CategoriesRepository repository;

  const GetCategories(this.repository);

  Future<List<Category>> call() {
    return repository.fetchCategories();
  }
}
