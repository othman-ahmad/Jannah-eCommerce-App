import 'package:jannah/features/home_page/data/promotion_model.dart';

abstract class PromotionsRemoteDataSource {
  Future<List<Promotion>> fetchPromotions();
}

class MockPromotionsRemoteDataSource implements PromotionsRemoteDataSource {
  @override
  Future<List<Promotion>> fetchPromotions() async {
    return _mockPromotionsList();
  }

  List<Promotion> _mockPromotionsList() {
    return [
      Promotion(
        promotionId: 1,
        title: 'Summer Sale',
        description: 'Get up to 50% off on selected items!',
        categoryId: 1,
        discountPercentage: 50.0,
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
        startDate: DateTime(2024, 6, 1),
        endDate: DateTime(2029, 6, 30),
        isActive: true,
      ),
      Promotion(
        promotionId: 2,
        title: 'Winter Clearance',
        description: 'Clearance sale on winter collection!',
        categoryId: 2,
        discountPercentage: 70.0,
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
        startDate: DateTime(2024, 12, 1),
        endDate: DateTime(2029, 12, 31),
        isActive: true,
      ),
      Promotion(
        promotionId: 3,
        title: 'Black Friday Deals',
        description: 'Exclusive Black Friday discounts!',
        categoryId: 3,
        discountPercentage: 80.0,
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSehbobRiZE93GxisajT4yL3inqDJ8EI7d9iXMzPFywSA&s=10',
        startDate: DateTime(2024, 11, 29),
        endDate: DateTime(2029, 11, 30),
        isActive: true,
      ),
    ];
  }
}
