import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jannah/app/navigation/navigation_cubit.dart';
import 'package:jannah/features/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:jannah/features/favourites/presentation/cubit/favourites_state.dart';
import 'package:jannah/features/favourites/presentation/widgets/favourite_toggle_button.dart';
import 'package:jannah/features/products/data/item_model.dart';
import 'package:jannah/features/products/presentation/checkout_item_card.dart';
import 'package:jannah/features/products/presentation/cubit/products_cubit.dart';
import 'package:jannah/features/products/presentation/favourite_item_card.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

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
          'Favourites',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<FavouritesCubit, FavouritesState>(
        builder: (context, state) {
          if (state.status == FavouritesStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == FavouritesStatus.failure) {
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

          if (state.favourites.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  Text(
                    'No favourites yet',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<FavouritesCubit>().loadFavourites(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.favourites.length,
              itemBuilder: (context, index) {
                final productId = state.favourites[index].productId;
                return FutureBuilder(
                  future: context.read<ProductsCubit>().getProductById(
                    productId: productId,
                  ),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData || snapshot.data == null) {
                      return const SizedBox.shrink();
                    }
                    final product = snapshot.data;
                    return FavouriteItemCard(product: product);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
