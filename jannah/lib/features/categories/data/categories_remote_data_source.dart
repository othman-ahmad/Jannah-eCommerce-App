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
        imageUrl: 'store_images/Beverages/Lemonade/Image_2.jpg',
      ),
      Category(
        categoryId: 2,
        categoryName: 'Fashion',
        description: 'Discover the latest trends in fashion.',
        imageUrl: 'store_images/Fruits/Watermelon/Image_2.jpg',
      ),
      Category(
        categoryId: 3,
        categoryName: 'Home & Kitchen',
        description: 'Find everything you need for your home and kitchen.',
        imageUrl: 'store_images/Sweets_and_Desserts/Licorice/Image_5.jpg',
      ),
      Category(
        categoryId: 4,
        categoryName: 'Books',
        description: 'Browse our collection of books across various genres.',
        imageUrl: 'store_images/Vegetables/Pumpkin/Image_2.png',
      ),
      Category(
        categoryId: 5,
        categoryName: 'Sports & Outdoors',
        description:
            'Gear up for your outdoor adventures and sports activities.',
        imageUrl: 'store_images/Vegetables/Cauliflower/Image_1.jpg',
      ),
    ];
  }
}
