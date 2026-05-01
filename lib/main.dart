import 'package:blood_bank_app/bindings.dart';
import 'package:blood_bank_app/routes/app_pages.dart';
import 'package:blood_bank_app/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blood Bank App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.splashPage,
      getPages: AppPages.pages,
        class DonorOtpScreen extends GetView<DonorAuthController> {
    final String email;
    final String password;
    late final List<TextEditingController> _otpControllers;
    late final List<FocusNode> _focusNodes;

    const DonorOtpScreen({
    super.key,
    required this.email,
    required this.password,
    });

    @override
    void onInit() {
    super.onInit();
    _otpControllers = List.generate(6, (index) => TextEditingController());
    _focusNodes = List.generate(6, (index) => FocusNode());
    }

    @override
    void dispose() {
    for (var controller in _otpControllers) {
    controller.dispose();
    }
    for (var node in _focusNodes) {
    node.dispose();
    }
    super.dispose();
    }

    @override
    Widget build(BuildContext context) {
    return Scaffold(
    // ... same UI as before ...
    body: SafeArea(
    child: SingleChildScrollView(
    child: Padding(
    padding: const EdgeInsets.all(24),
    child: Column(children: [
    // ... same header content ...

    const SizedBox(height: 40),

    // ✅ FIXED: Proper OTP controllers
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: List.generate(6, (index) {
    return SizedBox(
    width: 50,
    height: 60,
    child: TextFormField(
    controller: _otpControllers[index], // ✅ FIXED!
    focusNode: _focusNodes[index],
    keyboardType: TextInputType.number,
    textAlign: TextAlign.center,
    maxLength: 1,
    style: const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.red[800],
    ),
    decoration: InputDecoration(
    counterText: '',
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Colors.grey[300]!),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Colors.red[400]!, width: 2),
    ),
    ),
    inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
    ],
    onChanged: (value) {
    if (value.length == 1 && index < 5) {
    _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
    _focusNodes[index - 1].requestFocus();
    }
    },
    ),
    );
    }),
    ),

    // ... rest of UI ...
    ]),
    ),
    ),
    ),
    );
    }

    // ✅ FIXED: Working OTP Logic!
    Future<void> _verifyOtp() async {
    // ✅ CORRECT WAY: Get OTP from OUR controllers
    String otp = _otpControllers.map((c) => c.text).join();

    if (otp.length != 6) {
    Get.snackbar(
    'Error ❌',
    'Please enter complete 6-digit OTP',
    backgroundColor: Colors.red[600],
    colorText: Colors.white,
    snackPosition: SnackPosition.TOP,
    );
    return;
    }

    // ✅ CALL YOUR CONTROLLER METHOD
    final isValid = await controller.verifyOtp(email: email, otp: otp);

    if (isValid) {
    // Navigate to registration
    Get.off(() => DonorRegistrationScreen(
    email: email,
    password: password,
    ));
    }
    }

    // ✅ FIXED: Working Resend Logic
    Future<void> _resendOtp() async {
    final result = await controller.sendOtp(email: email);

    if (result['success']) {
    // Clear OTP fields
    for (var controller in _otpControllers) {
    controller.clear();
    }
    _focusNodes[0].requestFocus();
    }
    }
    }
    );
  }
}
