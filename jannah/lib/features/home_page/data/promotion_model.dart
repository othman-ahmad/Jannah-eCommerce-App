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
      promotionId: json['promotionId'],
      title: json['title'],
      description: json['description'],
      categoryId: json['categoryId'],
      discountPercentage: json['discountPercentage'].toDouble(),
      imageUrl: json['imageUrl'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }
}
