import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jannah/core/helpers/cloudinary_Image.dart';
import 'package:jannah/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:jannah/features/checkout/presentation/cubit/checkout_state.dart';
import 'package:jannah/features/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:jannah/features/home_page/data/promotion_model.dart';
import 'package:jannah/features/home_page/presentation/cubit/promotions_cubit.dart';
import 'package:jannah/features/products/data/item_model.dart';
import 'package:jannah/features/products/presentation/cubit/products_cubit.dart';
import 'package:jannah/features/products/presentation/item_details_screen.dart';

class PrimaryItemCard extends StatefulWidget {
  const PrimaryItemCard({super.key, required this.product});
  final Product product;

  @override
  State<PrimaryItemCard> createState() => _PrimaryItemCardState();
}

class _PrimaryItemCardState extends State<PrimaryItemCard> {
  @override
  Widget build(BuildContext context) {
    final basePrice = widget.product.price;

    return FutureBuilder<List<Promotion>>(
      future: context.read<PromotionsCubit>().getPromotions(),
      builder: (context, promotionSnapshot) {
        double displayPrice = basePrice;
        if (promotionSnapshot.hasData) {
          final promotions = promotionSnapshot.data!;
          Promotion? promotion;
          try {
            promotion = promotions.firstWhere(
              (p) => p.categoryId == widget.product.categoryId,
            );
          } catch (_) {
            promotion = null;
          }

          if (promotion != null) {
            displayPrice =
                basePrice * ((100 - promotion.discountPercentage) / 100);
          }
        }

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
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
                    BlocProvider.value(value: context.read<PromotionsCubit>()),
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
            margin: const EdgeInsets.only(right: 8),
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
                    child: CloudinaryImage(
                      imagePath: widget.product.imagesList.first,
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
                      const SizedBox(height: 8),
                      Text(
                        widget.product.productName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Spacer(),
                      Text(
                        widget.product.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                BlocBuilder<CheckoutCubit, CheckoutState>(
                  builder: (context, state) {
                    final quantity = state.quantityForProduct(
                      widget.product.productId,
                    );
                    final isPending = state.isPending(widget.product.productId);

                    return SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$${displayPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                                if (basePrice != displayPrice)
                                  Text(
                                    '\$${basePrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(180, 0, 0, 0),
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            height: 32,
                            child: quantity == 0
                                ? GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: isPending
                                        ? null
                                        : () {
                                            context
                                                .read<CheckoutCubit>()
                                                .addCartItem(
                                                  productId:
                                                      widget.product.productId,
                                                  quantity: 1,
                                                  price: displayPrice,
                                                );
                                          },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 21,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                          255,
                                          0,
                                          0,
                                          0,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/icons/cart_icon.svg',
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: isPending
                                            ? null
                                            : () {
                                                context
                                                    .read<CheckoutCubit>()
                                                    .removeCartItem(
                                                      productId: widget
                                                          .product
                                                          .productId,
                                                    );
                                              },
                                        child: quantity == 1
                                            ? Padding(
                                                padding: const EdgeInsets.all(
                                                  2,
                                                ),
                                                child: SvgPicture.asset(
                                                  'assets/icons/trash_icon.svg',
                                                  width: 20,
                                                  height: 20,
                                                ),
                                              )
                                            : const Icon(Icons.remove),
                                      ),
                                      Text(
                                        ' $quantity ',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: isPending
                                            ? null
                                            : () {
                                                context
                                                    .read<CheckoutCubit>()
                                                    .addCartItem(
                                                      productId: widget
                                                          .product
                                                          .productId,
                                                      quantity: 1,
                                                      price: displayPrice,
                                                    );
                                              },
                                        child: const Icon(Icons.add),
                                      ),
                                    ],
                                  ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
