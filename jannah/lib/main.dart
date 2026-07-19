import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:jannah/core/local/app_preferences.dart';
import 'package:jannah/features/authentication/data/authentication_remote_data_source.dart';
import 'package:jannah/features/authentication/data/authentication_repository_impl.dart';
import 'package:jannah/features/authentication/domain/usecases/login.dart';
import 'package:jannah/features/authentication/domain/usecases/register.dart';
import 'package:jannah/features/authentication/presentation/auth_wrapper.dart';
import 'package:jannah/features/authentication/presentation/cubit/authentication_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<bool>(AppPreferences.boxName);
  await Hive.openBox<dynamic>(AppPreferences.authBoxName);
  runApp(const Jannah());
}

class Jannah extends StatelessWidget {
  const Jannah({super.key});

  AuthenticationCubit _createAuthenticationCubit() {
    final remoteDataSource = MockAuthenticationRemoteDataSource();
    final repository = AuthenticationRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );

    return AuthenticationCubit(
      loginUseCase: Login(repository),
      registerUseCase: Register(repository),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _createAuthenticationCubit(),
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme),
        ),
        debugShowCheckedModeBanner: false,
        home: const AuthWrapper(),
      ),
    );
  }
}
