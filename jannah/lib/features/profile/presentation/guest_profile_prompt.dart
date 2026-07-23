import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jannah/features/authentication/presentation/cubit/authentication_cubit.dart';

class GuestProfilePrompt extends StatelessWidget {
  const GuestProfilePrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.person_outline, size: 64, color: Colors.black),
            const SizedBox(height: 20),
            const Text(
              "You're browsing as a guest.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Sign in to:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            const _GuestBenefit(text: 'Save items'),
            const _GuestBenefit(text: 'Add products to your cart'),
            const _GuestBenefit(text: 'Track orders'),
            const _GuestBenefit(text: 'Sync across devices'),
            const SizedBox(height: 28),
            SizedBox(
              height: 54,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  context.read<AuthenticationCubit>().logout();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuestBenefit extends StatelessWidget {
  final String text;

  const _GuestBenefit({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        '✓ $text',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
