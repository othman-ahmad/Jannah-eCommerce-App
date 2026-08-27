import 'package:hive_flutter/hive_flutter.dart';
import 'package:jannah/core/local/app_preferences.dart';
import 'package:jannah/features/favourites/data/favourite_model.dart';
import 'package:jannah/features/favourites/data/favourites_remote_data_source.dart';

class GuestFavouritesLocalDataSource implements FavouritesRemoteDataSource {
  static const guestUserId = 0;

  final Box<dynamic> _box;

  GuestFavouritesLocalDataSource({Box<dynamic>? box})
    : _box = box ?? Hive.box<dynamic>(AppPreferences.guestFavouritesBoxName);

  @override
  Future<List<Favourite>> fetchFavourites() async {
    return _readFavourites();
  }

  @override
  Future<Favourite> addToFavourites({required int productId}) async {
    final favourites = _readFavourites();
    final existing = favourites.where(
      (favourite) => favourite.productId == productId,
    );

    if (existing.isNotEmpty) {
      return existing.first;
    }

    final favourite = Favourite(
      likeId: await _nextLikeId(),
      userId: guestUserId,
      productId: productId,
      date: DateTime.now(),
    );

    await _saveFavourites([...favourites, favourite]);
    return favourite;
  }

  @override
  Future<void> removeFromFavourites({
    required int productId,
    int? likeId,
  }) async {
    final favourites = _readFavourites()
        .where((favourite) => favourite.productId != productId)
        .toList(growable: false);

    await _saveFavourites(favourites);
  }

  Future<List<Favourite>> readFavouritesForSync() async {
    return _readFavourites();
  }

  Future<void> clear() async {
    await _saveFavourites(const []);
  }

  Future<int> _nextLikeId() async {
    final nextId =
        _box.get(AppPreferences.guestFavouritesNextLikeIdKey, defaultValue: 1)
            as int;
    await _box.put(AppPreferences.guestFavouritesNextLikeIdKey, nextId + 1);
    return nextId;
  }

  List<Favourite> _readFavourites() {
    final rawFavourites =
        _box.get(AppPreferences.guestFavouritesKey, defaultValue: <dynamic>[])
            as List<dynamic>;

    return rawFavourites.whereType<Map<dynamic, dynamic>>().map((rawFavourite) {
      return Favourite.fromJson(Map<String, dynamic>.from(rawFavourite));
    }).toList();
  }

  Future<void> _saveFavourites(List<Favourite> favourites) async {
    await _box.put(
      AppPreferences.guestFavouritesKey,
      favourites.map((favourite) => favourite.toJson()).toList(growable: false),
    );
    await _box.flush();
  }
}
