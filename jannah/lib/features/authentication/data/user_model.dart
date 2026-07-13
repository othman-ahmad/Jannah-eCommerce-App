class User {
  final String id;
  final String name;
  final String? email;
  final String? phoneNumber;
  final String? profileImageUrl;

  User({
    required this.id,
    required this.name,
    this.email,
    this.phoneNumber,
    this.profileImageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'isActive': true,
      'createdDate': DateTime.now().toIso8601String(),
    };
  }
}
