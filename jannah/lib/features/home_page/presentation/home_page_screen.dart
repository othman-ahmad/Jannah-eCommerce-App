import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jannah/features/products/presentation/checkout_item_card.dart';
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

  Future<void> _refreshProducts() {
    final state = context.read<ProductsCubit>().state;

    if ((state.searchQuery ?? '').isNotEmpty) {
      return context.read<ProductsCubit>().searchProductsByName(
        productName: state.searchQuery!,
      );
    }

    return context.read<ProductsCubit>().loadProductsByCategoryId(
      categoryId: state.selectedCategoryId ?? 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _searchProducts(),
              onChanged: (value) {
                if (value.trim().isEmpty) {
                  context.read<ProductsCubit>().loadProductsByCategoryId(
                    categoryId: 1,
                  );
                }
              },
              decoration: InputDecoration(
                hintText: 'Search products',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<ProductsCubit>().loadProductsByCategoryId(
                      categoryId: 1,
                    );
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
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

                if (state.products.isEmpty) {
                  return const Center(
                    child: Text(
                      'No products found',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _refreshProducts,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
                    itemCount: state.products.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 16),
                    itemBuilder: (context, index) {
                      return CheckoutItemCard(
                        product: state.products[index],
                        count: 0,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
