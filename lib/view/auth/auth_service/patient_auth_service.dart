import 'package:google_sign_in/google_sign_in.dart';

class AuthServicePatient {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  Future<void> handleGoogleSignIn() async {
    try {
      // 1. Open the Google Account Picker
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        // 2. Get details from the account
        print("User Name: ${googleUser.displayName}");
        print("User Email: ${googleUser.email}");
        print("User Photo: ${googleUser.photoUrl}");

        // 3. Optional: Get Authentication tokens
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        print("ID Token: ${googleAuth.idToken}");

        // 4. Send to your PatientApiService
        // Example:
        // await PatientApiService().syncGooglePatient({
        //   "name": googleUser.displayName,
        //   "email": googleUser.email,
        //   "googleId": googleUser.id
        // });

        // 5. Navigate to Home Screen
        // Get.offAllNamed(AppRoutes.homeScreenPatient);
      }
    } catch (error) {
      print("Google Sign-In Error: $error");
    }
  }
}