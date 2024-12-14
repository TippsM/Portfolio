import 'package:flutter/material.dart';

import 'my_textfield.dart';

class RoundedUsernameField extends StatelessWidget {
  final String? hintText;
  final IconData icon;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const RoundedUsernameField({
    super.key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return MyTextField(
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          icon: Icon(
            icon,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
