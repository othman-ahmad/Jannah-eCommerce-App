class AuthUser {
  final int userId;
  final String fullName;
  final String emailOrPhone;
  final String token;
  final DateTime createdDate;

  AuthUser({
    required this.userId,
    required this.fullName,
    required this.emailOrPhone,
    required this.token,
    required this.createdDate,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      userId: json['UserId'],
      fullName: json['FullName'],
      emailOrPhone: json['EmailOrPhone'],
      token: json['Token'],
      createdDate: DateTime.parse(json['CreatedDate']),
    );
  }
}
