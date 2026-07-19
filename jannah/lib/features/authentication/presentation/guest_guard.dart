import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jannah/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:jannah/features/authentication/presentation/cubit/authentication_state.dart';

bool requireAuthenticatedUser(BuildContext context, {required String message}) {
  final authCubit = context.read<AuthenticationCubit>();
  final isGuest = authCubit.state.status == AuthenticationStatus.guest;

  if (!isGuest) {
    return true;
  }

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'Login',
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
            authCubit.logout();
          },
        ),
      ),
    );

  return false;
}
