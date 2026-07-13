import 'package:jannah/features/authentication/data/auth_user_model.dart';
import 'package:jannah/features/authentication/domain/authentication_repository.dart';

class Register {
  final AuthenticationRepository repository;

  const Register(this.repository);

  Future<AuthUser> call({
    required String fullName,
    required String emailOrPhone,
    required String password,
  }) {
    return repository.register(
      fullName: fullName,
      emailOrPhone: emailOrPhone,
      password: password,
    );
  }
}
