import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0);

  void goToTab(int index) => emit(index);

  void goHome() => emit(0);

  void goSearch() => emit(1);

  void goFavorites() => emit(2);

  void goProfile() => emit(3);
}
