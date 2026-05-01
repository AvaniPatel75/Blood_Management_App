import 'package:blood_bank_app/controller/user_controller.dart';
import 'package:blood_bank_app/controller/patient_controller.dart';
import 'package:blood_bank_app/routes/app_routes.dart';
import 'package:blood_bank_app/view/auth/user_roleclass.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_input_decoration.dart';
import '../../utils/text_style.dart';

class LoginScreenPatient extends StatefulWidget {
  const LoginScreenPatient({super.key});

  @override
  State<LoginScreenPatient> createState() => _LoginScreenPatientState();
}

class _LoginScreenPatientState extends State<LoginScreenPatient> {
  final UserController _userController = Get.put(UserController());

  // Role
  late UserRole selectedRole;

  // Form key
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

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
    super.dispose();
  }

  // ---------------- LOGIN ----------------
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    print("Login initiated for: $email");
    final user = await _userController.login(email, password);
    print("User Controller returned: ${user}");

    if (user != null) {
      if (user.role == 'patient') {
        print("User is a patient. Fetching profile for userId: ${user.id}");
        final PatientController patientController = Get.put(PatientController());
        await patientController.fetchPatientByUserId(user.id!);
        
        // Force update of state
        if (!mounted) return;
        setState(() => _isLoading = false);
        
        // Debug
        print("Patient Fetch Result: ${patientController.patient.value}");

        final patientProfile = patientController.patient.value;

        if (patientProfile != null) {
          print("Profile found. Navigating to Dashboard.");
          Get.toNamed(AppRoutes.patientDashboard, arguments: user);
        } else {
          print("Profile NOT found. Redirecting to Create Profile.");
          Get.snackbar("Notice", "Please complete your profile.");
          Get.toNamed(AppRoutes.createProfilePatient, arguments: user);
        }
      } else {
        print("Role mismatch. User role is: ${user.role}");
        if (!mounted) return;
        setState(() => _isLoading = false);
        Get.snackbar(
          "Login Failed",
          "This account is not registered as a Patient.",
          backgroundColor: AppColors.primaryRed,
          colorText: Colors.white,
        );
      }
    } else {
      print("Login failed. User is null (invalid credentials).");
      if (!mounted) return;
      setState(() => _isLoading = false);
      Get.snackbar(
        "Login Failed",
        "Invalid email or password",
        backgroundColor: AppColors.primaryRed,
        colorText: Colors.white,
      );
    }
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
                // Back button
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Get.toNamed('/role'),
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
                      "Login as ${selectedRole.name.toUpperCase()}",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.authHeader,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Email field
                Text("E-mail / Phone", style: AppTextStyles.subHeading),
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

                const SizedBox(height: 20),

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

                // Login button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
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

                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.signupPatient),
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

                // Skip button
                Center(
                  child: TextButton(
                    onPressed: () => Get.offNamed(AppRoutes.patientDashboard, arguments: null),
                    child: Text(
                      "Continue as Guest",
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
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png",
              height: 20,
            ),
            const SizedBox(width: 5),
            const Text("Sign in with Google"),
          ],
        ),
      ),
    );
  }
}
