import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jannah/app/navigation/navigation_cubit.dart';
import 'package:jannah/features/categories/data/category_model.dart';
import 'package:jannah/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:jannah/features/categories/presentation/cubit/categories_state.dart';
import 'package:jannah/features/home_page/presentation/cubit/promotions_cubit.dart';
import 'package:jannah/features/home_page/presentation/cubit/promotions_state.dart';
import 'package:jannah/features/home_page/presentation/widgets/promotions_banner.dart';
import 'package:jannah/features/products/presentation/cubit/products_cubit.dart';
import 'package:jannah/features/products/presentation/cubit/products_state.dart';
import 'package:jannah/features/products/presentation/primary_item_card.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SafeArea(child: _HomePageProductsView()));
  }
}

class _HomePageProductsView extends StatefulWidget {
  const _HomePageProductsView();

  @override
  State<_HomePageProductsView> createState() => _HomePageProductsViewState();
}

class _HomePageProductsViewState extends State<_HomePageProductsView> {
  static const int _allCategoryId = -1;

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchProducts() {
    context.read<ProductsCubit>().searchProductsByName(
      productName: _searchController.text,
    );
  }

  Future<void> _loadCurrentProducts() {
    final selectedCategoryId = context
        .read<ProductsCubit>()
        .state
        .selectedCategoryId;

    if (selectedCategoryId == null) {
      return context.read<ProductsCubit>().loadProducts();
    }

    return context.read<ProductsCubit>().loadProductsByCategoryId(
      categoryId: selectedCategoryId,
    );
  }

  Future<void> _refreshProducts() {
    final state = context.read<ProductsCubit>().state;

    if ((state.searchQuery ?? '').isNotEmpty) {
      return context.read<ProductsCubit>().searchProductsByName(
        productName: state.searchQuery!,
      );
    }

    return _loadCurrentProducts();
  }

  void _selectCategory(Category category) {
    _searchController.clear();

    if (category.categoryId == _allCategoryId) {
      context.read<ProductsCubit>().loadProducts();
      return;
    }

    context.read<ProductsCubit>().loadProductsByCategoryId(
      categoryId: category.categoryId,
    );
  }

  Widget _buildCategoryFilters(ProductsState productsState) {
    final all = Category(
      categoryId: _allCategoryId,
      categoryName: 'All',
      description: '',
      imageUrl: '',
    );

    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, categoriesState) {
        final categories = [all, ...categoriesState.categories];

        return ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = category.categoryId == _allCategoryId
                ? productsState.selectedCategoryId == null
                : productsState.selectedCategoryId == category.categoryId;

            return GestureDetector(
              onTap: () => _selectCategory(category),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Text(
                    category.categoryName,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshProducts,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _searchProducts(),
                onChanged: (value) {
                  if (value.trim().isEmpty) {
                    _loadCurrentProducts();
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(30, 0, 0, 0),
                  hintText: 'Search products',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _loadCurrentProducts();
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(0, 0, 0, 0),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(0, 0, 0, 0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<ProductsCubit, ProductsState>(
                builder: (context, state) {
                  if (state.productsStatus == ProductsStatus.loading &&
                      state.products.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.productsStatus == ProductsStatus.failure) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          state.errorMessage ?? 'Something went wrong',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
                    children: [
                      BlocBuilder<PromotionsCubit, PromotionsState>(
                        builder: (context, state) {
                          if (state.promotionsStatus ==
                              PromotionsStatus.loading) {
                            return PromotionsBanner(promotions: []);
                          }
                          if (state.promotionsStatus ==
                              PromotionsStatus.failure) {
                            return PromotionsBanner(promotions: []);
                          }
                          return PromotionsBanner(promotions: state.promotions);
                        },
                      ),
                      SizedBox(height: 20),
                      SizedBox(height: 30, child: _buildCategoryFilters(state)),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            context.read<NavigationCubit>().goToTab(1);
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(2, 12, 8, 2),
                            child: Text(
                              'Se All >>',
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (state.products.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 80),
                          child: Center(
                            child: Text(
                              'No products found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      else
                        for (var product in state.products)
                          PrimaryItemCard(product: product),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
