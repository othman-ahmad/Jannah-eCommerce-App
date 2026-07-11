import 'package:jannah/features/favourites/data/favourite_model.dart';
import 'package:jannah/features/favourites/data/favourites_remote_data_source.dart';
import 'package:jannah/features/favourites/domain/favourites_repository.dart';

class FavouritesRepositoryImpl implements FavouritesRepository {
  final FavouritesRemoteDataSource remoteDataSource;

  const FavouritesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Favourite>> getFavourites({required int userId}) {
    return remoteDataSource.fetchFavourites(userId: userId);
  }

  @override
  Future<Favourite> addToFavourites({
    required int userId,
    required int productId,
  }) {
    return remoteDataSource.addToFavourites(
      userId: userId,
      productId: productId,
    );
  }

  @override
  Future<void> removeFromFavourites({
    required int userId,
    required int productId,
    int? likeId,
  }) {
    return remoteDataSource.removeFromFavourites(
      userId: userId,
      productId: productId,
      likeId: likeId,
    );
  }
}
