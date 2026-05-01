import 'package:blood_bank_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/Donor.dart'; // Ensure correct path
import '../../database/api/donor_api_service.dart';

class EditPersonalInfoDonor extends StatefulWidget {
  const EditPersonalInfoDonor({super.key});

  @override
  State<EditPersonalInfoDonor> createState() => _EditPersonalInfoDonorState();
}

class _EditPersonalInfoDonorState extends State<EditPersonalInfoDonor> {
  final _formKey = GlobalKey<FormState>();
  final DonorApiService _donorApi = DonorApiService();

  // Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _medicalController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _postalController = TextEditingController();
  final _lastDonationController = TextEditingController();

  String _bloodGroup = 'A+';
  DateTime? _selectedLastDonation;
  late DonorModel donor; // The existing profile data

  final Color primaryRed = const Color(0xFFD32F2F);

  @override
  void initState() {
    super.initState();
    _prefillData();
  }

  void _prefillData() {
    // Expecting DonorModel to be passed via Get.arguments
    final args = Get.arguments;

    if (args is DonorModel) {
      donor = args;

      // Pre-filling the controllers
      _nameController.text = donor.name;
      _emailController.text = donor.email;// Assuming phone might be in DonorModel
      _medicalController.text = donor.medicalNotes ?? "";
      _streetController.text = donor.street ?? "";
      _cityController.text = donor.city ?? "";
      _stateController.text = donor.state ?? "";
      _countryController.text = donor.country ?? "";
      _postalController.text = donor.postalCode ?? "";
      _bloodGroup = donor.bloodGroup;

      if (donor.lastDonationDate != null) {
        _selectedLastDonation = donor.lastDonationDate;
        _lastDonationController.text =
        "${donor.lastDonationDate!.day}/${donor.lastDonationDate!.month}/${donor.lastDonationDate!.year}";
      }
    } else {
      Get.back();
      Get.snackbar("Error", "No profile data found to edit");
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _medicalController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _postalController.dispose();
    _lastDonationController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // Create updated model
      DonorModel updatedDonor = DonorModel(
        userId: donor.userId,
        donorId: donor.donorId,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        status: 'ACTIVE',
        bloodGroup: _bloodGroup,
        lastDonationDate: _selectedLastDonation,
        medicalNotes: _medicalController.text.trim(),
        street: _streetController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        country: _countryController.text.trim(),
        postalCode: _postalController.text.trim(),
        isActiveDonor: true,
      );

      // Call your API update method (Ensure you have an updateDonor method)
      await _donorApi.updateDonor(updatedDonor);

      Get.snackbar("Success ✅", "Profile updated successfully!",
          backgroundColor: Colors.green, colorText: Colors.white);

      Get.to(AppRoutes.donorDashboard,arguments: updatedDonor); // Return updated data
    } catch (e) {
      Get.snackbar("Error ❌", "Update failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Edit Personal Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: primaryRed,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _sectionCard("Basic Information", Icons.person, [
                _input(_nameController, "Name", Icons.person),
                _input(_phoneController, "Phone", Icons.phone, keyboardType: TextInputType.phone),
                _input(_emailController, "Email", Icons.email, readOnly: true),
              ]),
              const SizedBox(height: 16),
              _sectionCard("Donor Status", Icons.bloodtype, [
                _bloodDropdown(),
                _input(_lastDonationController, "Last Donation Date", Icons.calendar_today,
                    onTap: () => _selectDate(context), readOnly: true),
                _input(_medicalController, "Medical Notes", Icons.notes),
              ]),
              const SizedBox(height: 16),
              _sectionCard("Location", Icons.location_on, [
                _input(_streetController, "Street", Icons.location_on),
                Row(
                  children: [
                    Expanded(child: _input(_cityController, "City", Icons.location_city)),
                    const SizedBox(width: 10),
                    Expanded(child: _input(_stateController, "State", Icons.map)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _input(_countryController, "Country", Icons.public)),
                    const SizedBox(width: 10),
                    Expanded(child: _input(_postalController, "Postal Code", Icons.markunread_mailbox)),
                  ],
                ),
              ]),
              const SizedBox(height: 32),
              _saveButton(),
            ],
          ),
        ),
      ),
    );
  }

  // UI Components matching your style
  Widget _sectionCard(String title, IconData icon, List<Widget> children) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: primaryRed),
                const SizedBox(width: 10),
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 25),
            ...children,
          ],
        ),
      ),
    );
  }

  // Your existing Input Helper logic
  Widget _input(TextEditingController controller, String hint, IconData icon,
      {bool readOnly = false, VoidCallback? onTap, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        validator: (v) => (v == null || v.isEmpty) && !readOnly ? "$hint is required" : null,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: primaryRed),
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _bloodDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: _bloodGroup,
        items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) => setState(() => _bloodGroup = v!),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.bloodtype, color: primaryRed),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedLastDonation ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedLastDonation = picked;
        _lastDonationController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _updateProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: const Text("Save Changes", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}