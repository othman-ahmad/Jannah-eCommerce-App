import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  PrimaryButton({super.key, required this.onPressed, required this.text});
  VoidCallback onPressed;
  String text;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: const WidgetStatePropertyAll(
            Color.fromARGB(255, 0, 0, 0),
          ),
          foregroundColor: const WidgetStatePropertyAll(Colors.white),
          overlayColor: WidgetStatePropertyAll(
            const Color.fromARGB(20, 255, 255, 255),
          ),
          elevation: const WidgetStatePropertyAll(0),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
