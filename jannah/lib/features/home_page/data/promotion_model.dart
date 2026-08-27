class Promotion {
  int promotionId;
  String title;
  String description;
  int categoryId;
  double discountPercentage;
  String imageUrl;
  DateTime startDate;
  DateTime endDate;

  Promotion({
    required this.promotionId,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.discountPercentage,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      promotionId: _readInt(json, const [
        'promotionId',
        'PromotionId',
        'promotion_id',
        'id',
      ]),
      title: _readString(json, const ['title', 'Title']),
      description: _readString(json, const ['description', 'Description']),
      categoryId: _readInt(json, const [
        'categoryId',
        'CategoryId',
        'category_id',
      ]),
      discountPercentage: _readDouble(json, const ['discountPercent']),
      imageUrl: _readString(json, const ['bannerImage']),
      startDate: _readDateTime(json, const [
        'startDate',
        'StartDate',
        'start_date',
      ]),
      endDate: _readDateTime(json, const ['endDate', 'EndDate', 'end_date']),
    );
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

  static double _readDouble(Map<String, dynamic> json, List<String> keys) {
    final value = _readValue(json, keys);
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value) ?? 0;
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

  static String _readString(Map<String, dynamic> json, List<String> keys) {
    return _readValue(json, keys)?.toString() ?? '';
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
