import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jannah/core/local/app_preferences.dart';
import 'package:jannah/features/authentication/data/auth_user_model.dart';

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
  final Box<dynamic> _box;
  final List<_MockAuthAccount> _accounts;
  int _nextUserId;

  factory MockAuthenticationRemoteDataSource({Box<dynamic>? box}) {
    final resolvedBox = box ?? Hive.box<dynamic>(AppPreferences.authBoxName);

    return MockAuthenticationRemoteDataSource._(
      box: resolvedBox,
      accounts: _readAccounts(resolvedBox),
      nextUserId: _readNextUserId(resolvedBox),
    );
  }

  MockAuthenticationRemoteDataSource._({
    required Box<dynamic> box,
    required List<_MockAuthAccount> accounts,
    required int nextUserId,
  }) : _box = box,
       _accounts = accounts,
       _nextUserId = nextUserId;

  @override
  String hashPassword({required String password}) {
    const secretKey = 'A8+fsd465sdg5ddg/*sgh8Jf4Ds';
    final hmac = Hmac(sha256, utf8.encode(secretKey));
    final digest = hmac.convert(utf8.encode(password));
    return digest.toString();
  }

  @override
  Future<AuthUser> login({
    required String emailOrPhone,
    required String password,
  }) async {
    final normalizedIdentifier = _normalize(emailOrPhone);

    final account = _accounts.where(
      (account) =>
          _normalize(account.user.emailOrPhone) == normalizedIdentifier &&
          hashPassword(password: password) == account.passwordHash,
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
      passwordHash: hashPassword(password: password),
      createdDate: DateTime.now(),
    );

    _nextUserId++;
    _accounts.add(
      _MockAuthAccount(user: user, passwordHash: user.passwordHash),
    );
    await _saveAccounts();
    return user;
  }

  String _normalize(String value) {
    return value.trim().toLowerCase();
  }

  Future<void> _saveAccounts() async {
    await _box.put(
      AppPreferences.authAccountsKey,
      _accounts.map((account) => account.toJson()).toList(growable: false),
    );
    await _box.put(AppPreferences.nextAuthUserIdKey, _nextUserId);
    await _box.flush();
  }

  static int _readNextUserId(Box<dynamic> box) {
    return box.get(AppPreferences.nextAuthUserIdKey, defaultValue: 2) as int;
  }

  static List<_MockAuthAccount> _readAccounts(Box<dynamic> box) {
    final rawAccounts =
        box.get(AppPreferences.authAccountsKey, defaultValue: <dynamic>[])
            as List<dynamic>;

    return rawAccounts.whereType<Map<dynamic, dynamic>>().map((rawAccount) {
      final account = Map<String, dynamic>.from(rawAccount);
      final user = Map<String, dynamic>.from(
        account['user'] as Map<dynamic, dynamic>,
      );

      return _MockAuthAccount(
        user: AuthUser.fromJson(user),
        passwordHash: account['passwordHash'] as String,
      );
    }).toList();
  }
}

class _MockAuthAccount {
  final AuthUser user;
  String passwordHash;

  _MockAuthAccount({required this.user, required this.passwordHash});

  Map<String, dynamic> toJson() {
    return {'user': user.toJson(), 'passwordHash': passwordHash};
  }
}
