import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jannah/core/custom_widgets/primary_button.dart';
import 'package:jannah/core/custom_widgets/primary_text_field.dart';
import 'package:jannah/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:jannah/features/authentication/presentation/cubit/authentication_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailOrPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<AuthenticationCubit>().register(
      fullName: _fullNameController.text,
      emailOrPhone: _emailOrPhoneController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (ModalRoute.of(context)?.isCurrent != true) {
          return;
        }

        if (state.status == AuthenticationStatus.authenticated) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }

        if (state.status == AuthenticationStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Registration failed.'),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AuthenticationStatus.loading;

        return Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          appBar: AppBar(
            toolbarHeight: 100,
            backgroundColor: const Color(0xFFFAFAFA),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Register',
              style: TextStyle(
                color: Colors.grey.shade900,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'New to Jannah?',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: Colors.grey.shade900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Let\'s get you started with a new account.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  PrimaryTextField(
                    hintText: 'Full Name',
                    controller: _fullNameController,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  PrimaryTextField(
                    hintText: 'Email or Phone Number',
                    controller: _emailOrPhoneController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  PrimaryTextField(
                    hintText: 'Password',
                    controller: _passwordController,
                    isPassword: true,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  PrimaryTextField(
                    hintText: 'Confirm password',
                    controller: _confirmPasswordController,
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submit(),
                  ),
                  const Spacer(),
                  PrimaryButton(
                    onPressed: isLoading ? () {} : _submit,
                    text: isLoading ? 'Creating account...' : 'Register',
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
