import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:zini_chat/widget/sign_screen/custom_text_field_form.dart';
import 'package:zini_chat/widget/sign_screen/sign_up_in_toggle.dart';
import 'package:zini_chat/widget/sign_screen/summit_button.dart';
import 'package:zini_chat/widget/sign_screen/speech_bubble.dart';
import 'package:english_words/english_words.dart';

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

  void toggleSignInSignUp(bool signIn) {
    setState(() {
      isSignIn = signIn;
    });
  }

  Future<void> handleSummit() async {
    if (isSignIn) {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();

        try {
          final user = await _authentication.signInWithEmailAndPassword(
            email: _userEmail,
            password: _userPassword,
          );

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.user!.uid)
              .update({'isConnecting': true});
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Login is failed, error : $e')));
        }
      }
    } else {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();

        try {
          final newUser = await _authentication.createUserWithEmailAndPassword(
            email: _userEmail,
            password: _userPassword,
          );

          final defaultImageUrl = await FirebaseStorage.instance
              .ref()
              .child('default_image')
              .child('default_image.png')
              .getDownloadURL();

          WordPair randomName = WordPair.random();

          await FirebaseFirestore.instance
              .collection('users')
              .doc(newUser.user!.uid)
              .set({
            'userId': newUser.user!.uid,
            'userName': randomName.asPascalCase,
            'userImage': defaultImageUrl,
            'isConnecting': true,
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Signup is failed, error : $e')));
        }
      }
    }
  }

  String? signInIdValidator(value) {
    if (value!.isEmpty) {
      return 'Please enter email address.';
    }
    if (!value.contains('@')) {
      return 'Email address must include @';
    }

    return null;
  }

  String? signInPwValidator(value) {
    if (value!.length < 7) {
      return 'Please enter more than 6 characters';
    }
    return null;
  }

  String? signUpIdValidator(value) {
    if (value!.isEmpty) {
      return 'Please enter email address.';
    }
    if (!value.contains('@')) {
      return 'Email address must include @';
    }

    return null;
  }

  String? signUpPwValidator(value) {
    if (value!.length < 7) {
      return 'Please enter more than 6 characters';
    }
    return null;
  }

  void signInIdSaved(value) {
    _userEmail = value!;
  }

  void signInPwSaved(value) {
    _userPassword = value!;
  }

  void signUpIdSaved(value) {
    _userEmail = value!;
  }

  void signUpPwSaved(value) {
    _userPassword = value!;
  }

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
              top: 250,
              left: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    SignUpInToggle(
                      isSignIn: isSignIn,
                      onToggle: toggleSignInSignUp,
                    ),
                    if (isSignIn)
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            CustomTextFieldForm(
                                formKey: 1,
                                icon: const Icon(Icons.email),
                                onSaved: signInIdSaved,
                                validator: signInIdValidator),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomTextFieldForm(
                                formKey: 2,
                                icon: const Icon(Icons.lock),
                                obscureText: true,
                                onSaved: signInPwSaved,
                                validator: signInPwValidator),
                          ],
                        ),
                      ),
                    if (!isSignIn)
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            CustomTextFieldForm(
                                formKey: 3,
                                icon: const Icon(Icons.email),
                                onSaved: signUpIdSaved,
                                validator: signUpIdValidator),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomTextFieldForm(
                                formKey: 4,
                                icon: const Icon(Icons.lock),
                                obscureText: true,
                                onSaved: signUpPwSaved,
                                validator: signUpPwValidator),
                          ],
                        ),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    SummitButton(label: 'Summit', onPressed: handleSummit)
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
