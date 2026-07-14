class AppUser {
  int userId;
  String name;
  String? email;
  String? phone;
  String? profileImage;
  DateTime? createdAt;

  AppUser({
    required this.userId,
    required this.name,
    this.email,
    this.phone,
    this.profileImage,
    this.createdAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      userId: json['user_id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'],
      profileImage: json['profile_image'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'profile_image': profileImage,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  AppUser copyWith({
    int? userId,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    DateTime? createdAt,
    bool clearEmail = false,
    bool clearPhone = false,
    bool clearProfileImage = false,
    bool clearCreatedAt = false,
  }) {
    return AppUser(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: clearEmail ? null : email ?? this.email,
      phone: clearPhone ? null : phone ?? this.phone,
      profileImage: clearProfileImage
          ? null
          : profileImage ?? this.profileImage,
      createdAt: clearCreatedAt ? null : createdAt ?? this.createdAt,
    );
  }
}
