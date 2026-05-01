import 'package:blood_bank_app/controller/user_controller.dart';
import 'package:blood_bank_app/routes/app_routes.dart';
import 'package:blood_bank_app/view/auth/user_roleclass.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreenHospital extends StatefulWidget {
  const LoginScreenHospital({super.key});

  @override
  State<LoginScreenHospital> createState() => _LoginScreenHospitalState();
}

class _LoginScreenHospitalState extends State<LoginScreenHospital> {
  UserController _userController=Get.find<UserController>();
  // 🔐 SAFE role variable
  late UserRole selectedRole;

  // Form key
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _hospitalEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // UI state
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  // Colors
  final Color primaryRed = const Color(0xFFD3002D);

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    selectedRole = args is UserRole ? args : UserRole.hospital;
  }

  @override
  void dispose() {
    _hospitalEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String rolePath(UserRole role) => role.name; // donor, patient, hospital, bloodBank

  // -------------------- LOGIN --------------------
  void _login() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 0), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      final email = _hospitalEmailController.text.trim();
      final password = _passwordController.text.trim();

      final user=_userController.login(email, password);
      if (user == null) {
        Get.snackbar(
          "Login Failed",
          "Invalid Blood Bank credentials",
          backgroundColor: Colors.red.shade100,
        );
        return;
      }

      Get.snackbar(
        "Success",
        "Login Successful",
        backgroundColor: primaryRed,
        colorText: Colors.white,
      );

      // Navigate to dashboard
      Get.toNamed('/dashboard/$selectedRole');
    });
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Get.toNamed('/role'),
                ),
                const SizedBox(height: 20),

                // HEADER
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: primaryRed,
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
                      "Login as ${selectedRole.name.toUpperCase()}",
                      textAlign: TextAlign.center,
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

                // EMAIL FIELD
                _buildLabel("Hospital Email"),
                TextFormField(
                  controller: _hospitalEmailController,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: primaryRed,
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

                // PASSWORD FIELD
                _buildLabel("Password"),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  cursorColor: primaryRed,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Password is required";
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                  decoration: _inputDecoration().copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(color: primaryRed),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // LOGIN BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                _divider(),
                const SizedBox(height: 30),

                _googleButton(),

                const SizedBox(height: 40),

                // SIGN UP LINK
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () => Get.toNamed('/signup/${rolePath(selectedRole)}'),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: primaryRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // SKIP BUTTON
                Center(
                  child: TextButton(
                    onPressed: () => Get.offNamed(AppRoutes.hospitalDashboard),
                    child: Text(
                      "Skip Now",
                      style: TextStyle(
                        color: primaryRed,
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

  // ----------------- UI HELPERS -----------------
  Widget _buildLabel(String text) => Text(
    text,
    style: TextStyle(color: Colors.grey.shade700),
  );

  Widget _divider() => Row(
    children: [
      Expanded(child: Divider(color: Colors.grey.shade400)),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Text("OR"),
      ),
      Expanded(child: Divider(color: Colors.grey.shade400)),
    ],
  );

  Widget _googleButton() => Container(
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

  InputDecoration _inputDecoration() => InputDecoration(
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade400),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: primaryRed, width: 2),
    ),
  );
}
