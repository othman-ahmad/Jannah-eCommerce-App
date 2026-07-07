import 'package:flutter/material.dart';
import 'package:jannah/core/custom_widgets/Secondry_button.dart';
import 'package:jannah/core/custom_widgets/primary_button.dart';
import 'package:jannah/core/custom_widgets/primary_text_field.dart';
import 'package:jannah/features/home_page/presentation/home_page_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Register',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'New to Jannah?',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Let\'s get you started with a new account.',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 40),
              PrimaryTextField(hintText: 'Full Name'),
              SizedBox(height: 16),
              PrimaryTextField(hintText: 'Email or Phone Number'),
              SizedBox(height: 16),
              PrimaryTextField(hintText: 'Password', isPassword: true),
              SizedBox(height: 16),
              PrimaryTextField(hintText: 'Confirm password', isPassword: true),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePageScreen()),
                    );
                  },
                  text: 'Register',
                ),
              ),

              SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
