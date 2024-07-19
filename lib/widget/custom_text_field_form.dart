import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomTextFieldForm extends StatelessWidget {
  CustomTextFieldForm({
    required this.formKey,
    required this.icon,
    required this.onSaved,
    required this.validator,
    this.obscureText,
    super.key,
  });

  int formKey;
  Icon icon;
  FormFieldSetter onSaved;
  FormFieldValidator validator;
  bool? obscureText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey(formKey),
      decoration: InputDecoration(
        prefixIcon: icon,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
      validator: validator,
      onSaved: onSaved,
      obscureText: obscureText ?? false,
    );
  }
}
