import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:jannah/app/navigation/navigation_bar.dart';
import 'package:jannah/features/onboarding/presentation/onboarding_parent_screen.dart';

void main() {
  runApp(const Jannah());
}

class Jannah extends StatelessWidget {
  const Jannah({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme),
      ),
      debugShowCheckedModeBanner: false,
      home: OnboardingInitiate(),
    );
  }
}
