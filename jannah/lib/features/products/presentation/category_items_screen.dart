import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jannah/features/categories/data/category_model.dart';
import 'package:jannah/features/products/presentation/cubit/products_cubit.dart';
import 'package:jannah/features/products/presentation/cubit/products_state.dart';
import 'package:jannah/features/products/presentation/primary_item_card.dart';

class CategoryItemsScreen extends StatefulWidget {
  const CategoryItemsScreen({super.key, required this.category});
  final Category category;
  @override
  State<CategoryItemsScreen> createState() => CategoriesScreenState();
}

class CategoriesScreenState extends State<CategoryItemsScreen> {
  Future<void> _refreshCategory() {
    return context.read<ProductsCubit>().loadProductsByCategoryId(
      categoryId: widget.category.categoryId,
    );
  }

  @override
  void initState() {
    super.initState();
    _refreshCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/back_button_icon.svg',
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.category.categoryName,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<ProductsCubit, ProductsState>(
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshCategory,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                return PrimaryItemCard(
                  product: state.products[index],
                  count: 0,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
