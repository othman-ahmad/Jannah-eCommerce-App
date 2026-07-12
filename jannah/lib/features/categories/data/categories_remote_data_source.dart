import 'package:jannah/features/categories/data/category_model.dart';

abstract class CategoriesRemoteDataSource {
  Future<List<Category>> fetchCategories();
}

class MockCategoriesRemoteDataSource implements CategoriesRemoteDataSource {
  @override
  Future<List<Category>> fetchCategories() async {
    return _mockCategoriesList();
  }

  List<Category> _mockCategoriesList() {
    return [
      Category(
        categoryId: 1,
        categoryName: 'Electronics',
        description: 'Explore our wide range of electronics products.',
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
        isActive: true,
      ),
      Category(
        categoryId: 2,
        categoryName: 'Fashion',
        description: 'Discover the latest trends in fashion.',
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
        isActive: true,
      ),
      Category(
        categoryId: 3,
        categoryName: 'Home & Kitchen',
        description: 'Find everything you need for your home and kitchen.',
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
        isActive: true,
      ),
      Category(
        categoryId: 4,
        categoryName: 'Books',
        description: 'Browse our collection of books across various genres.',
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
        isActive: true,
      ),
      Category(
        categoryId: 5,
        categoryName: 'Sports & Outdoors',
        description:
            'Gear up for your outdoor adventures and sports activities.',
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
        isActive: true,
      ),
      Category(
        categoryId: 6,
        categoryName: 'Beauty & Personal Care',
        description: 'Enhance your beauty and personal care routine.',
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
        isActive: true,
      ),
      Category(
        categoryId: 7,
        categoryName: 'Toys & Games',
        description: 'Find fun and engaging toys and games for all ages.',
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
        isActive: true,
      ),
      Category(
        categoryId: 8,
        categoryName: 'Health & Wellness',
        description: 'Explore products to support your health and wellness.',
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
        isActive: true,
      ),
    ];
  }
}
