import 'package:flutter/material.dart';
import 'package:jannah/features/products/data/item_model.dart';
import 'package:jannah/features/products/presentation/checkout_item_card.dart';
import 'package:jannah/features/products/presentation/favourite_item_card.dart';
import 'package:jannah/features/products/presentation/primary_item_card.dart';

class HomePageScreen extends StatelessWidget {
  HomePageScreen({super.key});
  Product product = Product(
    productId: 1,
    categoryId: 1,
    productName: 'Watermelon Fresh and Juicy from Local Farms',
    imagesList: [
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
    ],
    description:
        'Watermelon is a refreshing and hydrating fruit that is perfect for hot summer days. It is low in calories and high in vitamins A and C, making it a healthy choice for snacking or adding to salads. Watermelon is also rich in antioxidants, which can help protect your cells from damage and reduce inflammation in the body.',
    unit: 'kg',
    price: 2.89,
    isActive: true,
    createdDate: DateTime.now(),
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
