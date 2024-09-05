import 'package:flutter/material.dart';

class SignUpInToggle extends StatelessWidget {
  const SignUpInToggle(
      {super.key, required this.isSignIn, required this.onToggle});

  final bool isSignIn;
  final Function(bool) onToggle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () {
            onToggle(true);
          },
          child: Text(
            'SIGNIN',
            style: TextStyle(
              fontSize: 30,
              fontWeight: isSignIn ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            onToggle(false);
          },
          child: Text(
            'SIGNUP',
            style: TextStyle(
              fontSize: 30,
              fontWeight: isSignIn ? FontWeight.normal : FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
