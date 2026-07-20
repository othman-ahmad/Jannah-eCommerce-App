import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jannah/core/custom_widgets/primary_button.dart';
import 'package:jannah/core/local/app_preferences.dart';
import 'package:jannah/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:jannah/features/onboarding/presentation/cubit/onboarding_state.dart';
import 'package:jannah/features/onboarding/presentation/onboarding_screen_1.dart';
import 'package:jannah/features/onboarding/presentation/onboarding_screen_2.dart';
import 'package:jannah/features/onboarding/presentation/onboarding_screen_3.dart';
import 'package:jannah/features/onboarding/presentation/widgets/step_indicator.dart';

class OnboardingInitiate extends StatelessWidget {
  const OnboardingInitiate({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: OnboardingParentScreen(),
    );
  }
}

class OnboardingParentScreen extends StatelessWidget {
  OnboardingParentScreen({super.key});
  List<Widget> onboardingScreens = [
    OnboardingScreen1(),
    OnboardingScreen2(),
    OnboardingScreen3(),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: onboardingScreens[state.currentPageIndex],
              ),
              Container(
                padding: const EdgeInsets.only(
                  bottom: 32,
                  left: 24,
                  right: 24,
                  top: 20,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color.fromARGB(0, 250, 250, 250),
                      const Color(0xFFFAFAFA),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    state.currentPageIndex != 2
                        ? const StepIndicator()
                        : const SizedBox.shrink(),
                    Expanded(
                      child: PrimaryButton(
                        onPressed: () async {
                          if (state.currentPageIndex == 2) {
                            final box = Hive.box<bool>(AppPreferences.boxName);
                            await box.put(
                              AppPreferences.hasSeenOnboardingKey,
                              true,
                            );
                            await box.flush();
                          } else {
                            context.read<OnboardingCubit>().changePage(
                              state.currentPageIndex + 1,
                            );
                          }
                        },
                        text: state.currentPageIndex == 2
                            ? 'Get Started'
                            : 'Next',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
