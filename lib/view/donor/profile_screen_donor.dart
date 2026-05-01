import 'package:blood_bank_app/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blood_bank_app/controller/donor_controller.dart';
import 'package:blood_bank_app/model/Donor.dart';
import 'package:blood_bank_app/routes/app_routes.dart';

class ProfileScreenDonor extends StatefulWidget {
  const ProfileScreenDonor({super.key});

  @override
  State<ProfileScreenDonor> createState() => _ProfileScreenDonorState();
}
// ... (imports remain the same)

class _ProfileScreenDonorState extends State<ProfileScreenDonor> {
  // Theme Palette
  final Color primaryRed = const Color(0xFFD3002D);
  final Color darkRedText = const Color(0xFF580000);
  final Color cardBg = const Color(0xFFF9FAFB);

  final DonorController _donorController = Get.put(DonorController());
  final UserController _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        final donor = _donorController.donor.value;

        if (donor == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildHeader(donor),
              const SizedBox(height: 25),
              _buildStatGrid(donor),
              const SizedBox(height: 25),

              // NEW: Detail Section (Address & Medical)
              _buildDetailsSection(donor),

              const SizedBox(height: 30),

              // Action Buttons
              _buildActionButtons(donor),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  // --- Header & Stats remain mostly the same as your code ---
  Widget _buildHeader(DonorModel donor) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage("https://cdn-icons-png.flaticon.com/512/147/147144.png"),
        ),
        const SizedBox(height: 15),
        Text(
          donor.name ?? "N/A",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: darkRedText),
        ),
        Text(donor.email, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildStatGrid(DonorModel donor) {
    return Row(
      children: [
        Expanded(child: _buildStatCard("Blood Group", donor.bloodGroup, Icons.bloodtype)),
        const SizedBox(width: 15),
        Expanded(child: _buildStatCard("Last Donated", _formatDate(donor.lastDonationDate), Icons.calendar_today)),
      ],
    );
  }

  // --- NEW: Detailed Information Section ---
  Widget _buildDetailsSection(DonorModel donor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel("Address Information"),
        _buildInfoTile(
          icon: Icons.location_on_outlined,
          label: "Residential Address",
          value: "${donor.street ?? 'N/A'}\n${donor.city}, ${donor.state}, ${donor.country}",
        ),
        const SizedBox(height: 15),
        _buildSectionLabel("Medical Information"),
        _buildInfoTile(
          icon: Icons.health_and_safety_outlined,
          label: "Medical Notes",
          value: (donor.medicalNotes == null || donor.medicalNotes!.isEmpty)
              ? "No medical complications reported."
              : donor.medicalNotes!,
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
  Widget _buildActionButtons(DonorModel donor) {
    return Column(
      children: [
        // EDIT BUTTON
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.editPersonalDetailDonor, arguments: donor),
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