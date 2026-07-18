import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jannah/features/checkout/data/cart_item_model.dart';
import 'package:jannah/features/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:jannah/features/checkout/presentation/cubit/checkout_state.dart';
import 'package:jannah/features/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:jannah/features/home_page/data/promotion_model.dart';
import 'package:jannah/features/home_page/presentation/cubit/promotions_cubit.dart';
import 'package:jannah/features/products/data/item_model.dart';
import 'package:jannah/features/products/presentation/cubit/products_cubit.dart';
import 'package:jannah/features/products/presentation/item_details_screen.dart';

class CheckoutItemCard extends StatelessWidget {
  const CheckoutItemCard({super.key, required this.cartItem});
  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product>(
      future: context.read<ProductsCubit>().getProductById(
        productId: cartItem.productId,
      ),
      builder: (context, productSnapshot) {
        if (!productSnapshot.hasData) {
          return const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final product = productSnapshot.data!;
        final basePrice = product.price;

        return FutureBuilder<List<Promotion>>(
          future: context.read<PromotionsCubit>().getPromotions(),
          builder: (context, promotionSnapshot) {
            if (!promotionSnapshot.hasData) {
              return const SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final promotions = promotionSnapshot.data!;

            Promotion? promotion;
            try {
              promotion = promotions.firstWhere(
                (p) => p.categoryId == product.categoryId,
              );
            } catch (_) {
              promotion = null;
            }

            final displayPrice = promotion == null
                ? basePrice
                : basePrice * ((100 - promotion.discountPercentage) / 100);

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(
                          value: context.read<FavouritesCubit>(),
                        ),
                        BlocProvider.value(
                          value: context.read<ProductsCubit>(),
                        ),
                        BlocProvider.value(
                          value: context.read<CheckoutCubit>(),
                        ),
                        BlocProvider.value(
                          value: context.read<PromotionsCubit>(),
                        ),
                      ],
                      child: ItemDetailsScreen(
                        productId: product.productId,
                        initialProduct: product,
                        count: cartItem.quantity,
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(left: 8, right: 8),
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
                          product.imagesList.first,
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
                            product.productName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const Spacer(),
                          Text(
                            '\$${basePrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(180, 0, 0, 0),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.5),
                            child: Text(
                              '\$${displayPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    BlocBuilder<CheckoutCubit, CheckoutState>(
                      builder: (context, state) {
                        final quantity = state.quantityForProduct(
                          product.productId,
                        );
                        final isPending = state.isPending(product.productId);

                        return SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: Text(
                                  '\$${(displayPrice * quantity).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                height: 32,
                                child: quantity == 0
                                    ? GestureDetector(
                                        onTap: isPending
                                            ? null
                                            : () {
                                                context
                                                    .read<CheckoutCubit>()
                                                    .addCartItem(
                                                      productId:
                                                          product.productId,
                                                      quantity: 1,
                                                      price: displayPrice,
                                                    );
                                              },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 28,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: isPending
                                                ? null
                                                : () {
                                                    context
                                                        .read<CheckoutCubit>()
                                                        .removeCartItem(
                                                          productId:
                                                              product.productId,
                                                        );
                                                  },
                                            child: quantity == 1
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(2),
                                                    child: SvgPicture.asset(
                                                      'assets/icons/trash_icon.svg',
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                  )
                                                : const Icon(Icons.remove),
                                          ),
                                          Text(
                                            '  $quantity  ',
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
                                                          productId:
                                                              product.productId,
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
      },
    );
  }
}
