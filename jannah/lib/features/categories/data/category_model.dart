class Category {
  int categoryId;
  String categoryName;
  String imageUrl;
  String description;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.imageUrl,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: _asInt(
        json['CategoryId'] ?? json['categoryId'] ?? json['id'],
      ),
      categoryName: _asString(
        json['CategoryName'] ?? json['categoryName'] ?? json['name'],
      ),
      imageUrl: _asString(
        json['ImageUrl'] ?? json['imageUrl'] ?? json['image'] ?? json['icon'],
      ),
      description: _asString(json['Description'] ?? json['description']),
    );
  }

  static int _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _asString(Object? value) {
    return value?.toString() ?? '';
  }
}
