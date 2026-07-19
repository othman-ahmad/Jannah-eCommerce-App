import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jannah/features/authentication/presentation/guest_guard.dart';
import 'package:jannah/features/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:jannah/features/favourites/presentation/cubit/favourites_state.dart';

class FavouriteToggleButton extends StatelessWidget {
  final int productId;
  final double size;

  const FavouriteToggleButton({
    super.key,
    required this.productId,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavouritesCubit, FavouritesState>(
      buildWhen: (previous, current) {
        return previous.isFavourite(productId) !=
                current.isFavourite(productId) ||
            previous.isPending(productId) != current.isPending(productId);
      },
      builder: (context, state) {
        final isFavourite = state.isFavourite(productId);
        final isPending = state.isPending(productId);

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: isPending
              ? null
              : () {
                  if (!requireAuthenticatedUser(
                    context,
                    message: 'Please login to add items to favourites.',
                  )) {
                    return;
                  }

                  context.read<FavouritesCubit>().toggleFavourite(productId);
                },
          child: Opacity(
            opacity: isPending ? 0.45 : 1,
            child: SvgPicture.asset(
              isFavourite
                  ? 'assets/icons/like_filled_icon.svg'
                  : 'assets/icons/like_border_icon.svg',
              width: size,
              height: size,
              colorFilter: const ColorFilter.mode(
                Colors.black,
                BlendMode.srcIn,
              ),
            ),
          ),
        );
      },
    );
  }
}
