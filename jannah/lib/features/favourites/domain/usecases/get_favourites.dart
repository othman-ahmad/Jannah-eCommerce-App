import 'package:jannah/features/favourites/data/favourite_model.dart';
import 'package:jannah/features/favourites/domain/favourites_repository.dart';

class GetFavourites {
  final FavouritesRepository repository;

  const GetFavourites(this.repository);

  Future<List<Favourite>> call({required int userId}) {
    return repository.getFavourites(userId: userId);
  }
}
