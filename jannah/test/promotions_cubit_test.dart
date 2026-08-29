import 'package:flutter_test/flutter_test.dart';
import 'package:jannah/features/home_page/data/promotion_model.dart';
import 'package:jannah/features/home_page/domain/promotions_repository.dart';
import 'package:jannah/features/home_page/domain/usecases/get_promotions.dart';
import 'package:jannah/features/home_page/presentation/cubit/promotions_cubit.dart';

class RecordingPromotionsRepository implements PromotionsRepository {
  int fetchCalls = 0;

  @override
  Future<List<Promotion>> fetchPromotions() async {
    fetchCalls++;
    return [
      Promotion(
        promotionId: 1,
        categoryId: 2,
        title: 'Summer Sale',
        description: '20% off',
        imageUrl: 'https://example.com/promo.jpg',
        discountPercentage: 20,
        startDate: DateTime.now().subtract(const Duration(days: 1)),
        endDate: DateTime.now().add(const Duration(days: 7)),
      ),
    ];
  }
}

void main() {
  group('PromotionsCubit', () {
    test('does not refetch promotions when already loaded', () async {
      final repository = RecordingPromotionsRepository();
      final cubit = PromotionsCubit(getPromotions: GetPromotions(repository));

      await cubit.loadPromotions();
      await cubit.loadPromotions();

      expect(repository.fetchCalls, 1);
    });
  });
}
