import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jannah/app/navigation/navigation_cubit.dart';
import 'package:jannah/features/favourites/data/favourites_remote_data_source.dart';
import 'package:jannah/features/favourites/data/favourites_repository_impl.dart';
import 'package:jannah/features/favourites/domain/usecases/add_to_favourites.dart';
import 'package:jannah/features/favourites/domain/usecases/get_favourites.dart';
import 'package:jannah/features/favourites/domain/usecases/remove_from_favourites.dart';
import 'package:jannah/features/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:jannah/features/favourites/presentation/favourites_screen.dart';
import 'package:jannah/features/home_page/presentation/home_page_screen.dart';
import 'package:jannah/features/products/data/products_remote_data_source.dart';
import 'package:jannah/features/products/data/products_repository_impl.dart';
import 'package:jannah/features/products/domain/usecases/get_product_by_id.dart';
import 'package:jannah/features/products/domain/usecases/get_products_by_category_id.dart';
import 'package:jannah/features/products/domain/usecases/get_products_by_name.dart';
import 'package:jannah/features/products/presentation/cubit/products_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JannahNavigationBar extends StatelessWidget {
  const JannahNavigationBar({super.key});

  FavouritesCubit _createFavouritesCubit() {
    final remoteDataSource = InMemoryFavouritesRemoteDataSource();
    final repository = FavouritesRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );

    return FavouritesCubit(
      getFavourites: GetFavourites(repository),
      addToFavourites: AddToFavourites(repository),
      removeFromFavourites: RemoveFromFavourites(repository),
      // Replace this with the authenticated user id once auth exposes it.
      currentUserId: 1,
    )..loadFavourites();
  }

  ProductsCubit _createProductsCubit() {
    final remoteDataSource = MockProductsRemoteDataSource();
    final repository = ProductsRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );

    return ProductsCubit(
      getProductById: GetProductById(repository),
      getProductsByCategoryId: GetProductsByCategoryId(repository),
      getProductsByName: GetProductsByName(repository),
    )..loadProductsByCategoryId(categoryId: 1);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider(create: (_) => _createFavouritesCubit()),
        BlocProvider(create: (_) => _createProductsCubit()),
      ],
      child: const _JannahNavigationScaffold(),
    );
  }
}

class _JannahNavigationScaffold extends StatelessWidget {
  const _JannahNavigationScaffold();

  Widget _svgIcon(String path, {double size = 24.0}) {
    return SvgPicture.asset(path, width: size, height: size);
  }

  List<BottomNavigationBarItem> get _navBarItems => [
    BottomNavigationBarItem(
      icon: _svgIcon('assets/icons/home_border.svg', size: 20),
      activeIcon: _svgIcon('assets/icons/home_filled.svg', size: 26),
      label: 'Home',
      backgroundColor: Colors.white,
    ),
    BottomNavigationBarItem(
      icon: _svgIcon('assets/icons/checkout_border.svg'),
      activeIcon: _svgIcon('assets/icons/checkout_filled.svg', size: 28),
      label: 'Search',
      backgroundColor: Colors.white,
    ),
    BottomNavigationBarItem(
      icon: _svgIcon('assets/icons/favourite_border.svg'),
      activeIcon: _svgIcon('assets/icons/favourite_filled.svg'),
      label: 'Cart',
      backgroundColor: Colors.white,
    ),
    BottomNavigationBarItem(
      icon: _svgIcon('assets/icons/profile_border.svg'),
      activeIcon: _svgIcon('assets/icons/profile_filled.svg', size: 28),
      label: 'Profile',
      backgroundColor: Colors.white,
    ),
  ];

  List<Widget> get _navBarScreens => [
    const HomePageScreen(),
    Center(child: Text('Checkout Screen')),
    FavouritesScreen(),
    Center(child: Text('Profile Screen')),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          body: _navBarScreens[currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: _navBarItems,
            currentIndex: currentIndex,
            onTap: (index) {
              context.read<NavigationCubit>().goToTab(index);
            },
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black,
          ),
        );
      },
    );
  }
}
