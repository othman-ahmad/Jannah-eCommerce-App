import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jannah/app/navigation/navigation_bar.dart';
import 'package:jannah/core/local/app_preferences.dart';
import 'package:jannah/features/authentication/presentation/authentication_screen.dart';
import 'package:jannah/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:jannah/features/authentication/presentation/cubit/authentication_state.dart';
import 'package:jannah/features/onboarding/presentation/onboarding_parent_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final preferencesBox = Hive.box<bool>(AppPreferences.boxName);

    return ValueListenableBuilder<Box<bool>>(
      valueListenable: preferencesBox.listenable(
        keys: [AppPreferences.hasSeenOnboardingKey],
      ),
      builder: (context, box, _) {
        final hasSeenOnboarding =
            box.get(AppPreferences.hasSeenOnboardingKey, defaultValue: false) ??
            false;

        if (!hasSeenOnboarding) {
          return const OnboardingInitiate();
        }

        return BlocBuilder<AuthenticationCubit, AuthenticationState>(
          builder: (context, state) {
            if (state.status == AuthenticationStatus.authenticated ||
                state.status == AuthenticationStatus.guest) {
              return const JannahNavigationBar();
            }

            return const AuthenticationScreen();
          },
        );
      },
    );
  }
}
