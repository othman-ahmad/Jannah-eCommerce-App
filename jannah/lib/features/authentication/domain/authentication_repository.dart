import 'package:jannah/features/authentication/data/auth_user_model.dart';

abstract class AuthenticationRepository {
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
