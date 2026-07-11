import 'package:jannah/features/favourites/data/favourite_model.dart';
import 'package:jannah/features/favourites/domain/favourites_repository.dart';

class AddToFavourites {
  final FavouritesRepository repository;

  const AddToFavourites(this.repository);

  Future<Favourite> call({required int userId, required int productId}) {
    return repository.addToFavourites(userId: userId, productId: productId);
  }
}
