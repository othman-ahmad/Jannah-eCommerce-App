import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jannah/core/local/app_preferences.dart';
import 'package:jannah/features/authentication/data/auth_user_model.dart';
import 'package:jannah/features/authentication/domain/usecases/login.dart';
import 'package:jannah/features/authentication/domain/usecases/register.dart';
import 'package:jannah/features/authentication/presentation/cubit/authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final Login loginUseCase;
  final Register registerUseCase;
  AuthenticationCubit({
    required this.loginUseCase,
    required this.registerUseCase,
  }) : super(const AuthenticationState()) {
    _restoreSession();
  }

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
      await _saveAuthenticatedSession(user);

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
      await _saveAuthenticatedSession(user);

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

  Future<void> continueAsGuest() async {
    await _saveGuestSession();

    emit(
      state.copyWith(
        status: AuthenticationStatus.guest,
        clearUser: true,
        clearErrorMessage: true,
      ),
    );
  }

  Future<void> logout() async {
    await _clearSession();

    emit(
      const AuthenticationState(status: AuthenticationStatus.unauthenticated),
    );
  }

  void _restoreSession() {
    final box = Hive.box<dynamic>(AppPreferences.authBoxName);
    final sessionStatus = box.get(AppPreferences.authSessionStatusKey);

    if (sessionStatus == AuthenticationStatus.guest.name) {
      emit(const AuthenticationState(status: AuthenticationStatus.guest));
      return;
    }

    final rawUser = box.get(AppPreferences.currentAuthUserKey);

    if (sessionStatus == AuthenticationStatus.authenticated.name &&
        rawUser is Map<dynamic, dynamic>) {
      emit(
        AuthenticationState(
          status: AuthenticationStatus.authenticated,
          user: AuthUser.fromJson(Map<String, dynamic>.from(rawUser)),
        ),
      );
    }
  }

  Future<void> _saveAuthenticatedSession(AuthUser user) async {
    final box = Hive.box<dynamic>(AppPreferences.authBoxName);
    await box.put(
      AppPreferences.authSessionStatusKey,
      AuthenticationStatus.authenticated.name,
    );
    await box.put(AppPreferences.currentAuthUserKey, user.toJson());
    await box.flush();
  }

  Future<void> _saveGuestSession() async {
    final box = Hive.box<dynamic>(AppPreferences.authBoxName);
    await box.put(
      AppPreferences.authSessionStatusKey,
      AuthenticationStatus.guest.name,
    );
    await box.delete(AppPreferences.currentAuthUserKey);
    await box.flush();
  }

  Future<void> _clearSession() async {
    final box = Hive.box<dynamic>(AppPreferences.authBoxName);
    await box.delete(AppPreferences.authSessionStatusKey);
    await box.delete(AppPreferences.currentAuthUserKey);
    await box.flush();
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
