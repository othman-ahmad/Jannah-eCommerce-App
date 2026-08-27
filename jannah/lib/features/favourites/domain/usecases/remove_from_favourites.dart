import 'package:jannah/features/favourites/domain/favourites_repository.dart';

class RemoveFromFavourites {
  final FavouritesRepository repository;

  const RemoveFromFavourites(this.repository);

  Future<void> call({required int productId, int? likeId}) {
    return repository.removeFromFavourites(
      productId: productId,
      likeId: likeId,
    );
  }
}
