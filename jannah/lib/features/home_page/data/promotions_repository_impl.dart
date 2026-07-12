import 'package:jannah/features/home_page/data/promotion_model.dart';
import 'package:jannah/features/home_page/data/promotions_remote_data_source.dart';
import 'package:jannah/features/home_page/domain/promotions_repository.dart';

class PromotionsRepositoryImpl implements PromotionsRepository {
  final PromotionsRemoteDataSource remoteDataSource;

  const PromotionsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Promotion>> fetchPromotions() {
    return remoteDataSource.fetchPromotions();
  }
}
