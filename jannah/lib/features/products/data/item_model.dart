class Product {
  final int productId;
  final int categoryId;
  final String productName;
  final List<String> imagesList;
  final String description;
  final String unit;
  final double price;
  final bool isActive;
  final DateTime createdDate;

  Product({
    required this.productId,
    required this.categoryId,
    required this.productName,
    required this.imagesList,
    required this.description,
    required this.unit,
    required this.price,
    required this.isActive,
    required this.createdDate,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['ProductId'],
      categoryId: json['CategoryId'],
      productName: json['ProductName'],
      imagesList: json['ImagesList'],
      description: json['ProductDescription'],
      unit: json['Unit'],
      price: (json['Price'] as num).toDouble(),
      isActive: json['IsActive'],
      createdDate: DateTime.parse(json['CreatedDate']),
    );
  }
}
