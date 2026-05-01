import 'package:blood_bank_app/controller/user_controller.dart';
import 'package:blood_bank_app/routes/app_routes.dart';
import 'package:blood_bank_app/view/auth/user_roleclass.dart';
import 'package:blood_bank_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_button.dart';
import '../../utils/text_style.dart';

class LoginScreenBank extends StatefulWidget {
  const LoginScreenBank({super.key});

  @override
  State<LoginScreenBank> createState() => _LoginScreenBankState();
}

class _LoginScreenBankState extends State<LoginScreenBank> {
  final _formKey = GlobalKey<FormState>();
  final UserController _userController = Get.put(UserController());

  late UserRole selectedRole;

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

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
    super.dispose();
  }

  // ---------------- LOGIN ----------------
  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final user = await _userController.login(email, password);
    debugPrint('User: $user from login screen of bank');
    if (user == null) {
      Get.snackbar(
        "Login Failed",
        "Invalid Blood Bank credentials",
        backgroundColor: Colors.red.shade100,
      );
      return;
    }

    Get.offNamed(
      AppRoutes.bloodBankDashboard,
      arguments: [user,selectedRole],
    );
  }

  // ---------------- UI HELPERS ----------------
  Widget _backButton() {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Get.back(),
    );
  }

  Widget _passwordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Password", style: AppTextStyles.subHeading),
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          cursorColor: AppColors.primaryRed,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Password is required";
            }
            if (value.length < 6) {
              return "Password must be at least 6 characters";
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
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(
                        () => _isPasswordVisible = !_isPasswordVisible);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade400)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text("OR"),
        ),
        Expanded(child: Divider(color: Colors.grey.shade400)),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _backButton(),
                const SizedBox(height: 20),

                // HEADER
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color:
                          AppColors.primaryRed.withOpacity(0.3),
                          offset: const Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Text(
                      "Login as ${selectedRole.name.toUpperCase()}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // EMAIL
                Text("Blood Bank email",
                    style: AppTextStyles.subHeading),
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
                      borderSide:
                      BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: AppColors.primaryRed, width: 2),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // PASSWORD
                _passwordField(),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(color: AppColors.primaryRed),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // LOGIN BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: AppButtons.primary,
                    onPressed: _login,
                    child: const Text(
                      "Login",
                      style: AppTextStyles.button,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                _divider(),

                const SizedBox(height: 30),

                _googleButton(),

                const SizedBox(height: 40),

                // SIGN UP
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('/signup/${selectedRole.name}');
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: AppColors.primaryRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // SKIP
                Center(
                  child: TextButton(
                    onPressed: () =>
                        Get.offNamed(AppRoutes.bloodBankDashboard),
                    child: Text(
                      "Skip Now",
                      style: TextStyle(
                        color: AppColors.primaryRed,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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
