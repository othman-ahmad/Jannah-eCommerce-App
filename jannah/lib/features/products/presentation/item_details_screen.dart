import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jannah/core/custom_widgets/primary_button.dart';
import 'package:jannah/features/products/data/item_model.dart';
import 'package:jannah/features/products/presentation/product_images_slider.dart';

class ItemDetailsScreen extends StatefulWidget {
  ItemDetailsScreen({super.key, required this.product, this.count = 1});
  bool isFavorite = false;
  final Product product;
  int count;

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          buildProductImagesSlider(),
          SizedBox(height: 16),
          buildItemInfo(),
          buildCartSection(),
        ],
      ),
    );
  }

  buildProductImagesSlider() {
    return ProductImageSlider(images: widget.product.ImagesList);
  }

  buildItemInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.product.ProductName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                child: SvgPicture.asset(
                  width: 24,
                  height: 24,
                  widget.isFavorite
                      ? 'assets/icons/like_filled_icon.svg'
                      : 'assets/icons/like_border_icon.svg',
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
                onTap: () {
                  setState(() {
                    widget.isFavorite = !widget.isFavorite;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.product.Description * 10,
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
                '\$${widget.product.Price.toStringAsFixed(2)}  / ${widget.product.Unit}',
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

  buildCartSection() {
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
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
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
                        '\$${(widget.product.Price * widget.count).toStringAsFixed(2)}',
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
