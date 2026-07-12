import 'package:jannah/features/categories/data/category_model.dart';

enum CategoriesStatus { initial, loading, success, failure }

class CategoriesState {
  final CategoriesStatus categoriessStatus;
  final List<Category> categories;
  final String? errorMessage;

  const CategoriesState({
    this.categoriessStatus = CategoriesStatus.initial,
    this.categories = const [],
    this.errorMessage,
  });

  CategoriesState copyWith({
    CategoriesStatus? categoriesStatus,
    List<Category>? categories,
    String? errorMessage,
  }) {
    return CategoriesState(
      categoriessStatus: categoriesStatus ?? this.categoriessStatus,
      categories: categories ?? this.categories,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
