import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jannah/features/onboarding/presentation/cubit/onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState(currentPageIndex: 0));

  void changePage(int pageIndex) {
    if (pageIndex == state.currentPageIndex || pageIndex < 0 || pageIndex > 3) {
      return;
    }
    emit(OnboardingState(currentPageIndex: pageIndex));
  }
}
