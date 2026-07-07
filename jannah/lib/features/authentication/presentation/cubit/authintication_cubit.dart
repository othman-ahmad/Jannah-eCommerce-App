import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jannah/features/authentication/presentation/cubit/authintication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());
  bool isLoggedIn = false;

  void login(String username, String password) {
    // Implement login logic here
    emit(AuthenticationLoading());
    try {
      // Simulate a successful login
      emit(AuthenticationSuccess());
    } catch (e) {
      emit(AuthenticationFailure(errorMessage: e.toString()));
    }
  }

  void logout() {
    // Implement logout logic here
    emit(AuthenticationInitial());
  }
}
