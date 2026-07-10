class Product {
  final int ProductId;
  final int CategoryId;
  final String ProductName;
  final List<String> ImagesList;
  final String Description;
  final String Unit;
  final double Price;
  final bool IsActive;
  final DateTime CreatedDate;

  Product({
    required this.ProductId,
    required this.CategoryId,
    required this.ProductName,
    required this.ImagesList,
    required this.Description,
    required this.Unit,
    required this.Price,
    required this.IsActive,
    required this.CreatedDate,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      ProductId: json['ProductId'],
      CategoryId: json['CategoryId'],
      ProductName: json['ProductName'],
      ImagesList: json['ImagesList'],
      Description: json['ProductDescription'],
      Unit: json['Unit'],
      Price: (json['Price'] as num).toDouble(),
      IsActive: json['IsActive'],
      CreatedDate: DateTime.parse(json['CreatedDate']),
    );
  }
}
