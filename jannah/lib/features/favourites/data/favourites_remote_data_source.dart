import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jannah/features/favourites/data/favourite_model.dart';

abstract class FavouritesRemoteDataSource {
  Future<List<Favourite>> fetchFavourites();

  Future<Favourite> addToFavourites({required int productId});

  Future<void> removeFromFavourites({required int productId, int? likeId});
}

class ApiFavouritesRemoteDataSource implements FavouritesRemoteDataSource {
  ApiFavouritesRemoteDataSource({
    http.Client? client,
    String baseUrl = 'http://192.168.1.21:5241/api/favorites',
  }) : _client = client ?? http.Client(),
       _baseUri = Uri.parse(baseUrl);

  final http.Client _client;
  final Uri _baseUri;

  @override
  Future<List<Favourite>> fetchFavourites() async {
    final response = await _client
        .get(_baseUri, headers: _jsonHeaders)
        .timeout(const Duration(seconds: 15));

    _throwIfRequestFailed(response, 'Favourites request failed');

    return _unwrapList(
      _decodeJson(response.body),
      'favorites',
    ).map(Favourite.fromJson).toList(growable: false);
  }

  @override
  Future<Favourite> addToFavourites({required int productId}) async {
    final response = await _client
        .post(
          _baseUri,
          headers: _jsonHeaders,
          body: jsonEncode({'ProductId': productId}),
        )
        .timeout(const Duration(seconds: 15));

    _throwIfRequestFailed(response, 'Add favourite request failed');

    final decoded = _decodeJson(response.body);
    if (decoded != null) {
      final favouriteJson = _tryUnwrapObject(decoded, 'favorite');
      if (favouriteJson != null) {
        final favourite = Favourite.fromJson(favouriteJson);
        if (favourite.likeId != 0) {
          return favourite;
        }
      }
    }

    final favourites = await fetchFavourites();
    return favourites.firstWhere(
      (favourite) => favourite.productId == productId,
      orElse: () => Favourite(
        likeId: 0,
        userId: 0,
        productId: productId,
        date: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> removeFromFavourites({
    required int productId,
    int? likeId,
  }) async {
    final favouriteId = likeId ?? await _findFavouriteId(productId);

    if (favouriteId == null || favouriteId == 0) {
      return;
    }

    final response = await _client
        .delete(_uriFor('$favouriteId'), headers: _jsonHeaders)
        .timeout(const Duration(seconds: 15));

    _throwIfRequestFailed(response, 'Remove favourite request failed');
  }

  Future<int?> _findFavouriteId(int productId) async {
    final favourites = await fetchFavourites();
    for (final favourite in favourites) {
      if (favourite.productId == productId) {
        return favourite.likeId;
      }
    }
    return null;
  }

  Uri _uriFor(String pathSegment) {
    final path = _baseUri.path.endsWith('/')
        ? '${_baseUri.path}$pathSegment'
        : '${_baseUri.path}/$pathSegment';

    return _baseUri.replace(path: path);
  }

  Object? _decodeJson(String responseBody) {
    if (responseBody.trim().isEmpty) {
      return null;
    }

    return jsonDecode(responseBody);
  }

  Map<String, dynamic>? _tryUnwrapObject(Object? decoded, String objectName) {
    if (decoded is! Map) {
      return null;
    }

    final json = Map<String, dynamic>.from(decoded);
    for (final key in [
      objectName,
      _capitalize(objectName),
      'favourite',
      'Favourite',
      'data',
      'Data',
      'result',
      'Result',
    ]) {
      final value = json[key];
      if (value is Map) {
        return Map<String, dynamic>.from(value);
      }
    }

    return json;
  }

  List<Map<String, dynamic>> _unwrapList(Object? decoded, String listName) {
    final Object? list = decoded is Map
        ? decoded[listName] ??
              decoded[_capitalize(listName)] ??
              decoded['favourites'] ??
              decoded['Favourites'] ??
              decoded['items'] ??
              decoded['Items'] ??
              decoded['data'] ??
              decoded['Data'] ??
              decoded['result'] ??
              decoded['Result']
        : decoded;

    if (list is List) {
      return list
          .whereType<Map>()
          .map((itemJson) => Map<String, dynamic>.from(itemJson))
          .toList(growable: false);
    }

    throw FormatException('Expected a $listName list from the API.');
  }

  void _throwIfRequestFailed(http.Response response, String fallbackMessage) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    throw Exception(
      _extractErrorMessage(response.body) ??
          '$fallbackMessage (${response.statusCode}).',
    );
  }

  String? _extractErrorMessage(String responseBody) {
    try {
      final decoded = _decodeJson(responseBody);
      if (decoded is! Map) {
        return responseBody.trim().isEmpty ? null : responseBody;
      }

      final json = Map<String, dynamic>.from(decoded);
      for (final key in const [
        'message',
        'Message',
        'error',
        'Error',
        'title',
      ]) {
        final value = json[key];
        if (value is String && value.isNotEmpty) {
          return value;
        }
      }

      final errors = json['errors'];
      if (errors is Map && errors.isNotEmpty) {
        return errors.values
            .expand((value) => value is List ? value : [value])
            .map((value) => value.toString())
            .join('\n');
      }
    } catch (_) {
      return responseBody.trim().isEmpty ? null : responseBody;
    }

    return null;
  }

  String _capitalize(String value) {
    if (value.isEmpty) {
      return value;
    }

    return '${value[0].toUpperCase()}${value.substring(1)}';
  }

  static const _jsonHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };
}

class InMemoryFavouritesRemoteDataSource implements FavouritesRemoteDataSource {
  final List<Favourite> _favourites = [];
  int _nextLikeId = 1;
  static const _mockUserId = 1;

  @override
  Future<List<Favourite>> fetchFavourites() async {
    return _favourites
        .where((favourite) => favourite.userId == _mockUserId)
        .toList(growable: false);
  }

  @override
  Future<Favourite> addToFavourites({required int productId}) async {
    final existing = _favourites.where(
      (favourite) =>
          favourite.userId == _mockUserId && favourite.productId == productId,
    );

    if (existing.isNotEmpty) {
      return existing.first;
    }

    final favourite = Favourite(
      likeId: _nextLikeId++,
      userId: _mockUserId,
      productId: productId,
      date: DateTime.now(),
    );

    _favourites.add(favourite);
    return favourite;
  }

  @override
  Future<void> removeFromFavourites({
    required int productId,
    int? likeId,
  }) async {
    _favourites.removeWhere(
      (favourite) =>
          favourite.userId == _mockUserId &&
          favourite.productId == productId &&
          (likeId == null || favourite.likeId == likeId),
    );
  }
}
