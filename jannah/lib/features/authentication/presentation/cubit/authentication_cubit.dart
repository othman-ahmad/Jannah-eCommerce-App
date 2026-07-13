import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jannah/features/authentication/domain/usecases/login.dart';
import 'package:jannah/features/authentication/domain/usecases/register.dart';
import 'package:jannah/features/authentication/presentation/cubit/authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final Login loginUseCase;
  final Register registerUseCase;
  AuthenticationCubit({
    required this.loginUseCase,
    required this.registerUseCase,
  }) : super(const AuthenticationState());

  Future<void> login({
    required String emailOrPhone,
    required String password,
  }) async {
    emit(
      state.copyWith(
        status: AuthenticationStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      _validateRequired(emailOrPhone, 'Email or phone number is required.');
      _validateRequired(password, 'Password is required.');

      final user = await loginUseCase(
        emailOrPhone: emailOrPhone.trim(),
        password: password,
      );

      emit(
        state.copyWith(
          status: AuthenticationStatus.authenticated,
          user: user,
          clearErrorMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthenticationStatus.failure,
          errorMessage: _messageFromException(e),
        ),
      );
    }
  }

  Future<void> register({
    required String fullName,
    required String emailOrPhone,
    required String password,
    required String confirmPassword,
  }) async {
    emit(
      state.copyWith(
        status: AuthenticationStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      _validateRequired(fullName, 'Full name is required.');
      _validateRequired(emailOrPhone, 'Email or phone number is required.');
      _validateRequired(password, 'Password is required.');
      _validateMatchingPasswords(password, confirmPassword);

      final user = await registerUseCase(
        fullName: fullName.trim(),
        emailOrPhone: emailOrPhone.trim(),
        password: password,
      );

      emit(
        state.copyWith(
          status: AuthenticationStatus.authenticated,
          user: user,
          clearErrorMessage: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthenticationStatus.failure,
          errorMessage: _messageFromException(e),
        ),
      );
    }
  }

  void _validateRequired(String value, String message) {
    if (value.trim().isEmpty) {
      throw Exception(message);
    }
  }

  void _validateMatchingPasswords(String password, String confirmPassword) {
    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters.');
    }

    if (password != confirmPassword) {
      throw Exception('Passwords do not match.');
    }
  }

  String _messageFromException(Object exception) {
    return exception.toString().replaceFirst('Exception: ', '');
  }
}
