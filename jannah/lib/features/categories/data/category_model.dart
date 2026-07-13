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
      categoryId: json['CategoryId'],
      categoryName: json['CategoryName'],
      imageUrl: json['ImageUrl'],
      description: json['Description'],
    );
  }
}
