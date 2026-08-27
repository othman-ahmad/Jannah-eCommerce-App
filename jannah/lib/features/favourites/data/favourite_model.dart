class Favourite {
  final int likeId;
  final int userId;
  final int productId;
  final DateTime date;

  const Favourite({
    required this.likeId,
    required this.userId,
    required this.productId,
    required this.date,
  });

  factory Favourite.fromJson(Map<String, dynamic> json) {
    return Favourite(
      likeId: _readInt(json, const [
        'favoriteId',
        'FavoriteId',
        'favorite_id',
        'favouriteId',
        'FavouriteId',
        'favourite_id',
        'likeId',
        'LikeId',
        'like_id',
        'id',
      ]),
      userId: _readInt(json, const ['userId', 'UserId', 'user_id']),
      productId: _readInt(json, const ['productId', 'ProductId', 'product_id']),
      date: _readDateTime(json, const [
        'date',
        'Date',
        'createdDate',
        'CreatedDate',
        'created_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'LikeId': likeId,
      'UserId': userId,
      'ProductId': productId,
      'Date': date.toIso8601String(),
    };
  }

  static int _readInt(Map<String, dynamic> json, List<String> keys) {
    final value = _readValue(json, keys);
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  static DateTime _readDateTime(Map<String, dynamic> json, List<String> keys) {
    final value = _readValue(json, keys);
    if (value is DateTime) {
      return value;
    }
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }

  static Object? _readValue(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      if (json.containsKey(key)) {
        return json[key];
      }
    }
    return null;
  }
}
