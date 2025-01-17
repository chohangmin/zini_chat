import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:zini_chat/screen/main_screen.dart';
import 'package:zini_chat/screen/sign_in_up_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zini_chat/screen/splash_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart' show rootBundle;

late final FirebaseAuth auth;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  auth = FirebaseAuth.instance;
  await checkAndInitializeData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          return FutureBuilder(
              future: Future.delayed(const Duration(milliseconds: 1000)),
              builder: (context, delaySnapshot) {
                if (delaySnapshot.connectionState == ConnectionState.waiting) {
                  return const SplashScreen();
                }

                if (snapshot.hasData) {
                  return const MainScreen();
                }
                return const SignInUpScreen();
              });
        },
      ),
    );
  }
}

Future<void> checkAndInitializeData() async {
  final docRef =
      FirebaseFirestore.instance.collection('appStatus').doc('initialization');

  final docSnapshot = await docRef.get();

  if (!docSnapshot.exists) {
    await initializeFirebaseStorageData();

    await docRef.set({
      'initialized': true,
    });
  }
}

Future<void> initializeFirebaseStorageData() async {
  const assetPath = 'assets/images/default_image.png';
  final byteData = await rootBundle.load(assetPath);
  final fileBytes = byteData.buffer.asUint8List();

  final storageRef =
      FirebaseStorage.instance.ref().child('default_image/default_image.png');

  try {
    await storageRef.putData(fileBytes);
    print('INIT File upload succesfully!');
  } catch (e) {
    print('INIT File upload failed : $e');
  }
}
