import 'package:jannah/features/authentication/data/auth_user_model.dart';
import 'package:jannah/features/authentication/domain/authentication_repository.dart';

class Login {
  final AuthenticationRepository repository;

  const Login(this.repository);

  Future<AuthUser> call({
    required String emailOrPhone,
    required String password,
  }) {
    return repository.login(emailOrPhone: emailOrPhone, password: password);
  }
}
