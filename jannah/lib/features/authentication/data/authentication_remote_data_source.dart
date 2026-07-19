import 'package:jannah/features/authentication/data/auth_user_model.dart';
import 'package:bcrypt/bcrypt.dart';

abstract class AuthenticationRemoteDataSource {
  String hashPassword({required String password});

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
  String hashPassword({required String password}) {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  final List<_MockAuthAccount> _accounts = [
    // _MockAuthAccount(
    //   user: AuthUser(
    //     userId: 1,
    //     fullName: 'Jannah Customer',
    //     emailOrPhone: 'customer@jannah.com',
    //     passwordHash: 'mock-token-1',
    //     createdDate: DateTime(2026, 1, 1),
    //   ),
    //   password: 'password123',
    // ),
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
          account.passwordHash == hashPassword(password: password),
    );

    if (account.isEmpty) {
      throw Exception('Invalid email or password.');
    }
    _printAccounts(_accounts);
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
      passwordHash: hashPassword(password: password),
      createdDate: DateTime.now(),
    );

    _nextUserId++;
    _accounts.add(
      _MockAuthAccount(user: user, passwordHash: user.passwordHash),
    );
    _printAccounts(_accounts);
    return user;
  }

  String _normalize(String value) {
    return value.trim().toLowerCase();
  }
}

class _MockAuthAccount {
  final AuthUser user;
  String passwordHash;

  _MockAuthAccount({required this.user, required this.passwordHash});
}

void _printAccounts(List<_MockAuthAccount> accounts) {
  print(
    '============================== Accounts ======================================',
  );
  for (var account in accounts) {
    print('User ID: ${account.user.userId}');
    print('Full Name: ${account.user.fullName}');
    print('Email/Phone: ${account.user.emailOrPhone}');
    print('Password Hash: ${account.passwordHash}');
    print('Created Date: ${account.user.createdDate}');
    print('-----------------------------');
  }
  print(
    '==============================================================================',
  );
}
