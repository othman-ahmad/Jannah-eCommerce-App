import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jannah/app/navigation/navigation_cubit.dart';
import 'package:jannah/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:jannah/features/categories/presentation/cubit/categories_state.dart';
import 'package:jannah/features/categories/presentation/category_card.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => CategoriesScreenState();
}

class CategoriesScreenState extends State<CategoriesScreen> {
  Future<void> _refreshCategories() {
    return context.read<CategoriesCubit>().loadCategories();
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
            context.read<NavigationCubit>().goHome();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Categories',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          if (state.categoriessStatus == CategoriesStatus.loading &&
              state.categories.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.categoriessStatus == CategoriesStatus.failure) {
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

          if (state.categories.isEmpty) {
            return const Center(
              child: Text(
                'No categories found',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshCategories,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
              itemCount: state.categories.length,

              itemBuilder: (context, index) {
                return CategoryCard(category: state.categories[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
