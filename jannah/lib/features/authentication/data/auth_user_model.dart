class AuthUser {
  final int userId;
  final String fullName;
  final String emailOrPhone;
  final String passwordHash;
  final DateTime createdDate;

  AuthUser({
    required this.userId,
    required this.fullName,
    required this.emailOrPhone,
    required this.passwordHash,
    required this.createdDate,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      userId: json['UserId'],
      fullName: json['FullName'],
      emailOrPhone: json['EmailOrPhone'],
      passwordHash: json['Token'],
      createdDate: DateTime.parse(json['CreatedDate']),
    );
  }
}
