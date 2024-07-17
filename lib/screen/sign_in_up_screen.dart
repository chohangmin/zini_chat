import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zini_chat/widget/speech_bubble.dart';

class SignInUpScreen extends StatefulWidget {
  const SignInUpScreen({super.key});

  @override
  State<SignInUpScreen> createState() => _SignInUpScreenState();
}

class _SignInUpScreenState extends State<SignInUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: SpeechBubble(message: 'Hello! World!'),
          ),
          Positioned(
            top: 140,
            left: 0,
            right: 0,
            child: ExtendedImage.asset(
              'assets/images/mr_happy.jpg',
              height: 300,
            ),
          ),
        ],
      ),
    );
  }
}
