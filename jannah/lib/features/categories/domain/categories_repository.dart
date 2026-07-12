import 'package:jannah/features/categories/data/category_model.dart';

abstract class CategoriesRepository {
  Future<List<Category>> fetchCategories();
}
