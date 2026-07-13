import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jannah/features/products/presentation/category_items_screen.dart';
import 'package:jannah/features/categories/data/category_model.dart';
import 'package:jannah/features/favourites/data/favourites_remote_data_source.dart';
import 'package:jannah/features/favourites/data/favourites_repository_impl.dart';
import 'package:jannah/features/favourites/domain/usecases/add_to_favourites.dart';
import 'package:jannah/features/favourites/domain/usecases/get_favourites.dart';
import 'package:jannah/features/favourites/domain/usecases/remove_from_favourites.dart';
import 'package:jannah/features/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:jannah/features/products/data/products_remote_data_source.dart';
import 'package:jannah/features/products/data/products_repository_impl.dart';
import 'package:jannah/features/products/domain/usecases/get_product_by_id.dart';
import 'package:jannah/features/products/domain/usecases/get_products.dart';
import 'package:jannah/features/products/domain/usecases/get_products_by_category_id.dart';
import 'package:jannah/features/products/domain/usecases/get_products_by_name.dart';
import 'package:jannah/features/products/presentation/cubit/products_cubit.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category});
  final Category category;

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
    )..loadProductsByCategoryId(categoryId: category.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: context.read<FavouritesCubit>()),
                BlocProvider(create: (_) => _createProductsCubit()),
              ],
              child: CategoryItemsScreen(category: category),
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Image.network(category.imageUrl),
            ),
            const SizedBox(height: 8),
            Text(
              category.categoryName,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
