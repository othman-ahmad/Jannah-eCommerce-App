import 'package:jannah/features/home_page/data/promotion_model.dart';
import 'package:jannah/features/home_page/domain/promotions_repository.dart';

class GetPromotions {
  final PromotionsRepository repository;

  const GetPromotions(this.repository);

  Future<List<Promotion>> call() {
    return repository.fetchPromotions();
  }
}
