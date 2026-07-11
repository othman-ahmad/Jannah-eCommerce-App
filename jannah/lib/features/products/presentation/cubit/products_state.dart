import 'package:jannah/features/products/data/item_model.dart';

enum ProductsStatus { initial, loading, success, failure }

class ProductsState {
  final ProductsStatus productsStatus;
  final ProductsStatus productStatus;
  final List<Product> products;
  final Product? selectedProduct;
  final int? selectedCategoryId;
  final String? searchQuery;
  final String? errorMessage;
  final String? productErrorMessage;

  const ProductsState({
    this.productsStatus = ProductsStatus.initial,
    this.productStatus = ProductsStatus.initial,
    this.products = const [],
    this.selectedProduct,
    this.selectedCategoryId,
    this.searchQuery,
    this.errorMessage,
    this.productErrorMessage,
  });

  ProductsState copyWith({
    ProductsStatus? productsStatus,
    ProductsStatus? productStatus,
    List<Product>? products,
    Product? selectedProduct,
    int? selectedCategoryId,
    String? searchQuery,
    String? errorMessage,
    String? productErrorMessage,
    bool clearSelectedProduct = false,
    bool clearSearchQuery = false,
    bool clearErrorMessage = false,
    bool clearProductErrorMessage = false,
  }) {
    return ProductsState(
      productsStatus: productsStatus ?? this.productsStatus,
      productStatus: productStatus ?? this.productStatus,
      products: products ?? this.products,
      selectedProduct: clearSelectedProduct
          ? null
          : selectedProduct ?? this.selectedProduct,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      searchQuery: clearSearchQuery ? null : searchQuery ?? this.searchQuery,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      productErrorMessage: clearProductErrorMessage
          ? null
          : productErrorMessage ?? this.productErrorMessage,
    );
  }
}
