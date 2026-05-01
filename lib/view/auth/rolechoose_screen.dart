import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'user_roleclass.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Who are you?",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              _roleButton("Patient", Icons.person, UserRole.patient),
              _roleButton("Donor", Icons.bloodtype, UserRole.donor),
              _roleButton("Blood Bank", Icons.food_bank, UserRole.bloodBank),
              _roleButton("Hospital", Icons.apartment, UserRole.hospital),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleButton(String title, IconData icon, UserRole role) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ElevatedButton.icon(
        onPressed: () => Get.toNamed('/login/${role.name}', arguments: role),
        icon: Icon(icon),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 55),
          backgroundColor: const Color(0xFFD3002D),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }
}
