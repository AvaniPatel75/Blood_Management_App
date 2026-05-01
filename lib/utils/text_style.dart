import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle authHeader = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    letterSpacing: 1,
  );

  static const heading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static const subHeading = TextStyle(
    fontSize: 16,
    color: AppColors.darkGrey,
  );

  static const button = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const inputHint = TextStyle(
    fontSize: 14,
    color: AppColors.darkGrey,
  );
}
