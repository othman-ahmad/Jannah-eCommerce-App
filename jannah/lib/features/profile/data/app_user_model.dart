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
      userId: _readInt(json, const ['user_id', 'userId', 'UserId', 'id', 'Id']),
      name: _readString(json, const ['name', 'Name', 'fullName', 'FullName']),
      email: _readNullableString(json, const ['email', 'Email']),
      phone: _readNullableString(json, const ['phone', 'Phone']),
      profileImage: _readNullableString(json, const [
        'profile_image',
        'profileImage',
        'ProfileImage',
      ]),
      createdAt: _readNullableDate(json, const [
        'created_at',
        'createdAt',
        'CreatedAt',
        'createdDate',
        'CreatedDate',
      ]),
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

  static String _readString(Map<String, dynamic> json, List<String> keys) {
    final value = _readValue(json, keys);
    return value?.toString() ?? '';
  }

  static String? _readNullableString(
    Map<String, dynamic> json,
    List<String> keys,
  ) {
    final value = _readValue(json, keys);
    final stringValue = value?.toString();
    return stringValue == null || stringValue.isEmpty ? null : stringValue;
  }

  static DateTime? _readNullableDate(
    Map<String, dynamic> json,
    List<String> keys,
  ) {
    final value = _readValue(json, keys);
    if (value is DateTime) {
      return value;
    }
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
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
