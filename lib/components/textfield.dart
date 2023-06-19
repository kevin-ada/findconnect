import 'package:flutter/material.dart';

class Textfield_reusable extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const Textfield_reusable(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
        style: TextStyle(color: Colors.white, fontSize: 16),
        cursorColor: Colors.black54,
        obscureText: obscureText,
        controller: controller,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xff46458C)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Color(0xff9575DE)),
          ),
        ),
      ),
    );
  }
}
