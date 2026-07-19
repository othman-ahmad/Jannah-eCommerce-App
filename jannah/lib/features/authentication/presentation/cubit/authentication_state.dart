import 'package:jannah/features/authentication/data/auth_user_model.dart';

enum AuthenticationStatus {
  initial,
  loading,
  authenticated,
  guest,
  unauthenticated,
  failure,
}

class AuthenticationState {
  final AuthenticationStatus status;
  final AuthUser? user;
  final String? errorMessage;

  const AuthenticationState({
    this.status = AuthenticationStatus.initial,
    this.user,
    this.errorMessage,
  });

  AuthenticationState copyWith({
    AuthenticationStatus? status,
    AuthUser? user,
    String? resetIdentifier,
    String? errorMessage,
    bool clearUser = false,
    bool clearResetIdentifier = false,
    bool clearErrorMessage = false,
  }) {
    return AuthenticationState(
      status: status ?? this.status,
      user: clearUser ? null : user ?? this.user,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}
