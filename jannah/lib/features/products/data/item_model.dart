class Product {
  final int productId;
  final int categoryId;
  final String productName;
  final List<String> imagesList;
  final String description;
  final String unit;
  double price;
  final DateTime createdDate;

  Product({
    required this.productId,
    required this.categoryId,
    required this.productName,
    required this.imagesList,
    required this.description,
    required this.unit,
    required this.price,
    required this.createdDate,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: _asInt(json['ProductId'] ?? json['productId']),
      categoryId: _asInt(json['categoryId'] ?? json['categoryId']),
      productName: _asString(json['ProductName'] ?? json['productName']),
      imagesList: _asStringList(json['ImagesList'] ?? json['imagesList']),
      description: _asString(
        json['ProductDescription'] ??
            json['productDescription'] ??
            json['description'],
      ),
      unit: _asString(json['Unit'] ?? json['unit']),
      price: _asDouble(json['Price'] ?? json['price']),
      createdDate: _asDateTime(json['CreatedDate'] ?? json['createdDate']),
    );
  }

  static int _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.parse(value.toString());
  }

  static double _asDouble(Object? value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.parse(value.toString());
  }

  static String _asString(Object? value) {
    return value?.toString() ?? '';
  }

  static DateTime _asDateTime(Object? value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    return DateTime.parse(value.toString());
  }

  static List<String> _asStringList(Object? value) {
    if (value is List) {
      return value.map((image) => image.toString()).toList();
    }

    if (value is String && value.trim().isNotEmpty) {
      return value
          .split(',')
          .map((image) => image.trim())
          .where((image) => image.isNotEmpty)
          .toList();
    }

    return const [];
  }
}
