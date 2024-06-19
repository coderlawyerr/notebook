import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String width;
  final String hintText;
  final BorderRadius borderRadius;
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.hintText,
      required this.borderRadius, required this.width});

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: Colors.orange,
              width: 20,
            ),
          ),
        ));
  }
}