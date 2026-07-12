import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jannah/features/categories/presentation/category_items_screen.dart';
import 'package:jannah/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:jannah/features/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:jannah/features/home_page/data/promotion_model.dart';
import 'package:jannah/features/products/data/products_remote_data_source.dart';
import 'package:jannah/features/products/data/products_repository_impl.dart';
import 'package:jannah/features/products/domain/usecases/get_product_by_id.dart';
import 'package:jannah/features/products/domain/usecases/get_products.dart';
import 'package:jannah/features/products/domain/usecases/get_products_by_category_id.dart';
import 'package:jannah/features/products/domain/usecases/get_products_by_name.dart';
import 'package:jannah/features/products/presentation/cubit/products_cubit.dart';

class PromotionsBanner extends StatefulWidget {
  const PromotionsBanner({super.key, required this.promotions});
  final List<Promotion> promotions;

  @override
  State<PromotionsBanner> createState() => _PromotionsBannerState();
}

class _PromotionsBannerState extends State<PromotionsBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  ProductsCubit _createProductsCubit() {
    final remoteDataSource = MockProductsRemoteDataSource();
    final repository = ProductsRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );

    return ProductsCubit(
      getProducts: GetProducts(repository),
      getProductById: GetProductById(repository),
      getProductsByCategoryId: GetProductsByCategoryId(repository),
      getProductsByName: GetProductsByName(repository),
    )..loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 209, 209, 209),
        borderRadius: BorderRadius.circular(8),
      ),
      child: widget.promotions.isEmpty
          ? const Center(
              child: Text(
                'No promotions available',
                style: TextStyle(color: Colors.black),
              ),
            )
          : Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(
                              value: context.read<FavouritesCubit>(),
                            ),
                            BlocProvider(create: (_) => _createProductsCubit()),
                          ],
                          child: CategoryItemsScreen(
                            category: context
                                .read<CategoriesCubit>()
                                .state
                                .categories
                                .firstWhere(
                                  (category) =>
                                      category.categoryId ==
                                      widget
                                          .promotions[_currentPage]
                                          .categoryId,
                                ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.promotions.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final promotion = widget.promotions[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          promotion.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 16,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        widget.promotions[_currentPage].title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.promotions[_currentPage].description,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.promotions.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : const Color.fromARGB(127, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
