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
      likeId: json['LikeId'] ?? json['likeId'] ?? json['like_id'],
      userId: json['UserId'] ?? json['userId'] ?? json['user_id'],
      productId: json['ProductId'] ?? json['productId'] ?? json['product_id'],
      date: DateTime.parse(json['Date'] ?? json['createdDate']),
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
}
