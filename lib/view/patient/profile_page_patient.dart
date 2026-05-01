import 'package:blood_bank_app/controller/user_controller.dart';
import 'package:blood_bank_app/model/Patient.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blood_bank_app/controller/donor_controller.dart';
import 'package:blood_bank_app/model/Donor.dart';
import 'package:blood_bank_app/routes/app_routes.dart';

import '../../controller/patient_controller.dart';
import '../../model/User.dart';

class ProfileScreenPatient extends StatefulWidget {
  const ProfileScreenPatient({super.key});

  @override
  State<ProfileScreenPatient> createState() => _ProfileScreenPatientState();
}
// ... (imports remain the same)

class _ProfileScreenPatientState extends State<ProfileScreenPatient> {
  // Theme Palette
  final Color primaryRed = const Color(0xFFD3002D);
  final Color darkRedText = const Color(0xFF580000);
  final Color cardBg = const Color(0xFFF9FAFB);

  final PatientController _patientController = Get.put(PatientController());
  final UserController _userController =Get.put(UserController());

  late UserModel argsUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final args = Get.arguments;

    if (args is! UserModel) {
      Get.offAllNamed(AppRoutes.loginPatient);
      return;
    }

    argsUser = args;
    _patientController.fetchPatientByUserId(argsUser.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (_patientController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final patient = _patientController.patient.value;

        if (patient == null) {
          return const Scaffold(
            body: Center(child: Text("Patient data not found")),
          );
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildHeader(patient),
              const SizedBox(height: 25),
              _buildStatGrid(patient),
              const SizedBox(height: 25),

              // NEW: Detail Section (Address & Medical)
              _buildDetailsSection(patient),

              const SizedBox(height: 30),

              // Action Buttons
              _buildActionButtons(patient),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  // --- Header & Stats remain mostly the same as your code ---
  Widget _buildHeader(PatientModel patient) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage("https://cdn-icons-png.flaticon.com/512/147/147144.png"),
        ),
        const SizedBox(height: 15),
        Text(
          patient.name ?? "N/A",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: darkRedText),
        ),
        Text(patient.email, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildStatGrid(PatientModel patient) {
    return Row(
      children: [
        Expanded(child: _buildStatCard("Blood Group", patient.bloodGroup, Icons.bloodtype)),
        const SizedBox(width: 15),
        Expanded(child: _buildStatCard("Last Donated", _formatDate(patient.lastActiveAt), Icons.calendar_today)),
      ],
    );
  }

  // --- NEW: Detailed Information Section ---
  Widget _buildDetailsSection(PatientModel patient) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel("Address Information"),
        _buildInfoTile(
          icon: Icons.location_on_outlined,
          label: "Residential Address",
          value: "${patient.street ?? 'N/A'}\n${patient.city}, ${patient.state}, ${patient.country}",
        ),
        const SizedBox(height: 15),
        _buildSectionLabel("Medical Information"),
        _buildInfoTile(
          icon: Icons.health_and_safety_outlined,
          label: "Medical Notes",
          value: (patient.isCritical == null || patient.isCritical!)
              ? "No medical complications reported."
              : patient.patientId!,
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
      ),
    );
  }

  Widget _buildInfoTile({required IconData icon, required String label, required String value}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primaryRed, size: 22),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(value, style: TextStyle(fontSize: 14, color: Colors.grey.shade800, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- NEW: Grouped Action Buttons ---
  Widget _buildActionButtons(PatientModel patient) {
    return Column(
      children: [
        // EDIT BUTTON
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.editPersonalDetailDonor, arguments: patient),
            icon: const Icon(Icons.edit_note),
            label: const Text("Edit Profile Details"),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 15),
        // LOGOUT BUTTON
        SizedBox(
          width: double.infinity,
          height: 55,
          child: OutlinedButton.icon(
            onPressed: () => _userController.logout(),
            icon: const Icon(Icons.logout),
            label: const Text("Logout Account"),
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryRed,
              side: BorderSide(color: primaryRed.withOpacity(0.5)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
        ),
      ],
    );
  }

  // (Stat Card and Formatter remain as they were)
  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: primaryRed,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.8))),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "Never";
    return "${date.day}/${date.month}/${date.year}";
  }
}