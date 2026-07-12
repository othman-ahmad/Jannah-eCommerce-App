import 'package:jannah/features/home_page/data/promotion_model.dart';

abstract class PromotionsRepository {
  Future<List<Promotion>> fetchPromotions();
}
