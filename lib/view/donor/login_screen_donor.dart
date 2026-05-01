import 'package:blood_bank_app/controller/user_controller.dart';
import 'package:blood_bank_app/routes/app_routes.dart';
import 'package:blood_bank_app/utils/app_colors.dart';
import 'package:blood_bank_app/view/auth/user_roleclass.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/donor_controller.dart';
import '../../utils/app_input_decoration.dart';
import '../../utils/text_style.dart';

class LoginScreenDonor extends StatefulWidget {
  const LoginScreenDonor({super.key});

  @override
  State<LoginScreenDonor> createState() => _LoginScreenDonorState();
}

class _LoginScreenDonorState extends State<LoginScreenDonor> {
  final _formKey = GlobalKey<FormState>();
  final UserController _userController = Get.put(UserController(),permanent: true);

  late UserRole selectedRole;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;


  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    selectedRole = args is UserRole ? args : UserRole.donor;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String rolePath(UserRole role) => role.name;

  void _login() async{
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final user = await _userController.login(email, password);
    print('User: $user from login screen of donor');
    // final donorProfile=
    if (user == null) {
      Get.snackbar(
        "Login Failed",
        "Invalid Donor credentials",
        backgroundColor: Colors.red.shade100,
      );
      return;
    }

    // final donorController = Get.find<DonorController>();
    // donorController.donor.value = DonorModel(
    //   donorId: user.id,
    //   name: user.name,
    //   email: user.email,
    //   // Add other fields from your user object as needed
    // );
    //jemin@123
    // // 2. SAFE NAVIGATION: Use a zero delay to bypass the !_debugLocked error
    Future.delayed(Duration.zero, () {
      Get.offNamed(AppRoutes.donorDashboard, arguments: user);
    });
  }

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
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Get.toNamed('/role'),
                ),

                const SizedBox(height: 20),

                // HEADER
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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

                // EMAIL
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

                // PASSWORD
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
                  decoration: AppInputDecoration.underline().copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () =>
                          setState(() => _isPasswordVisible = !_isPasswordVisible),
                    ),
                  ),
                ),

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
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () =>
                          Get.toNamed('/signup/${rolePath(selectedRole)}'),
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

                Center(
                  child: TextButton(
                    onPressed: () =>
                        Get.offNamed(AppRoutes.donorDashboard, arguments: null),
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
              height: 20,
            ),
            const SizedBox(width: 8),
            const Text("Sign in with Google"),
          ],
        ),
      ),
    );
  }
}
