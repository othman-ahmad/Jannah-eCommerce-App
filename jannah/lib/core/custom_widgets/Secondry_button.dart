import 'package:flutter/material.dart';

class SecondryButton extends StatelessWidget {
  SecondryButton({super.key, required this.onPressed, required this.text});
  VoidCallback onPressed;
  String text;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: const WidgetStatePropertyAll(
            Color.fromARGB(255, 255, 255, 255),
          ),
          foregroundColor: const WidgetStatePropertyAll(
            Color.fromARGB(255, 0, 0, 0),
          ),
          overlayColor: WidgetStatePropertyAll(
            const Color.fromARGB(12, 0, 0, 0),
          ),
          side: const WidgetStatePropertyAll(
            BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 1.2),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
