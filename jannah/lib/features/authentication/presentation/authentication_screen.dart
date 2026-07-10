import 'package:flutter/material.dart';
import 'package:jannah/core/custom_widgets/Secondry_button.dart';
import 'package:jannah/core/custom_widgets/primary_button.dart';
import 'package:jannah/features/authentication/presentation/login_screen.dart';
import 'package:jannah/features/authentication/presentation/register_screen.dart';
import 'package:jannah/features/home_page/presentation/home_page_screen.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 60),
                PrimaryButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePageScreen()),
                    );
                  },
                  text: 'Continue as a Guest',
                ),
                SizedBox(height: 16),

                Row(
                  children: [
                    SizedBox(width: 8),
                    Expanded(child: Divider(color: Colors.grey, thickness: 1)),
                    Text('  OR  ', style: TextStyle(color: Colors.grey)),
                    Expanded(child: Divider(color: Colors.grey, thickness: 1)),
                    SizedBox(width: 8),
                  ],
                ),
                SizedBox(height: 16),
                SecondryButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  text: 'Login',
                ),
                SizedBox(height: 16),
                SecondryButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  text: 'Register',
                ),
              ],
            ),
          ),
          Spacer(),
          // Add your login form and buttons here
        ],
      ),
    );
  }
}
