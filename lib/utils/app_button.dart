import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'package:blood_bank_app/utils/text_style.dart';

class AppButtons {
  static ButtonStyle primary = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryRed,
    foregroundColor: AppColors.white,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  );

  static Widget primaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 55,
      child: ElevatedButton(
        style: primary,
        onPressed: onPressed,
        child: Text(text, style: AppTextStyles.button),
      ),
    );
  }
}
