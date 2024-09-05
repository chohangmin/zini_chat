import 'package:flutter/material.dart';

class SummitButton extends StatelessWidget {
  const SummitButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ButtonStyle(
        textStyle: WidgetStateProperty.all<TextStyle>(const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        )),
        backgroundColor:
            WidgetStateProperty.all<Color>(Colors.lightBlue.shade100),
      ),
      label:  Text(
        label,
      ),
    );
  }
}
