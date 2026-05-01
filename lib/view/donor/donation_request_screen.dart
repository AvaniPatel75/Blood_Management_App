import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:blood_bank_app/controller/blood_request_controller.dart';
import 'package:blood_bank_app/model/Blood_request.dart';
import 'package:blood_bank_app/model/Patient.dart';
import 'package:uuid/uuid.dart';

class CreateDonationRequestScreen extends StatefulWidget {
  const CreateDonationRequestScreen({super.key});

  @override
  State<CreateDonationRequestScreen> createState() => _CreateDonationRequestScreenState();
}

class _CreateDonationRequestScreenState extends State<CreateDonationRequestScreen> {
  // --- Controllers ---
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _unitsController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  // --- State Variables ---
  String? _selectedBloodGroup;
  String? _selectedUrgency;

  // --- Theme Colors ---
  final Color primaryRed = const Color(0xFFD3002D);
  final Color darkRedText = const Color(0xFF580000);

  // --- Data Lists ---
  final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final List<String> _urgencyLevels = ['Normal', 'Urgent', 'Emergency'];

  // --- Pickers ---
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(colorScheme: ColorScheme.light(primary: primaryRed)),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _dateController.text = "${picked.day}/${picked.month}/${picked.year}");
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(colorScheme: ColorScheme.light(primary: primaryRed)),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _timeController.text = picked.format(context));
    }
  }

  final BloodRequestController _requestController = Get.find<BloodRequestController>();
  PatientModel? patient;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is PatientModel) {
      patient = args;
      _patientNameController.text = patient!.name;
    }
  }

  void _submitRequest() {
    if (_patientNameController.text.isEmpty || _selectedBloodGroup == null || _unitsController.text.isEmpty) {
      Get.snackbar("Error", "Please fill in all mandatory fields",
          backgroundColor: Colors.red.withOpacity(0.1), colorText: Colors.red);
      return;
    }

    // Create Request Model
    final newRequest = BloodRequestModel(
      id: const Uuid().v4(),
      requesterId: patient?.patientId ?? 'Guest', // Fallback if guest
      bloodType: _selectedBloodGroup,
      urgency: _selectedUrgency ?? 'Normal',
      status: 'Pending',
      requiredDate: "${_dateController.text} ${_timeController.text}",
    );

    // Call Controller
    _requestController.addBloodRequest(newRequest);

    // Get.back(); // Already handled by logic or snackbar above? No, controller usually handles it? 
    // The previously existing log had Get.back() at the end.
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Prevents keyboard from causing overflow
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // 1. FIXED HEADER
          _buildHeader(),

          // 2. SCROLLABLE FORM SECTION
          // Expanded ensures this part takes remaining space and is scrollable
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Patient Name"),
                  _buildTextField(controller: _patientNameController, hint: "Enter full name"),
                  const SizedBox(height: 16),

                  _buildLabel("Blood Group"),
                  _buildDropdown(
                    value: _selectedBloodGroup,
                    items: _bloodGroups,
                    hint: "Select Group",
                    onChanged: (val) => setState(() => _selectedBloodGroup = val),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel("Units"),
                            _buildTextField(controller: _unitsController, keyboardType: TextInputType.number, hint: "Qty"),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel("Urgency"),
                            _buildDropdown(
                              value: _selectedUrgency,
                              items: _urgencyLevels,
                              hint: "Level",
                              onChanged: (val) => setState(() => _selectedUrgency = val),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildLabel("Hospital Name"),
                  _buildTextField(controller: _hospitalNameController, hint: "Location", suffixIcon: Icons.local_hospital),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel("Date"),
                            GestureDetector(
                                onTap: _selectDate,
                                child: AbsorbPointer(child: _buildTextField(controller: _dateController, suffixIcon: Icons.calendar_today))
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel("Time"),
                            GestureDetector(
                                onTap: _selectTime,
                                child: AbsorbPointer(child: _buildTextField(controller: _timeController, suffixIcon: Icons.access_time))
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // SUBMIT BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _submitRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryRed,
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text("Post Request", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 50), // Safe area at bottom
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 180,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: primaryRed,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            const SizedBox(height: 10),
            const Text("Create Request", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
            const Text("Fill the details below to request blood", style: TextStyle(color: Colors.white70, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 4),
      child: Text(text, style: TextStyle(color: darkRedText, fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTextField({required TextEditingController controller, String? hint, TextInputType keyboardType = TextInputType.text, IconData? suffixIcon}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.white,
          suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: primaryRed, size: 20) : null,
        ),
      ),
    );
  }

  Widget _buildDropdown({required String? value, required List<String> items, required String hint, required Function(String?) onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
          isExpanded: true,
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}