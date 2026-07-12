import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jannah/features/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:jannah/features/categories/data/category_model.dart';
import 'package:jannah/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:jannah/features/products/presentation/cubit/products_cubit.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category});
  final Category category;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //TODO: Navigate to the home page with the selected category ID
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
