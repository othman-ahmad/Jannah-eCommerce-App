import 'package:flutter/material.dart';
import 'package:jannah/features/products/data/item_model.dart';
import 'package:jannah/features/products/presentation/checkout_item_card.dart';
import 'package:jannah/features/products/presentation/favourite_item_card.dart';
import 'package:jannah/features/products/presentation/primary_item_card.dart';

class HomePageScreen extends StatelessWidget {
  HomePageScreen({super.key});
  Product product = Product(
    ProductId: 3,
    CategoryId: 6,
    ProductName: 'Watermelon',
    ImagesList: [
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
    ],
    Description: 'Fresh and juicy watermelon.',
    Unit: 'kg',
    Price: 2.99,
    IsActive: true,
    CreatedDate: DateTime.now(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PrimaryItemCard(product: product, count: 3),
          CheckoutItemCard(product: product, count: 3),
          FavouriteItemCard(product: product),
        ],
      ),
    );
  }
}
