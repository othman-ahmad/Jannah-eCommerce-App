import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jannah/core/helpers/cloudinary_image.dart';
import 'package:jannah/features/categories/data/category_model.dart';
import 'package:jannah/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:jannah/features/home_page/presentation/cubit/promotions_cubit.dart';
import 'package:jannah/features/products/presentation/category_items_screen.dart';
import 'package:jannah/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:jannah/features/categories/presentation/cubit/categories_state.dart';
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
    final remoteDataSource = ApiProductsRemoteDataSource();
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

  Category? _categoryForPromotion(List<Category> categories, int categoryId) {
    for (final category in categories) {
      if (category.categoryId == categoryId) {
        return category;
      }
    }
    return null;
  }

  Future<Category?> _loadPromotionCategory(int categoryId) async {
    final categoriesCubit = context.read<CategoriesCubit>();
    var categoriesState = categoriesCubit.state;

    if (categoriesState.categories.isEmpty) {
      if (categoriesState.categoriesStatus == CategoriesStatus.loading) {
        categoriesState = await categoriesCubit.stream.firstWhere(
          (state) => state.categoriesStatus != CategoriesStatus.loading,
        );
      } else {
        await categoriesCubit.loadCategories();
        categoriesState = categoriesCubit.state;
      }
    }

    return _categoryForPromotion(categoriesState.categories, categoryId);
  }

  Future<void> _openCurrentPromotion() async {
    final promotion = widget.promotions[_currentPage];
    final category = await _loadPromotionCategory(promotion.categoryId);

    if (!mounted) return;

    if (category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This promotion category is unavailable')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<FavouritesCubit>()),
            BlocProvider.value(value: context.read<CheckoutCubit>()),
            BlocProvider(create: (_) => _createProductsCubit()),
            BlocProvider.value(value: context.read<PromotionsCubit>()),
          ],
          child: CategoryItemsScreen(category: category),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 166,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
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
                  behavior: HitTestBehavior.opaque,
                  onTap: _openCurrentPromotion,
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
                      print(
                        'Promotion image URL: ${promotion.imageUrl}',
                      ); // Debug print
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CloudinaryImage(
                                imagePath: promotion.imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                            Positioned(
                              top: 24,
                              left: 32,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.43,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.promotions[_currentPage].title,
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget
                                          .promotions[_currentPage]
                                          .description,
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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
                              ? const Color.fromARGB(80, 0, 0, 0)
                              : const Color.fromARGB(255, 255, 255, 255),
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
