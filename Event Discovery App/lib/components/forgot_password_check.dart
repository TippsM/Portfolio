import 'package:flutter/material.dart';

import '../constants.dart';

class ForgotPasswordCheck extends StatelessWidget {
  final VoidCallback? press;
  const ForgotPasswordCheck({
    super.key,
    this.press,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press, // Use the passed press callback
      child: Text(
        "Forgot Password?",
        style: TextStyle(
          color: kPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
