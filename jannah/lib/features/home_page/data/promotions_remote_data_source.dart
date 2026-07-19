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
        title: 'Fresh Fruits',
        description: 'Enjoy 25% OFF.',
        categoryId: 1,
        discountPercentage: 25.0,
        imageUrl: 'assets/images/eb7638a3-0399-40a8-9fcd-66981badff7a.png',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2029, 12, 31),
      ),
      Promotion(
        promotionId: 2,
        title: 'Fresh Vegetables',
        description: 'Save 20% Today.',
        categoryId: 2,
        discountPercentage: 20.0,
        imageUrl:
            'assets/images/9d461358-c286-4a54-a6c2-b25f6ae4fb81 (1)(1).png',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2029, 12, 31),
      ),
      Promotion(
        promotionId: 3,
        title: 'Leafy Greens',
        description: 'Fresh & 15% OFF.',
        categoryId: 3,
        discountPercentage: 15.0,
        imageUrl: 'assets/images/60f386bf-15dc-4410-b8d1-201b80598ba2.png',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2029, 12, 31),
      ),
      Promotion(
        promotionId: 4,
        title: 'Premium Nuts',
        description: 'Enjoy 30% OFF.',
        categoryId: 4,
        discountPercentage: 30.0,
        imageUrl: 'assets/images/9d461358-c286-4a54-a6c2-b25f6ae4fb81 (1).png',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2029, 12, 31),
      ),
    ];
  }
}
