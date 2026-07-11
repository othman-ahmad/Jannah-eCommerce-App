import 'package:flutter/material.dart';
import 'package:jannah/core/custom_widgets/primary_button.dart';
import 'package:jannah/features/favourites/presentation/widgets/favourite_toggle_button.dart';
import 'package:jannah/features/products/data/item_model.dart';
import 'package:jannah/features/products/presentation/product_images_slider.dart';

class ItemDetailsScreen extends StatefulWidget {
  ItemDetailsScreen({super.key, required this.product, this.count = 1});
  final Product product;
  int count;

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.only(top: 0),
        children: [
          buildProductImagesSlider(),
          SizedBox(height: 16),
          buildItemInfo(),
          buildCartSection(),
        ],
      ),
    );
  }

  Widget buildProductImagesSlider() {
    return ProductImageSlider(images: widget.product.imagesList);
  }

  Widget buildItemInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.product.productName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow
                      .ellipsis, // optional, handles >2 lines gracefully
                ),
              ),
              FavouriteToggleButton(productId: widget.product.productId),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.product.description,
            style: const TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 65,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '\$${widget.product.price.toStringAsFixed(2)}  / ${widget.product.unit}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.from(alpha: 1, red: 0, green: 0, blue: 0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCartSection() {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              ' Select Quantity',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ),
          SizedBox(
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (widget.count > 1) {
                        widget.count--;
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    height: 40,
                    width: 40,
                    child: const Center(
                      child: Icon(Icons.remove, color: Colors.white, size: 20),
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Center(
                    child: Text(
                      widget.count.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.count++;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    height: 40,
                    width: 40,
                    child: const Center(
                      child: Icon(Icons.add, color: Colors.white, size: 20),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Container(
                    width: 1,
                    height: 40,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Column(
                    children: [
                      Text(
                        '\$${(widget.product.price * widget.count).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      Text(
                        'Total',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          PrimaryButton(onPressed: () {}, text: 'Add to Cart'),
        ],
      ),
    );
  }
}
