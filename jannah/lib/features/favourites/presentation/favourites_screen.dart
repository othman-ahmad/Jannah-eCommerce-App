import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jannah/app/navigation/navigation_cubit.dart';
import 'package:jannah/features/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:jannah/features/favourites/presentation/cubit/favourites_state.dart';
import 'package:jannah/features/favourites/presentation/widgets/favourite_toggle_button.dart';

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
              child: Text(
                'No favourites yet',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<FavouritesCubit>().loadFavourites(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.favourites.length,
              separatorBuilder: (context, index) => const Divider(height: 24),
              itemBuilder: (context, index) {
                final favourite = state.favourites[index];

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Product #${favourite.productId}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Liked on ${favourite.date.toLocal()}'.split('.').first,
                  ),
                  trailing: FavouriteToggleButton(
                    productId: favourite.productId,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
