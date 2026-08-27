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
  Future<List<Favourite>> getFavourites() async {
    if (isGuest) {
      return localDataSource.fetchFavourites();
    }

    await _syncGuestFavouritesToUser();
    return remoteDataSource.fetchFavourites();
  }

  @override
  Future<Favourite> addToFavourites({required int productId}) {
    if (isGuest) {
      return localDataSource.addToFavourites(productId: productId);
    }

    return remoteDataSource.addToFavourites(productId: productId);
  }

  @override
  Future<void> removeFromFavourites({required int productId, int? likeId}) {
    if (isGuest) {
      return localDataSource.removeFromFavourites(
        productId: productId,
        likeId: likeId,
      );
    }

    return remoteDataSource.removeFromFavourites(
      productId: productId,
      likeId: likeId,
    );
  }

  Future<void> _syncGuestFavouritesToUser() async {
    if (_hasSyncedGuestFavourites) {
      return;
    }

    _hasSyncedGuestFavourites = true;
    final favourites = await localDataSource.readFavouritesForSync();

    if (favourites.isEmpty) {
      return;
    }

    for (final favourite in favourites) {
      await remoteDataSource.addToFavourites(productId: favourite.productId);
    }

    await localDataSource.clear();
  }
}
