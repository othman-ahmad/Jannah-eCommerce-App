import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jannah/app/navigation/navigation_bar.dart';
import 'package:jannah/core/custom_widgets/Secondry_button.dart';
import 'package:jannah/core/custom_widgets/primary_button.dart';
import 'package:jannah/features/authentication/data/authentication_remote_data_source.dart';
import 'package:jannah/features/authentication/data/authentication_repository_impl.dart';
import 'package:jannah/features/authentication/domain/usecases/login.dart';
import 'package:jannah/features/authentication/domain/usecases/register.dart';
import 'package:jannah/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:jannah/features/authentication/presentation/login_screen.dart';
import 'package:jannah/features/authentication/presentation/register_screen.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

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
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/JannahMixImage (4).png',
                  height: 280,
                  width: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          ' Welcome to \n Jannah',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 60),
                      PrimaryButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const JannahNavigationBar(),
                            ),
                          );
                        },
                        text: 'Continue as a Guest',
                      ),
                      SizedBox(height: 16),

                      Row(
                        children: [
                          SizedBox(width: 8),
                          Expanded(
                            child: Divider(color: Colors.grey, thickness: 1),
                          ),
                          Text('  OR  ', style: TextStyle(color: Colors.grey)),
                          Expanded(
                            child: Divider(color: Colors.grey, thickness: 1),
                          ),
                          SizedBox(width: 8),
                        ],
                      ),
                      SizedBox(height: 16),
                      SecondryButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: context.read<AuthenticationCubit>(),
                                child: const LoginScreen(),
                              ),
                            ),
                          );
                        },
                        text: 'Login',
                      ),
                      SizedBox(height: 16),
                      SecondryButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: context.read<AuthenticationCubit>(),
                                child: const RegisterScreen(),
                              ),
                            ),
                          );
                        },
                        text: 'Register',
                      ),
                    ],
                  ),
                ),
                Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }
}
