import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppInputDecoration {
  /// Underline style used in all auth screens
  static InputDecoration underline({Widget? suffixIcon}) {
    return InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 10),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.primaryRed,
          width: 2,
        ),
      ),
      suffixIcon: suffixIcon,
    );
  }
}
