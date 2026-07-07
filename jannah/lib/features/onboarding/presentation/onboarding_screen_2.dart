import 'package:flutter/material.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
            child: Image.asset(
              'assets/images/JannahMixImage (10).png',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.width,
              width: double.infinity,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Handpicked',
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
            'Just for You',
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
