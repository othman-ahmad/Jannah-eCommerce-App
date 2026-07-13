import 'package:jannah/features/authentication/data/auth_user_model.dart';
import 'package:jannah/features/authentication/data/authentication_remote_data_source.dart';
import 'package:jannah/features/authentication/domain/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationRemoteDataSource remoteDataSource;

  const AuthenticationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AuthUser> login({
    required String emailOrPhone,
    required String password,
  }) {
    return remoteDataSource.login(
      emailOrPhone: emailOrPhone,
      password: password,
    );
  }

  @override
  Future<AuthUser> register({
    required String fullName,
    required String emailOrPhone,
    required String password,
  }) {
    return remoteDataSource.register(
      fullName: fullName,
      emailOrPhone: emailOrPhone,
      password: password,
    );
  }
}
