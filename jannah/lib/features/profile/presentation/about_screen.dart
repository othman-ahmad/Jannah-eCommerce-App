import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryText = Color(0xFF212121);
    const secondaryText = Color(0xFF757575);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.white,
        title: const Text(
          'About',
          style: TextStyle(
            color: primaryText,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: primaryText),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.eco, size: 40, color: primaryText),
                const Text(
                  'Jannah',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: primaryText,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            const Text(
              'Fresh. Healthy. Delivered.',
              style: TextStyle(
                fontSize: 15,
                color: secondaryText,
                letterSpacing: .4,
              ),
            ),

            const SizedBox(height: 40),

            _Section(
              title: 'About',
              child: const Text(
                'Jannah is your trusted destination for fresh fruits, vegetables, herbs, dairy products, bakery items, and everyday grocery essentials.\n\n'
                'We believe shopping for healthy food should be simple, enjoyable, and convenient. Every product is carefully selected to ensure freshness, quality, and value before it reaches your doorstep.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.7,
                  color: secondaryText,
                ),
              ),
            ),

            const SizedBox(height: 24),

            _Section(
              title: 'Why Choose Jannah',
              child: const Column(
                children: [
                  _FeatureItem('Fresh fruits & vegetables'),
                  _FeatureItem('Quality products you can trust'),
                  _FeatureItem('Fast & reliable delivery'),
                  _FeatureItem('Simple & secure checkout'),
                  _FeatureItem('Save your favorite items'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _Section(
              title: 'Our Vision',
              child: const Text(
                'To become the preferred online grocery destination by delivering exceptional quality, reliable service, and a seamless shopping experience.',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.7,
                  color: secondaryText,
                ),
              ),
            ),

            const SizedBox(height: 40),

            const Divider(),

            const SizedBox(height: 20),

            const Text(
              'Version 1.0.0',
              style: TextStyle(color: secondaryText, fontSize: 14),
            ),

            const SizedBox(height: 6),

            const Text(
              '© 2026 Jannah',
              style: TextStyle(color: secondaryText, fontSize: 13),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E5E5)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String text;

  const _FeatureItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 20,
            color: Color(0xFF212121),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: Color(0xFF424242)),
            ),
          ),
        ],
      ),
    );
  }
}
