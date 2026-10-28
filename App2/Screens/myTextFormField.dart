

import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final String name;
  final bool obscureText;
  final TextEditingController? controller;

  const MyTextFormField({
    super.key,
    required this.name,
    this.obscureText = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: name,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please Enter your $name";
        }
        return null;
      },
    );
  }
}