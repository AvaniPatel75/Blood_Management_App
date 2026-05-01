import 'package:blood_bank_app/controller/user_controller.dart';
import 'package:blood_bank_app/model/User.dart';
import 'package:blood_bank_app/routes/app_routes.dart';
import 'package:blood_bank_app/view/auth/user_roleclass.dart';
import 'package:blood_bank_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../utils/app_button.dart';
import '../../utils/text_style.dart';

class SignUpScreenBank extends StatefulWidget {
  const SignUpScreenBank({super.key});

  @override
  State<SignUpScreenBank> createState() => _SignUpScreenBankState();
}

class _SignUpScreenBankState extends State<SignUpScreenBank> {
  final UserController _userController = Get.find<UserController>();
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  late final UserRole selectedRole;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    selectedRole = args is UserRole ? args : UserRole.bloodBank;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // -------------------- SIGN UP --------------------
  void _signUpWithEmail() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      final now = DateTime.now();

      final user = UserModel(
        id: const Uuid().v4(),
        email: _emailController.text.trim(),
        role: selectedRole.name,
        status: "PENDING",
        password: _passwordController.text.trim(),
        name: "",
        phone: "",
        createdAt: now,
        updatedAt: now,
        lastActiveAt: now,
      );

      _userController.addUser(user);

      Get.snackbar(
        "Success",
        "Account created successfully",
        backgroundColor: AppColors.primaryRed,
        colorText: Colors.white,
      );

      Get.offNamed(
        AppRoutes.createProfileBloodBank,
        arguments: {"user": user},
      );
    });
  }

  // -------------------- UI HELPERS --------------------
  Widget _backButton() {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Get.back(),
    );
  }

  Widget _passwordField({
    required String label,
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback toggleVisibility,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.subHeading),
        TextFormField(
          controller: controller,
          obscureText: !isVisible,
          cursorColor: AppColors.primaryRed,
          validator: validator,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide:
              BorderSide(color: AppColors.primaryRed, width: 2),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
                size: 20,
              ),
              onPressed: toggleVisibility,
            ),
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  // -------------------- BUILD --------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _backButton(),
                const SizedBox(height: 30),

                // HEADER
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Sign Up as ${selectedRole.name.toUpperCase()}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // EMAIL
                Text("Email", style: AppTextStyles.subHeading),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: AppColors.primaryRed,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Email is required";
                    }
                    if (!GetUtils.isEmail(value.trim())) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: AppColors.primaryRed, width: 2),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // PASSWORD
                _passwordField(
                  label: "Password",
                  controller: _passwordController,
                  isVisible: _isPasswordVisible,
                  toggleVisibility: () => setState(
                          () => _isPasswordVisible = !_isPasswordVisible),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),

                // CONFIRM PASSWORD
                _passwordField(
                  label: "Confirm Password",
                  controller: _confirmPasswordController,
                  isVisible: _isConfirmPasswordVisible,
                  toggleVisibility: () => setState(() =>
                  _isConfirmPasswordVisible =
                  !_isConfirmPasswordVisible),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Confirm your password";
                    }
                    if (value != _passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 40),

                // BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: AppButtons.primary,
                    onPressed: _isLoading ? null : _signUpWithEmail,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Create Account",
                      style: AppTextStyles.button,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
