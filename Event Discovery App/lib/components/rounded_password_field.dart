import 'package:flutter/material.dart';

import '../constants.dart';
import 'my_textfield.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final String hintText;

  const RoundedPasswordField({
    super.key,
    this.onChanged,
    this.controller,
    this.hintText = "Password",
  });

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool _isObscured = true;

  void _toggleVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyTextField(
      child: TextField(
        controller: widget.controller,
        obscureText: _isObscured,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          icon: const Icon(
            Icons.lock,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isObscured ? Icons.visibility_off : Icons.visibility,
              color: kPrimaryColor,
            ),
            onPressed: _toggleVisibility,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
