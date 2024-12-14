import 'package:cen_project/forgot_password.dart';
import 'package:cen_project/pages/signup_page.dart';
import 'package:cen_project/components/rounded_button.dart';
import 'package:flutter/material.dart';

import '../components/already_have_an_account_check.dart';
import '../components/forgot_password_check.dart';
import '../components/rounded_password_field.dart';
import '../components/rounded_username_field.dart';

class LoginPage2 extends StatelessWidget {
  LoginPage2({super.key});

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Icon(
                Icons.lock,
                size: 100,
              ),
              const SizedBox(height: 50),
              Text(
                'LOGIN',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              RoundedUsernameField(
                hintText: "Username",
                onChanged: (value) {},
              ),
              RoundedPasswordField(
                onChanged: (value) {},
              ),
              SizedBox(height: size.height * 0.02),
              RoundedButton(
                text: "LOGIN",
                press: () {},
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SignUpPage();
                      },
                    ),
                  );
                },
              ),
              ForgotPasswordCheck(
                press: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ForgotPasswordPage();
                  }));
                },
              ),
            ],
          ),
        )));
  }
}
