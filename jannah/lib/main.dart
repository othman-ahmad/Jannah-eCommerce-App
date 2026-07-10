import 'package:flutter/material.dart';
import 'package:jannah/features/home_page/presentation/home_page_screen.dart';
import 'package:jannah/features/onboarding/presentation/onboarding_parent_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jannah/features/products/data/item_model.dart';
import 'package:jannah/features/products/presentation/item_details_screen.dart';

void main() {
  runApp(Jannah());
}

class Jannah extends StatelessWidget {
  const Jannah({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePageScreen(),
    );
  }
}
