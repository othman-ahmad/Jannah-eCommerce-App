import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jannah/core/custom_widgets/primary_button.dart';
import 'package:jannah/features/home_page/presentation/home_page_screen.dart';
import 'package:jannah/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:jannah/features/onboarding/presentation/cubit/onboarding_state.dart';
import 'package:jannah/features/onboarding/presentation/onboarding_screen_1.dart';
import 'package:jannah/features/onboarding/presentation/onboarding_screen_2.dart';
import 'package:jannah/features/onboarding/presentation/onboarding_screen_3.dart';

class onboardinginitiate extends StatelessWidget {
  const onboardinginitiate({super.key});
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
              onboardingScreens[state.currentPageIndex],
              Padding(
                padding: const EdgeInsets.only(bottom: 32, left: 24, right: 24),
                child: Row(
                  children: [
                    state.currentPageIndex != 2
                        ? const _StepIndicator()
                        : const SizedBox.shrink(),
                    Expanded(
                      child: PrimaryButton(
                        onPressed: () {
                          if (state.currentPageIndex == 2) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePageScreen(),
                              ),
                            );
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

class _StepIndicator extends StatelessWidget {
  const _StepIndicator();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return SizedBox(
          width: 120,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  color: state.currentPageIndex == index
                      ? const Color.fromARGB(255, 0, 0, 0)
                      : Colors.grey.shade400,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
