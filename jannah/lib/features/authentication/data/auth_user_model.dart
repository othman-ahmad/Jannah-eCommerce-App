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
      userId: _readInt(json, const [
        'UserId',
        'userId',
        'id',
        'Id',
        'nameIdentifier',
      ]),
      fullName: _readString(json, const [
        'FullName',
        'fullName',
        'name',
        'Name',
      ]),
      emailOrPhone: _readString(json, const [
        'EmailOrPhone',
        'emailOrPhone',
        'email',
        'Email',
        'phone',
        'Phone',
      ]),
      token: _readString(json, const [
        'Token',
        'token',
        'accessToken',
        'access_token',
        'jwt',
      ]),
      createdDate: _readDate(json, const [
        'CreatedDate',
        'createdDate',
        'createdAt',
        'created_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserId': userId,
      'FullName': fullName,
      'EmailOrPhone': emailOrPhone,
      'Token': token,
      'CreatedDate': createdDate.toIso8601String(),
    };
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

  static DateTime _readDate(Map<String, dynamic> json, List<String> keys) {
    final value = _readValue(json, keys);
    if (value is DateTime) {
      return value;
    }
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
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
