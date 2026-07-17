import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jannah/app/navigation/navigation_cubit.dart';
import 'package:jannah/features/categories/data/categories_remote_data_source.dart';
import 'package:jannah/features/categories/data/categories_repository_impl.dart';
import 'package:jannah/features/categories/domain/usecases/get_categories.dart';
import 'package:jannah/features/categories/presentation/categories_screen.dart';
import 'package:jannah/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:jannah/features/checkout/data/checkout_remote_data_source.dart';
import 'package:jannah/features/checkout/data/checkout_repository_impl.dart';
import 'package:jannah/features/checkout/domain/usecases/add_item.dart';
import 'package:jannah/features/checkout/domain/usecases/checkout.dart';
import 'package:jannah/features/checkout/domain/usecases/create_cart.dart';
import 'package:jannah/features/checkout/domain/usecases/delete_cart.dart';
import 'package:jannah/features/checkout/domain/usecases/load_cart.dart';
import 'package:jannah/features/checkout/domain/usecases/load_cart_items.dart';
import 'package:jannah/features/checkout/domain/usecases/remove_item.dart';
import 'package:jannah/features/checkout/presentation/checkout_screen.dart';
import 'package:jannah/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:jannah/features/favourites/data/favourites_remote_data_source.dart';
import 'package:jannah/features/favourites/data/favourites_repository_impl.dart';
import 'package:jannah/features/favourites/domain/usecases/add_to_favourites.dart';
import 'package:jannah/features/favourites/domain/usecases/get_favourites.dart';
import 'package:jannah/features/favourites/domain/usecases/remove_from_favourites.dart';
import 'package:jannah/features/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:jannah/features/favourites/presentation/favourites_screen.dart';
import 'package:jannah/features/home_page/data/promotions_remote_data_source.dart';
import 'package:jannah/features/home_page/data/promotions_repository_impl.dart';
import 'package:jannah/features/home_page/domain/usecases/get_promotions.dart';
import 'package:jannah/features/home_page/presentation/cubit/promotions_cubit.dart';
import 'package:jannah/features/home_page/presentation/home_page_screen.dart';
import 'package:jannah/features/products/data/products_remote_data_source.dart';
import 'package:jannah/features/products/data/products_repository_impl.dart';
import 'package:jannah/features/products/domain/usecases/get_product_by_id.dart';
import 'package:jannah/features/products/domain/usecases/get_products.dart';
import 'package:jannah/features/products/domain/usecases/get_products_by_category_id.dart';
import 'package:jannah/features/products/domain/usecases/get_products_by_name.dart';
import 'package:jannah/features/products/presentation/cubit/products_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jannah/features/profile/data/profile_remote_data_source.dart';
import 'package:jannah/features/profile/data/profile_repository_impl.dart';
import 'package:jannah/features/profile/domain/usecases/delete_address.dart';
import 'package:jannah/features/profile/domain/usecases/get_addresses.dart';
import 'package:jannah/features/profile/domain/usecases/get_profile.dart';
import 'package:jannah/features/profile/domain/usecases/save_address.dart';
import 'package:jannah/features/profile/domain/usecases/update_profile.dart';
import 'package:jannah/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:jannah/features/profile/presentation/profile_screen.dart';

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
      getProducts: GetProducts(repository),
      getProductById: GetProductById(repository),
      getProductsByCategoryId: GetProductsByCategoryId(repository),
      getProductsByName: GetProductsByName(repository),
    )..loadProducts();
  }

  CheckoutCubit _createCheckoutCubit() {
    final remoteDataSource = InMemoryCheckoutRemoteDataSource();
    final repository = CheckoutRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );

    return CheckoutCubit(
      loadCartUseCase: LoadCart(repository),
      createCartUseCase: CreateCart(repository),
      deleteCartUseCase: DeleteCart(repository),
      addItemUseCase: AddItem(repository),
      removeItemUseCase: RemoveItem(repository),
      checkoutUseCase: Checkout(repository),
      loadCartItemsUseCase: LoadCartItems(repository),
      // Replace this with the authenticated user id once auth exposes it.
      currentUserId: 1,
    )..loadCart();
  }

  CategoriesCubit _createCategoriesCubit() {
    final remoteDataSource = MockCategoriesRemoteDataSource();
    final repository = CategoriesRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );

    return CategoriesCubit(getCategories: GetCategories(repository))
      ..loadCategories();
  }

  PromotionsCubit _createPromotionsCubit() {
    final remoteDataSource = MockPromotionsRemoteDataSource();
    final repository = PromotionsRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );

    return PromotionsCubit(getPromotions: GetPromotions(repository))
      ..loadPromotions();
  }

  ProfileCubit _createProfileCubit() {
    final remoteDataSource = MockProfileRemoteDataSource();
    final repository = ProfileRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );

    return ProfileCubit(
      getProfile: GetProfile(repository),
      updateProfile: UpdateProfile(repository),
      getAddresses: GetAddresses(repository),
      saveAddress: SaveAddress(repository),
      deleteAddress: DeleteAddress(repository),
      // Replace this with the authenticated user id once auth exposes it.
      currentUserId: 1,
    )..loadProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider(create: (_) => _createFavouritesCubit()),
        BlocProvider(create: (_) => _createProductsCubit()),
        BlocProvider(create: (_) => _createCheckoutCubit()),
        BlocProvider(create: (_) => _createCategoriesCubit()),
        BlocProvider(create: (_) => _createPromotionsCubit()),
        BlocProvider(create: (_) => _createProfileCubit()),
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
      activeIcon: _svgIcon('assets/icons/home_filled.svg'),
      label: 'Home',
      backgroundColor: Colors.white,
    ),
    BottomNavigationBarItem(
      icon: _svgIcon('assets/icons/categories_border.svg'),
      activeIcon: _svgIcon('assets/icons/categories_filled.svg'),
      label: 'Categories',
      backgroundColor: Colors.white,
    ),
    BottomNavigationBarItem(
      icon: _svgIcon('assets/icons/checkout_border.svg'),
      activeIcon: _svgIcon('assets/icons/checkout_filled.svg'),
      label: 'Checkout',
      backgroundColor: Colors.white,
    ),
    BottomNavigationBarItem(
      icon: _svgIcon('assets/icons/favourite_border.svg'),
      activeIcon: _svgIcon('assets/icons/favourite_filled.svg', size: 20),
      label: 'Favourites',
      backgroundColor: Colors.white,
    ),
    BottomNavigationBarItem(
      icon: _svgIcon('assets/icons/orders_border.svg'),
      activeIcon: _svgIcon('assets/icons/orders_filled.svg'),
      label: 'orders',
      backgroundColor: Colors.white,
    ),
    BottomNavigationBarItem(
      icon: _svgIcon('assets/icons/profile_border.svg'),
      activeIcon: _svgIcon('assets/icons/profile_filled.svg'),
      label: 'Profile',
      backgroundColor: Colors.white,
    ),
  ];

  List<Widget> get _navBarScreens => [
    const HomePageScreen(),
    CategoriesScreen(),
    CheckoutScreen(),
    FavouritesScreen(),
    Center(child: Text('Orders Screen')),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, currentIndex) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              context.read<NavigationCubit>().goHome();
            }
          },
          child: Scaffold(
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
          ),
        );
      },
    );
  }
}
