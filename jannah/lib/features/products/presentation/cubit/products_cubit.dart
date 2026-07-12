import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jannah/features/products/domain/usecases/get_product_by_id.dart';
import 'package:jannah/features/products/domain/usecases/get_products.dart';
import 'package:jannah/features/products/domain/usecases/get_products_by_category_id.dart';
import 'package:jannah/features/products/domain/usecases/get_products_by_name.dart';
import 'package:jannah/features/products/presentation/cubit/products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final GetProducts getProducts;
  final GetProductById getProductById;
  final GetProductsByCategoryId getProductsByCategoryId;
  final GetProductsByName getProductsByName;

  ProductsCubit({
    required this.getProducts,
    required this.getProductById,
    required this.getProductsByCategoryId,
    required this.getProductsByName,
  }) : super(const ProductsState());

  Future<void> loadProducts() async {
    emit(
      state.copyWith(
        productsStatus: ProductsStatus.loading,
        clearSearchQuery: true,
        clearErrorMessage: true,
      ),
    );

    try {
      final products = await getProducts();
      emit(
        state.copyWith(
          productsStatus: ProductsStatus.success,
          products: products,
          clearSearchQuery: true,
          clearErrorMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          productsStatus: ProductsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> loadProductsByCategoryId({required int categoryId}) async {
    emit(
      state.copyWith(
        productsStatus: ProductsStatus.loading,
        selectedCategoryId: categoryId,
        clearSearchQuery: true,
        clearErrorMessage: true,
      ),
    );

    try {
      final products = await getProductsByCategoryId(categoryId: categoryId);
      emit(
        state.copyWith(
          productsStatus: ProductsStatus.success,
          products: products,
          selectedCategoryId: categoryId,
          clearSearchQuery: true,
          clearErrorMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          productsStatus: ProductsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> searchProductsByName({required String productName}) async {
    final searchQuery = productName.trim();

    if (searchQuery.isEmpty) {
      return loadProductsByCategoryId(
        categoryId: state.selectedCategoryId ?? 1,
      );
    }

    emit(
      state.copyWith(
        productsStatus: ProductsStatus.loading,
        searchQuery: searchQuery,
        clearErrorMessage: true,
      ),
    );

    try {
      final products = await getProductsByName(productName: searchQuery);
      emit(
        state.copyWith(
          productsStatus: ProductsStatus.success,
          products: products,
          searchQuery: searchQuery,
          clearErrorMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          productsStatus: ProductsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> loadProductById({required int productId}) async {
    emit(
      state.copyWith(
        productStatus: ProductsStatus.loading,
        clearProductErrorMessage: true,
      ),
    );

    try {
      final product = await getProductById(productId: productId);
      emit(
        state.copyWith(
          productStatus: ProductsStatus.success,
          selectedProduct: product,
          clearProductErrorMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          productStatus: ProductsStatus.failure,
          productErrorMessage: e.toString(),
        ),
      );
    }
  }
}
