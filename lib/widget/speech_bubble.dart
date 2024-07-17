import 'package:flutter/material.dart';

class SpeechBubble extends StatelessWidget {
  final String message;

  const SpeechBubble({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BubbleClipper(),
      child: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.blue[100],
        child: Center(
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
      ),
    );
  }
}

class BubbleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path()
      ..moveTo(0, 20)
      ..lineTo(0, size.height - 20)
      ..quadraticBezierTo(0, size.height, 20, size.height)
      ..lineTo(size.width - 20, size.height)
      ..quadraticBezierTo(size.width, size.height, size.width, size.height - 20)
      ..lineTo(size.width, 20)
      ..quadraticBezierTo(size.width, 0, size.width - 20, 0)
      ..lineTo(30, 0)
      ..quadraticBezierTo(10, 0, 0, 20)
      ..close()
      ..moveTo(20, size.height - 20)
      ..lineTo(10, size.height)
      ..lineTo(30, size.height - 20)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
