import 'dart:ffi';

import 'package:flutter/material.dart';

class LoginBox extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onPressed;
  const LoginBox(
      {super.key,
      required this.title,
      required this.color,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        height: 50,
        //width: 100,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
            child: Text(title, style: TextStyle(fontSize: 20, color: color))),
      ),
    );
  }
}
