import 'package:jannah/features/favourites/data/favourite_model.dart';
import 'package:jannah/features/favourites/data/favourites_remote_data_source.dart';
import 'package:jannah/features/favourites/data/guest_favourites_local_data_source.dart';
import 'package:jannah/features/favourites/domain/favourites_repository.dart';

class FavouritesRepositoryImpl implements FavouritesRepository {
  final FavouritesRemoteDataSource remoteDataSource;
  final GuestFavouritesLocalDataSource localDataSource;
  final bool isGuest;
  bool _hasSyncedGuestFavourites = false;

  FavouritesRepositoryImpl({
    required this.remoteDataSource,
    GuestFavouritesLocalDataSource? localDataSource,
    this.isGuest = false,
  }) : localDataSource = localDataSource ?? GuestFavouritesLocalDataSource();

  @override
  Future<List<Favourite>> getFavourites({required int userId}) async {
    if (isGuest) {
      return localDataSource.fetchFavourites(userId: userId);
    }

    await _syncGuestFavouritesToUser(userId);
    return remoteDataSource.fetchFavourites(userId: userId);
  }

  @override
  Future<Favourite> addToFavourites({
    required int userId,
    required int productId,
  }) {
    if (isGuest) {
      return localDataSource.addToFavourites(
        userId: userId,
        productId: productId,
      );
    }

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
    if (isGuest) {
      return localDataSource.removeFromFavourites(
        userId: userId,
        productId: productId,
        likeId: likeId,
      );
    }

    return remoteDataSource.removeFromFavourites(
      userId: userId,
      productId: productId,
      likeId: likeId,
    );
  }

  Future<void> _syncGuestFavouritesToUser(int userId) async {
    if (_hasSyncedGuestFavourites) {
      return;
    }

    _hasSyncedGuestFavourites = true;
    final favourites = await localDataSource.readFavouritesForSync();

    if (favourites.isEmpty) {
      return;
    }

    for (final favourite in favourites) {
      await remoteDataSource.addToFavourites(
        userId: userId,
        productId: favourite.productId,
      );
    }

    await localDataSource.clear();
  }
}
