import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zini_chat/widget/speech_bubble.dart';

class SignInUpScreen extends StatefulWidget {
  const SignInUpScreen({super.key});

  @override
  State<SignInUpScreen> createState() => _SignInUpScreenState();
}

class _SignInUpScreenState extends State<SignInUpScreen> {
  bool isSignIn = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: Container(
                  padding: const EdgeInsets.all(10),
                  child: const SpeechBubble(message: 'Hello! World!')),
            ),
            Positioned(
              top: 160,
              left: 0,
              right: 0,
              child: ExtendedImage.asset(
                'assets/images/mr_happy.jpg',
                height: 100,
              ),
            ),
            Positioned(
              top: 160,
              left: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignIn = true;
                            });
                          },
                          child: Text(
                            'SIGNIN',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: isSignIn
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignIn = false;
                            });
                          },
                          child: Text(
                            'SIGNUP',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: isSignIn
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (isSignIn)
                      Container(
                        child: Column(
                          children: [
                            TextFormField(
                              key: const ValueKey(1),
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              key: const ValueKey(2),
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (!isSignIn)
                      Container(
                        child: Column(
                          children: [
                            TextFormField(
                              key: const ValueKey(3),
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              key: const ValueKey(4),
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
