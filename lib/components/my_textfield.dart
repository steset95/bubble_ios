import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hinText;
  final bool obscureText;
  final TextEditingController controller;


  const MyTextField({
    super.key,
    required this.hinText,
    required this.obscureText,
    required this.controller
});



  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: Colors.black),
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
                  ),
      hintText: hinText,
      ),
      obscureText: obscureText,
    );
  }
}
