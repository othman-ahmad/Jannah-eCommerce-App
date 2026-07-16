import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jannah/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:jannah/features/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:jannah/features/favourites/presentation/widgets/favourite_toggle_button.dart';
import 'package:jannah/features/products/data/item_model.dart';
import 'package:jannah/features/products/presentation/cubit/products_cubit.dart';
import 'package:jannah/features/products/presentation/item_details_screen.dart';

class FavouriteItemCard extends StatefulWidget {
  const FavouriteItemCard({super.key, required this.product});
  final Product product;
  @override
  State<FavouriteItemCard> createState() => _FavouriteItemCardState();
}

class _FavouriteItemCardState extends State<FavouriteItemCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final cartQuantity = context
            .read<CheckoutCubit>()
            .state
            .quantityForProduct(widget.product.productId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: context.read<FavouritesCubit>()),
                BlocProvider.value(value: context.read<ProductsCubit>()),
                BlocProvider.value(value: context.read<CheckoutCubit>()),
              ],
              child: ItemDetailsScreen(
                productId: widget.product.productId,
                initialProduct: widget.product,
                count: cartQuantity == 0 ? 1 : cartQuantity,
              ),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(left: 8, right: 16),
        height: 100,
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.product.imagesList.first,
                  width: 84,
                  height: 84,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text(
                    widget.product.productName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 8),
                  Text(
                    '\$${widget.product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    height: 32,
                    child: FavouriteToggleButton(
                      productId: widget.product.productId,
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
