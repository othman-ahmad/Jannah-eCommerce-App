import 'package:flutter/material.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Find everything you need',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 24),
          const Text(
            'in one Place',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 122, 122, 122),
            ),
          ),
          Spacer(),
          Image.asset(
            'assets/images/JannahMixImage (9).png',
            height: 280,
            width: double.infinity,
          ),
          Spacer(),
        ],
      ),
    );
  }
}
