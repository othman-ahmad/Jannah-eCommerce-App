import 'package:flutter/material.dart';
import 'package:jannah/features/onboarding/presentation/onboarding_parent_screen.dart';

void main() {
  runApp(const Jannah());
}

class Jannah extends StatelessWidget {
  const Jannah({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: onboardinginitiate(),
    );
  }
}
