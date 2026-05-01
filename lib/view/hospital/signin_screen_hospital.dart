import 'package:blood_bank_app/controller/user_controller.dart';
import 'package:blood_bank_app/model/User.dart';
import 'package:blood_bank_app/routes/app_routes.dart';
import 'package:blood_bank_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blood_bank_app/view/auth/user_roleclass.dart';

import '../../utils/text_style.dart';

class SignUpScreenHospital extends StatefulWidget {
  const SignUpScreenHospital({super.key});

  @override
  State<SignUpScreenHospital> createState() => _SignUpScreenHospitalState();
}

class _SignUpScreenHospitalState extends State<SignUpScreenHospital> {
  final _formKey = GlobalKey<FormState>();
  final UserController _userController = Get.find<UserController>();

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  // UI state
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  late final UserRole selectedRole;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    selectedRole = args is UserRole ? args : UserRole.hospital;
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

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() => _isLoading = false);

    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      name: "",
      phone: "",
      status: "ACTIVE",
      role: "hospital",
    );

    _userController.addUser(newUser);

    Get.snackbar(
      "Success",
      "Account Created Successfully",
      backgroundColor: AppColors.primaryRed,
      colorText: Colors.white,
    );

    Get.offNamed(
      AppRoutes.createProfileHospital,
      arguments: {'user': newUser},
    );
  }

  // ---------------- UI HELPERS ----------------
  Widget _backButton() {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Get.back(),
    );
  }

  Widget _header() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primaryRed,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryRed.withOpacity(0.3),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Text(
          "Sign Up as ${selectedRole.name.toUpperCase()}",
          style: AppTextStyles.authHeader,
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(text, style: AppTextStyles.subHeading);
  }

  InputDecoration _inputDecoration() {
    return const InputDecoration(
      isDense: true,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.primaryRed, width: 2),
      ),
    );
  }

  Widget _passwordField({
    required String label,
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback toggleVisibility,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        TextFormField(
          controller: controller,
          obscureText: !isVisible,
          cursorColor: AppColors.primaryRed,
          validator: validator,
          decoration: _inputDecoration().copyWith(
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

  Widget _googleButton() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: InkWell(
        onTap: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png",
              height: 24,
            ),
            const SizedBox(width: 8),
            const Text("Sign in with Google"),
          ],
        ),
      ),
    );
  }

  // ---------------- BUILD ----------------
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
                _backButton(),
                const SizedBox(height: 30),

                _header(),
                const SizedBox(height: 40),

                _label("Email"),
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
                  decoration: _inputDecoration(),
                ),

                const SizedBox(height: 25),

                _passwordField(
                  label: "Password",
                  controller: _passwordController,
                  isVisible: _isPasswordVisible,
                  toggleVisibility: () =>
                      setState(() => _isPasswordVisible = !_isPasswordVisible),
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

                _passwordField(
                  label: "Confirm Password",
                  controller: _confirmPasswordController,
                  isVisible: _isConfirmPasswordVisible,
                  toggleVisibility: () => setState(() =>
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
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

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _isLoading ? null : _signUpWithEmail,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Create Account",
                      style: AppTextStyles.button,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                _googleButton(),

                const SizedBox(height: 40),

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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
