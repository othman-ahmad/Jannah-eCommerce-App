import 'package:flutter/material.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset(
            fit: BoxFit.cover,
            'assets/images/JannahMixImage (10).png',
            height: MediaQuery.of(context).size.width,
            width: double.infinity,
          ),

          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Handpicked',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          const Text(
            'Just for You',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}
