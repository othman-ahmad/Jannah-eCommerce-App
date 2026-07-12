import 'package:jannah/features/products/data/item_model.dart';

abstract class ProductsRemoteDataSource {
  Future<Product> fetchProductById({required int productId});

  Future<List<Product>> fetchProductsByCategoryId({required int categoryId});

  Future<List<Product>> fetchProductsByName({required String productName});
}

class MockProductsRemoteDataSource implements ProductsRemoteDataSource {
  @override
  Future<Product> fetchProductById({required int productId}) async {
    return _mockProductsList()
        .where((product) => product.productId == productId)
        .first;
  }

  @override
  Future<List<Product>> fetchProductsByCategoryId({
    required int categoryId,
  }) async {
    return _mockProductsList();
  }

  @override
  Future<List<Product>> fetchProductsByName({
    required String productName,
  }) async {
    return _mockProductsList()
        .where(
          (product) => product.productName.toLowerCase().contains(
            productName.toLowerCase(),
          ),
        )
        .toList();
  }

  List<Product> _mockProductsList() {
    return [
      Product(
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
      ),
      Product(
        // mango
        productId: 2,
        categoryId: 2,
        productName: 'Mango Fresh and Juicy from Local Farms',
        imagesList: [
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
        ],
        description:
            'Mango is a tropical fruit that is known for its sweet and juicy flavor. It is rich in vitamins A and C, as well as fiber and antioxidants, making it a healthy choice for snacking or adding to smoothies and desserts. Mangoes are also versatile in cooking, as they can be used in both sweet and savory dishes.',
        unit: 'kg',
        price: 3.49,
        isActive: true,
        createdDate: DateTime.now(),
      ),
      Product(
        // banana
        productId: 3,
        categoryId: 2,
        productName: 'Banana Fresh and Juicy from Local Farms',
        imagesList: [
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
        ],
        description:
            'Bananas are a popular fruit that are known for their sweet taste and convenient portability. They are rich in potassium, vitamin C, and dietary fiber, making them a healthy choice for snacking or adding to smoothies and desserts. Bananas are also versatile in cooking, as they can be used in both sweet and savory dishes.',
        unit: 'kg',
        price: 1.99,
        isActive: true,
        createdDate: DateTime.now(),
      ),
      Product(
        // apple
        productId: 4,
        categoryId: 3,
        productName: 'Apple Fresh and Juicy from Local Farms',
        imagesList: [
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
        ],
        description:
            'Apples are a popular fruit that are known for their crisp texture and sweet-tart flavor. They are rich in fiber, vitamin C, and antioxidants, making them a healthy choice for snacking or adding to salads and desserts. Apples are also versatile in cooking, as they can be used in both sweet and savory dishes.',
        unit: 'kg',
        price: 2.49,
        isActive: true,
        createdDate: DateTime.now(),
      ),
      Product(
        // orange
        productId: 5,
        categoryId: 3,
        productName: 'Orange Fresh and Juicy from Local Farms',
        imagesList: [
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
        ],
        description:
            'Oranges are a popular citrus fruit that are known for their sweet and tangy flavor',
        unit: 'kg',
        price: 2.99,
        isActive: true,
        createdDate: DateTime.now(),
      ),
      Product(
        productId: 6,
        categoryId: 3,
        productName: 'Strawberry Fresh and Juicy from Local Farms',
        imagesList: [
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
        ],
        description:
            'Strawberries are sweet, juicy, and packed with vitamin C. They are ideal for snacking, smoothies, and desserts, and add a bright, fresh flavor to any meal.',
        unit: 'kg',
        price: 4.29,
        isActive: true,
        createdDate: DateTime.now(),
      ),
    ];
  }
}
