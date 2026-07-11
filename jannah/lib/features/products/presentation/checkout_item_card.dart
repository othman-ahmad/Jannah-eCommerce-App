import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jannah/features/favourites/presentation/cubit/favourites_cubit.dart';
import 'package:jannah/features/products/data/item_model.dart';
import 'package:jannah/features/products/presentation/item_details_screen.dart';

class CheckoutItemCard extends StatefulWidget {
  CheckoutItemCard({super.key, required this.product, required this.count});
  Product product;
  int count;
  @override
  State<CheckoutItemCard> createState() => _CheckoutItemCardState();
}

class _CheckoutItemCardState extends State<CheckoutItemCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<FavouritesCubit>(),
              child: ItemDetailsScreen(
                product: widget.product,
                count: widget.count,
              ),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        height: 100,
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.product.imagesList.first,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: MediaQuery.of(context).size.width - 100 - 16 - 8 - 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.productName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.5),
                    child: Text(
                      '\$${(widget.product.price).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
            Spacer(),
            SizedBox(
              width: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${(widget.product.price * widget.count).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    height: 32,
                    child: widget.count == 0
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                widget.count++;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                borderRadius: BorderRadius.circular(100),
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
                                child: widget.count == 1
                                    ? Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: SvgPicture.asset(
                                          'assets/icons/trash_icon.svg',
                                          width: 20,
                                          height: 20,
                                        ),
                                      )
                                    : Icon(Icons.remove),
                                onTap: () {
                                  setState(() {
                                    if (widget.count > 0) {
                                      widget.count--;
                                    }
                                  });
                                },
                              ),
                              Text(
                                '  ${widget.count}  ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              InkWell(
                                child: const Icon(Icons.add),
                                onTap: () {
                                  setState(() {
                                    widget.count++;
                                  });
                                },
                              ),
                            ],
                          ),
                  ), // Pass the initial count here
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
