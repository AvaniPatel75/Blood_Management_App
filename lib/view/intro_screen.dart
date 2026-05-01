import 'package:blood_bank_app/view/auth/user_roleclass.dart';
import 'package:blood_bank_app/view/donor/home_page_donor.dart';
import 'package:blood_bank_app/view/hospital/signin_screen_hospital.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  // Exact colors from your design
  final Color primaryRed = const Color(0xFFFD7979); // The deep red
  final Color darkRedText = const Color(0xFFFF3838); // The dark text color

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 200, // Height of the wave area
            child: CustomPaint(
              painter: WavePainter(color: primaryRed),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  // SKIP BUTTON
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextButton(
                        onPressed: () {

                          print("Skip pressed");
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Skip now",
                              style: TextStyle(
                                color: darkRedText,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Icon(Icons.arrow_forward, size: 18, color: darkRedText),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),

                  // LOGO & TEXT
                  Image.network(
                    'https://thumbs.dreamstime.com/b/blood-donation-logo-hand-drop-symbol-represents-act-giving-life-offering-support-symbolizing-essential-gift-380842329.jpg',
                    height: 120,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'BLOOD\nBANK',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900, // Extra bold
                      color: darkRedText,
                      letterSpacing: 1.5,
                      height: 1.0, // Tighter line height like the logo
                    ),
                  ),

                  const Spacer(flex: 3),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton(
                      onPressed: () {
                        Get.toNamed('/login', arguments: UserRole.patient);

                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: primaryRed, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF3838),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // CREATE ACCOUNT BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed('/signup');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF3838),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Spacing to push buttons up slightly from the wave
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final Color color;

  WavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint1 = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    Path path1 = Path();
    path1.moveTo(0, size.height * 0.6);
    path1.quadraticBezierTo(
      size.width * 0.25, size.height * 0.4,
      size.width * 0.5, size.height * 0.6,
    );
    path1.quadraticBezierTo(
      size.width * 0.75, size.height * 0.8,
      size.width, size.height * 0.5,
    );
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();
    canvas.drawPath(path1, paint1);

    Paint paint2 = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    Path path2 = Path();
    path2.moveTo(0, size.height * 0.7);
    path2.quadraticBezierTo(
      size.width * 0.25, size.height * 0.85,
      size.width * 0.5, size.height * 0.65,
    );
    path2.quadraticBezierTo(
      size.width * 0.75, size.height * 0.45, // Control point
      size.width, size.height * 0.6, // End point
    );
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}