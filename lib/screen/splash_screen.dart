import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ExtendedImage.asset('assets/images/mr_happy.jpg'),
          const SizedBox(
            height: 10,
          ),
          const CircularProgressIndicator(
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
