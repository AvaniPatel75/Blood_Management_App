import 'package:blood_bank_app/controller/user_controller.dart';
import 'package:blood_bank_app/model/User.dart';
import 'package:blood_bank_app/routes/app_routes.dart';
import 'package:blood_bank_app/utils/app_colors.dart';
import 'package:blood_bank_app/view/auth/user_roleclass.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_input_decoration.dart';
import '../../utils/text_style.dart';

class SignUpScreenPatient extends StatefulWidget {
  const SignUpScreenPatient({super.key});

  @override
  State<SignUpScreenPatient> createState() => _SignUpScreenPatientState();
}

class _SignUpScreenPatientState extends State<SignUpScreenPatient> {
  final _formKey = GlobalKey<FormState>();
  final UserController _userController = Get.put(UserController());

  // Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // UI state
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  late final UserRole selectedRole;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    selectedRole = args is UserRole ? args : UserRole.patient;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ---------------- SIGN UP ----------------
  void _signUpWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      name: "",
      phone: "",
      status: 'ACTIVE',
      role: selectedRole.name,
    );

    await _userController.addUser(user);

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      Get.snackbar(
        "Success",
        "Account Created Successfully",
        backgroundColor: AppColors.primaryRed,
        colorText: Colors.white,
      );

      Get.offNamed(AppRoutes.createProfilePatient, arguments: user);
    });
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Get.back(),
                ),
                const SizedBox(height: 30),

                // Header
                Center(
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.shade200.withOpacity(0.5),
                          offset: const Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Text(
                      "Sign Up as ${selectedRole.name.toUpperCase()}",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.authHeader,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Email field
                Text("E-mail / Phone Number", style: AppTextStyles.subHeading),
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
                  decoration: AppInputDecoration.underline(),
                ),
                const SizedBox(height: 25),

                // Password field
                _passwordField(
                  label: "Password",
                  controller: _passwordController,
                  isVisible: _isPasswordVisible,
                  toggleVisibility: () =>
                      setState(() => _isPasswordVisible = !_isPasswordVisible),
                ),

                // Confirm password field
                _passwordField(
                  label: "Confirm Password",
                  controller: _confirmPasswordController,
                  isVisible: _isConfirmPasswordVisible,
                  toggleVisibility: () => setState(
                          () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                ),

                const SizedBox(height: 40),

                // Create account button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signUpWithEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Create Account",
                      style: AppTextStyles.button,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Back to login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: AppColors.primaryRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- HELPERS ----------------
  Widget _passwordField({
    required String label,
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback toggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.subHeading),
        TextFormField(
          controller: controller,
          obscureText: !isVisible,
          cursorColor: AppColors.primaryRed,
          validator: (value) {
            if (value == null || value.isEmpty) return "$label is required";
            if (label == "Password" && value.length < 6) {
              return "Password must be at least 6 characters";
            }
            if (label == "Confirm Password" &&
                value != _passwordController.text) {
              return "Passwords do not match";
            }
            return null;
          },
          decoration: AppInputDecoration.underline().copyWith(
            suffixIcon: IconButton(
              icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: toggleVisibility,
            ),
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}
