import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:jannah/app/navigation/navigation_bar.dart';
import 'package:jannah/app/navigation/navigation_cubit.dart';

// Future global cubits
// import 'package:jannah/features/auth/presentation/cubit/auth_cubit.dart';
// import 'package:jannah/features/cart/presentation/cubit/cart_cubit.dart';

void main() {
  runApp(const Jannah());
}

class Jannah extends StatelessWidget {
  const Jannah({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Global Cubits
        BlocProvider(create: (_) => NavigationCubit()),

        // Add global cubits here when you create them
        // BlocProvider(
        //   create: (_) => AuthCubit(authRepository),
        // ),
        //
        // BlocProvider(
        //   create: (_) => CartCubit(cartRepository),
        // ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme),
        ),
        debugShowCheckedModeBanner: false,
        home: const JannahNavigationBar(),
      ),
    );
  }
}
