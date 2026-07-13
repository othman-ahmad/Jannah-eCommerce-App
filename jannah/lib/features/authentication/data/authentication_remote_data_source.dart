import 'package:jannah/features/authentication/data/auth_user_model.dart';

abstract class AuthenticationRemoteDataSource {
  Future<AuthUser> login({
    required String emailOrPhone,
    required String password,
  });

  Future<AuthUser> register({
    required String fullName,
    required String emailOrPhone,
    required String password,
  });
}

class MockAuthenticationRemoteDataSource
    implements AuthenticationRemoteDataSource {
  final List<_MockAuthAccount> _accounts = [
    _MockAuthAccount(
      user: AuthUser(
        userId: 1,
        fullName: 'Jannah Customer',
        emailOrPhone: 'customer@jannah.com',
        token: 'mock-token-1',
        createdDate: DateTime(2026, 1, 1),
      ),
      password: 'password123',
    ),
  ];

  int _nextUserId = 2;

  @override
  Future<AuthUser> login({
    required String emailOrPhone,
    required String password,
  }) async {
    final normalizedIdentifier = _normalize(emailOrPhone);

    final account = _accounts.where(
      (account) =>
          _normalize(account.user.emailOrPhone) == normalizedIdentifier &&
          account.password == password,
    );

    if (account.isEmpty) {
      throw Exception('Invalid email or password.');
    }

    return account.first.user;
  }

  @override
  Future<AuthUser> register({
    required String fullName,
    required String emailOrPhone,
    required String password,
  }) async {
    final normalizedIdentifier = _normalize(emailOrPhone);
    final alreadyExists = _accounts.any(
      (account) =>
          _normalize(account.user.emailOrPhone) == normalizedIdentifier,
    );

    if (alreadyExists) {
      throw Exception('This account already exists.');
    }

    final user = AuthUser(
      userId: _nextUserId,
      fullName: fullName,
      emailOrPhone: emailOrPhone,
      token: 'mock-token-$_nextUserId',
      createdDate: DateTime.now(),
    );

    _nextUserId++;
    _accounts.add(_MockAuthAccount(user: user, password: password));

    return user;
  }

  String _normalize(String value) {
    return value.trim().toLowerCase();
  }
}

class _MockAuthAccount {
  final AuthUser user;
  String password;

  _MockAuthAccount({required this.user, required this.password});
}
