import 'package:flutter/material.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Column(
        children: [
          const Spacer(),
          Image.asset(
            'assets/images/Driver.png',
            height: 380,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Fast & Reliable',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                height: 1.25,
                letterSpacing: -0.5,
                color: Colors.grey.shade900,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Delivery',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              height: 1.25,
              letterSpacing: -0.5,
              color: Colors.grey.shade900,
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
