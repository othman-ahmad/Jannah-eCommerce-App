import 'package:jannah/features/favourites/data/favourite_model.dart';

enum FavouritesStatus { initial, loading, success, failure }

class FavouritesState {
  final FavouritesStatus status;
  final List<Favourite> favourites;
  final Set<int> pendingProductIds;
  final String? errorMessage;

  const FavouritesState({
    this.status = FavouritesStatus.initial,
    this.favourites = const [],
    this.pendingProductIds = const {},
    this.errorMessage,
  });

  bool isFavourite(int productId) {
    return favourites.any((favourite) => favourite.productId == productId);
  }

  bool isPending(int productId) {
    return pendingProductIds.contains(productId);
  }

  Favourite? favouriteForProduct(int productId) {
    for (final favourite in favourites) {
      if (favourite.productId == productId) {
        return favourite;
      }
    }

    return null;
  }

  FavouritesState copyWith({
    FavouritesStatus? status,
    List<Favourite>? favourites,
    Set<int>? pendingProductIds,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return FavouritesState(
      status: status ?? this.status,
      favourites: favourites ?? this.favourites,
      pendingProductIds: pendingProductIds ?? this.pendingProductIds,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}
