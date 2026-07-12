import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jannah/features/categories/domain/usecases/get_categories.dart';
import 'package:jannah/features/categories/presentation/cubit/categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final GetCategories getCategories;

  CategoriesCubit({required this.getCategories})
    : super(const CategoriesState());

  Future<void> loadCategories() async {
    emit(state.copyWith(categoriesStatus: CategoriesStatus.loading));

    try {
      final categories = await getCategories();
      emit(
        state.copyWith(
          categoriesStatus: CategoriesStatus.success,
          categories: categories,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          categoriesStatus: CategoriesStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
