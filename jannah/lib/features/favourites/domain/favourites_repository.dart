import 'package:jannah/features/favourites/data/favourite_model.dart';

abstract class FavouritesRepository {
  Future<List<Favourite>> getFavourites();

  Future<Favourite> addToFavourites({required int productId});

  Future<void> removeFromFavourites({required int productId, int? likeId});
}
