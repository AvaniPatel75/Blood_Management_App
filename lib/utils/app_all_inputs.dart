import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_colors.dart';

class AppInputField {
  // ---------------- Back Button ----------------
  static Widget backButton({required VoidCallback onTap}) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: onTap,
    );
  }

  // ---------------- Back to Login ----------------
  static Widget backToLogin({
    required Color primaryColor,
    required VoidCallback onTap,
  }) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Already have an account? "),
          GestureDetector(
            onTap: onTap,
            child: Text(
              "Login",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Text Field ----------------
  static Widget textField({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      cursorColor: AppColors.primaryRed,
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryRed, width: 2),
        ),
      ),
    );
  }

  // ---------------- Password Field ----------------
  static Widget passwordField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback toggleVisibility,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        TextFormField(
          controller: controller,
          obscureText: !isVisible,
          validator: validator,
          cursorColor: AppColors.primaryRed,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: toggleVisibility,
            ),
            isDense: true,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryRed, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
