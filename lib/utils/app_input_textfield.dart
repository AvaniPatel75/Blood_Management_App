import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_input_style.dart';

class AppInputField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool readOnly;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onTap;

  const AppInputField({
    super.key,
    required this.hint,
    required this.icon,
    required this.controller,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onTap: onTap,
        decoration: AppInputStyles.inputDecoration(
          hint: hint,
          icon: icon,
          readOnly: readOnly,
        ),
      ),
    );
  }
}
