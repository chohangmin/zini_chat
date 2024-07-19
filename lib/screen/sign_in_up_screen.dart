import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final formKey = GlobalKey<FormState>();
  final _authentication = FirebaseAuth.instance;
  bool isSignIn = true;
  String _userEmail = '';
  String _userPassword = '';

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
                      Form(
                        key: formKey,
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
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter email address.';
                                }
                                if (!value.contains('@')) {
                                  return 'Email address must include @';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                _userEmail = value!;
                              },
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
                              validator: (value) {
                                if (value!.length < 7) {
                                  return 'Please enter more than 6 characters';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _userPassword = value!;
                              },
                              obscureText: true,
                            ),
                          ],
                        ),
                      ),
                    if (!isSignIn)
                      Form(
                        key: formKey,
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
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter email address.';
                                }
                                if (!value.contains('@')) {
                                  return 'Email address must include @';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                _userEmail = value!;
                              },
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
                              validator: (value) {
                                if (value!.length < 7) {
                                  return 'Please enter more than 6 characters';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _userPassword = value!;
                              },
                              obscureText: true,
                            ),
                          ],
                        ),
                      ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (isSignIn) {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();

                            await _authentication.signInWithEmailAndPassword(
                              email: _userEmail,
                              password: _userPassword,
                            );

                            setState(() {});

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Sign In Success!!'),
                              ),
                            );
                          }
                        } else {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            setState(() {});

                            await _authentication
                                .createUserWithEmailAndPassword(
                              email: _userEmail,
                              password: _userPassword,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Sign Up Success!!'),
                              ),
                            );
                          }
                        }
                      },
                      label: const Text('Submit'),
                    ),
                    Column(
                      children: [
                        Text('email : $_userEmail'),
                        Text('password : $_userPassword'),
                      ],
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
