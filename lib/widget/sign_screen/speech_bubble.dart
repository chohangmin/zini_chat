import 'package:flutter/material.dart';

class SpeechBubble extends StatelessWidget {
  final String message;

  const SpeechBubble({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BubbleClipper(),
      child: Container(
        padding: const EdgeInsets.all(35),
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
      ..addRRect(RRect.fromLTRBR(
        0,
        20,
        size.width,
        size.height - 20,
        const Radius.circular(20),
      ));

    path.moveTo(size.width / 2 - 15, size.height - 20);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width / 2, size.height - 20);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
