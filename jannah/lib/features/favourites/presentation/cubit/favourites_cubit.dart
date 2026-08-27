import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jannah/features/favourites/domain/usecases/add_to_favourites.dart';
import 'package:jannah/features/favourites/domain/usecases/get_favourites.dart';
import 'package:jannah/features/favourites/domain/usecases/remove_from_favourites.dart';
import 'package:jannah/features/favourites/presentation/cubit/favourites_state.dart';

class FavouritesCubit extends Cubit<FavouritesState> {
  final GetFavourites getFavourites;
  final AddToFavourites addToFavourites;
  final RemoveFromFavourites removeFromFavourites;

  int currentUserId;

  FavouritesCubit({
    required this.getFavourites,
    required this.addToFavourites,
    required this.removeFromFavourites,
    required this.currentUserId,
  }) : super(const FavouritesState());

  Future<void> loadFavourites() async {
    emit(
      state.copyWith(status: FavouritesStatus.loading, clearErrorMessage: true),
    );

    try {
      final favourites = await getFavourites();
      emit(
        state.copyWith(
          status: FavouritesStatus.success,
          favourites: favourites,
          clearErrorMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FavouritesStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> toggleFavourite(int productId) async {
    if (state.isPending(productId)) {
      return;
    }

    if (state.isFavourite(productId)) {
      await removeFavourite(productId);
    } else {
      await addFavourite(productId);
    }
  }

  Future<void> addFavourite(int productId) async {
    _setProductPending(productId, isPending: true);

    try {
      final favourite = await addToFavourites(productId: productId);

      final withoutDuplicate = state.favourites
          .where((item) => item.productId != productId)
          .toList();

      emit(
        state.copyWith(
          status: FavouritesStatus.success,
          favourites: [...withoutDuplicate, favourite],
          pendingProductIds: _withoutPendingProduct(productId),
          clearErrorMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FavouritesStatus.failure,
          pendingProductIds: _withoutPendingProduct(productId),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> removeFavourite(int productId) async {
    final favourite = state.favouriteForProduct(productId);
    _setProductPending(productId, isPending: true);

    try {
      await removeFromFavourites(
        productId: productId,
        likeId: favourite?.likeId,
      );

      emit(
        state.copyWith(
          status: FavouritesStatus.success,
          favourites: state.favourites
              .where((item) => item.productId != productId)
              .toList(),
          pendingProductIds: _withoutPendingProduct(productId),
          clearErrorMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FavouritesStatus.failure,
          pendingProductIds: _withoutPendingProduct(productId),
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _setProductPending(int productId, {required bool isPending}) {
    final pendingProductIds = Set<int>.of(state.pendingProductIds);

    if (isPending) {
      pendingProductIds.add(productId);
    } else {
      pendingProductIds.remove(productId);
    }

    emit(state.copyWith(pendingProductIds: pendingProductIds));
  }

  Set<int> _withoutPendingProduct(int productId) {
    return Set<int>.of(state.pendingProductIds)..remove(productId);
  }
}
