import 'package:blood_bank_app/controller/blood_request_controller.dart';
import 'package:blood_bank_app/controller/patient_controller.dart';
import 'package:blood_bank_app/view/patient/home_page_patient.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../model/Patient.dart';
import '../../model/Blood_request.dart';
import '../../utils/app_colors.dart'; // Assuming this exists or I define colors locally

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  String? _selectedBloodGroup;
  String? _selectedUrgency;

  final Color primaryRed = const Color(0xFFD3002D);
  final Color darkRedText = const Color(0xFF580000);

  final List<String> _bloodGroups = ['O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-'];
  final List<String> _urgencyLevels = ['Routine', 'Medium', 'High', 'Critical'];
  
  final BloodRequestController _requestController = Get.put(BloodRequestController());
  final PatientController _patientController = Get.put(PatientController());

  String? patientIdFromArgs;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    
    PatientModel? patient;
    if (args != null && args is PatientModel) {
      patient = args;
    } else {
        // Fallback to controller
        patient = _patientController.patient.value;
    }

    if (patient != null) {
      patientIdFromArgs = patient.userId; // Usually userId or patientId
      _nameController.text = patient.name;
      _selectedBloodGroup = patient.bloodGroup;
      print("Initialized Request Screen for Patient: ${patient.name}");
    }
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: primaryRed)),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dateController.text = "${picked.day}/${picked.month}/${picked.year}");
  }

  Future<void> _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: primaryRed)),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _timeController.text = picked.format(context));
  }

  void _submitRequest() {
    // 1. Resolve Patient ID
    final patient = _patientController.patient.value;
    final finalId = patient?.userId ?? patientIdFromArgs; // Using userId as requesterId for now

    if (finalId == null) {
      Get.snackbar("Error", "Could not identify patient. Please login again.");
      return;
    }

    // 2. Validation
    if (_selectedBloodGroup == null || _selectedUrgency == null || _dateController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all required fields");
      return;
    }

    try {
      final String requiredDate = "${_dateController.text} ${_timeController.text}".trim();
      
      final newRequest = BloodRequestModel(
        id: const Uuid().v4(),
        requesterId: finalId,
        bloodType: _selectedBloodGroup,
        urgency: _selectedUrgency,
        status: 'active',
        requiredDate: requiredDate,
      );

      _requestController.addBloodRequest(newRequest);
      
      Get.snackbar("Success", "Blood Request Created!");
      Get.offNamedUntil('/home_screen_patient', (route) => false); // Use appropriate route or Get.back()
      // Or just Go Back
      Navigator.of(context).pop();

    } catch (e) {
      Get.snackbar("Error", "Failed to create request: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          _buildFixedHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   _buildLabel("Patient Name"),
                  _buildTextField(controller: _nameController, hint: "Patient Name", readOnly: true),
                  const SizedBox(height: 16),

                  _buildLabel("Blood Type Needed"),
                  _buildDropdown(
                    value: _selectedBloodGroup,
                    items: _bloodGroups,
                    hint: "Select Blood Group",
                    onChanged: (val) => setState(() => _selectedBloodGroup = val),
                  ),
                  const SizedBox(height: 16),

                  _buildLabel("Urgency Level"),
                  _buildDropdown(
                    value: _selectedUrgency,
                    items: _urgencyLevels,
                    hint: "Select Urgency",
                    onChanged: (val) => setState(() => _selectedUrgency = val),
                  ),
                  const SizedBox(height: 16),

                  _buildLabel("Required Date"),
                  GestureDetector(
                    onTap: _selectDate,
                    child: AbsorbPointer(
                      child: _buildTextField(controller: _dateController, hint: "Select Date", suffixIcon: Icons.calendar_today),
                    ),
                  ),
                   const SizedBox(height: 16),
                   
                   _buildLabel("Required Time (Optional)"),
                   GestureDetector(
                    onTap: _selectTime,
                    child: AbsorbPointer(
                      child: _buildTextField(controller: _timeController, hint: "Select Time", suffixIcon: Icons.access_time),
                    ),
                  ),

                  const SizedBox(height: 40),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _submitRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryRed,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 5,
                      ),
                      child: const Text("Submit Request", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFixedHeader() {
    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      decoration: BoxDecoration(
        color: primaryRed,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Text("Back", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Create Request", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text("Request blood for yourself or others", style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0, left: 4),
    child: Text(text, style: TextStyle(color: Colors.grey.shade700, fontSize: 14, fontWeight: FontWeight.bold)),
  );

  Widget _buildTextField({required TextEditingController controller, IconData? suffixIcon, String? hint, bool readOnly = false}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))]),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          filled: true,
          fillColor: readOnly ? Colors.grey.shade100 : Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: primaryRed, size: 20) : null,
        ),
      ),
    );
  }

  Widget _buildDropdown({required String? value, required List<String> items, required String hint, required Function(String?) onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))]),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
          isExpanded: true,
          items: items.map((String item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}