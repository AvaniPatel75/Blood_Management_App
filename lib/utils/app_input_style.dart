import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppInputStyles {
  static InputDecoration inputDecoration({
    required String hint,
    required IconData icon,
    bool readOnly = false,
  }) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.lightGrey,
      prefixIcon: Icon(
        icon,
        color: readOnly ? AppColors.darkGrey : AppColors.primaryRed,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.primaryRed,
          width: 2,
        ),
      ),
    );
  }
}
