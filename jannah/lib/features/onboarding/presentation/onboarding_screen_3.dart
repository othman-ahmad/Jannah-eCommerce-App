import 'package:flutter/material.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Spacer(),
          Image.asset(
            'assets/images/Driver.png',
            height: 380,
            width: double.infinity,
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Fast & Reliable',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          const Text(
            'Delivery',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}
