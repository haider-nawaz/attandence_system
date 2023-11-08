import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String title;

  const CustomTextField(
      {super.key,
      required this.controller,
      required this.icon,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: false,
      // cursorColor: Colors.grey,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          // color: Colors.grey,
        ),
        labelText: "Enter your $title",
        //border: OutlineInputBorder(),
        //fillColor: Colors.white,
        filled: true,
        //labelStyle: const TextStyle(color: Colors.black45),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35.0),
          borderSide: const BorderSide(
              //color: Colors.black45,
              ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35.0),
          borderSide: const BorderSide(
              // color: Colors.black45,
              ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$title cannot be empty";
        }
        return null;
      },
    );
  }
}
