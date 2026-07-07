import 'package:flutter/material.dart';

class SecondryButton extends StatelessWidget {
  SecondryButton({super.key, required this.onPressed, required this.text});
  VoidCallback onPressed;
  String text;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          const Color.fromARGB(255, 255, 255, 255),
        ),
        foregroundColor: WidgetStatePropertyAll(
          const Color.fromARGB(255, 0, 0, 0),
        ),
        padding: WidgetStatePropertyAll(
          const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
