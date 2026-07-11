import 'package:jannah/features/favourites/data/favourite_model.dart';

abstract class FavouritesRepository {
  Future<List<Favourite>> getFavourites({required int userId});

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
