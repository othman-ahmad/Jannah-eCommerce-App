import 'package:jannah/features/favourites/data/favourite_model.dart';

abstract class FavouritesRemoteDataSource {
  Future<List<Favourite>> fetchFavourites({required int userId});

  Future<Favourite> addToFavourites({
    required int userId,
    required int productId,
  });

  Future<void> removeFromFavourites({
    required int userId,
    required int productId,
    int? likeId,
  });
}

class InMemoryFavouritesRemoteDataSource implements FavouritesRemoteDataSource {
  final List<Favourite> _favourites = [];
  int _nextLikeId = 1;

  @override
  Future<List<Favourite>> fetchFavourites({required int userId}) async {
    return _favourites
        .where((favourite) => favourite.userId == userId)
        .toList(growable: false);
  }

  @override
  Future<Favourite> addToFavourites({
    required int userId,
    required int productId,
  }) async {
    final existing = _favourites.where(
      (favourite) =>
          favourite.userId == userId && favourite.productId == productId,
    );

    if (existing.isNotEmpty) {
      return existing.first;
    }

    final favourite = Favourite(
      likeId: _nextLikeId++,
      userId: userId,
      productId: productId,
      date: DateTime.now(),
    );

    _favourites.add(favourite);
    return favourite;
  }

  @override
  Future<void> removeFromFavourites({
    required int userId,
    required int productId,
    int? likeId,
  }) async {
    _favourites.removeWhere(
      (favourite) =>
          favourite.userId == userId &&
          favourite.productId == productId &&
          (likeId == null || favourite.likeId == likeId),
    );
  }
}
