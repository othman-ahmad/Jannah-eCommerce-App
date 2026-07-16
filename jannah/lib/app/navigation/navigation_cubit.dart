import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0);

  void goToTab(int index) => emit(index);

  void goHome() => emit(0);
}
