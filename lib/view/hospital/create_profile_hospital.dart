import 'package:blood_bank_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateProfileHospital extends StatefulWidget {
  const CreateProfileHospital({super.key});

  @override
  State<CreateProfileHospital> createState() => _CreateProfileHospitalState();
}

class _CreateProfileHospitalState extends State<CreateProfileHospital> {
  final _formKey = GlobalKey<FormState>();
  final Color primaryRed = const Color(0xFFD73535);

  // --- Controllers ---
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  final _websiteController = TextEditingController();

  final _licenseController = TextEditingController();
  final _authorityController = TextEditingController();
  final _expiryController = TextEditingController();
  DateTime? _selectedExpiry;

  final _openingTimeController = TextEditingController();
  final _closingTimeController = TextEditingController();
  bool _is24x7 = true;

  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _postalController = TextEditingController();

  final _totalBedsController = TextEditingController();

  List<String> _selectedDepartments = [];
  final List<String> _departmentOptions = [
    "Emergency", "Cardiology", "Neurology", "Pediatrics",
    "Oncology", "Hematology", "Surgery", "ICU"
  ];

  @override
  void initState() {
    super.initState();
    // Prefill email if passed from previous screen
    final args = Get.arguments;
    if (args is Map && args['email'] != null) {
      _emailController.text = args['email'];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _emergencyPhoneController.dispose();
    _websiteController.dispose();
    _licenseController.dispose();
    _authorityController.dispose();
    _expiryController.dispose();
    _openingTimeController.dispose();
    _closingTimeController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _postalController.dispose();
    _totalBedsController.dispose();
    super.dispose();
  }

  // ------------------- Helpers -------------------
  Widget _inputField(TextEditingController controller, String hint, IconData icon,
      {TextInputType type = TextInputType.text, bool readOnly = false, VoidCallback? onTap, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: type,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey, size: 20),
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFF2F2F2),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _cardWrapper(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2045),
    );
    if (picked != null) {
      setState(() {
        _selectedExpiry = picked;
        _expiryController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDepartments.isEmpty) {
        Get.snackbar("Error", "Select at least one department", snackPosition: SnackPosition.BOTTOM, backgroundColor: primaryRed, colorText: Colors.white);
        return;
      }

      Get.snackbar(
        "Success",
        "Hospital profile created!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: primaryRed,
        colorText: Colors.white,
      );

      // TODO: Map to HospitalModel and save
      // final hospital = HospitalModel(...);

      Get.offNamed(AppRoutes.hospitalDashboard);
    }
  }

  // ------------------- UI -------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: primaryRed,
        elevation: 0,
        title: const Text("Hospital Registration"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildSectionHeader("Official Information"),
                _buildLegalCard(),
                _buildSectionHeader("Capacity & Departments"),
                _buildCapacityCard(),
                _buildSectionHeader("Contact & Operations"),
                _buildOperationalCard(),
                _buildSectionHeader("Location"),
                _buildAddressCard(),
                const SizedBox(height: 30),
                _buildSubmitButton(),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, bottom: 10, left: 5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: TextStyle(color: primaryRed, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }

  Widget _buildLegalCard() {
    return _cardWrapper([
      _inputField(_nameController, "Hospital Name", Icons.business, validator: (val) => val!.isEmpty ? "Required" : null),
      _inputField(_licenseController, "License Number", Icons.verified, validator: (val) => val!.isEmpty ? "Required" : null),
      _inputField(_authorityController, "Registered Authority", Icons.gavel, validator: (val) => val!.isEmpty ? "Required" : null),
      _inputField(
        _expiryController,
        "License Expiry Date",
        Icons.calendar_today,
        readOnly: true,
        onTap: () => _selectDate(context),
        validator: (val) => val!.isEmpty ? "Select expiry date" : null,
      ),
    ]);
  }

  Widget _buildCapacityCard() {
    return _cardWrapper([
      _inputField(_totalBedsController, "Total Beds", Icons.bed, type: TextInputType.number, validator: (val) {
        if (val == null || val.isEmpty) return "Required";
        if (int.tryParse(val) == null || int.parse(val) <= 0) return "Invalid number";
        return null;
      }),
      const SizedBox(height: 10),
      const Text("Departments", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      const SizedBox(height: 10),
      Wrap(
        spacing: 8,
        children: _departmentOptions.map((dept) {
          final isSelected = _selectedDepartments.contains(dept);
          return FilterChip(
            label: Text(dept),
            selected: isSelected,
            selectedColor: primaryRed.withOpacity(0.2),
            onSelected: (val) {
              setState(() {
                val ? _selectedDepartments.add(dept) : _selectedDepartments.remove(dept);
              });
            },
          );
        }).toList(),
      ),
    ]);
  }

  Widget _buildOperationalCard() {
    return _cardWrapper([
      _inputField(_emailController, "Official Email", Icons.email, type: TextInputType.emailAddress, validator: (val) => val!.isEmpty || !GetUtils.isEmail(val) ? "Invalid email" : null),
      _inputField(_phoneController, "General Contact", Icons.phone, type: TextInputType.phone, validator: (val) => val!.isEmpty || !GetUtils.isPhoneNumber(val) ? "Invalid phone" : null),
      _inputField(_emergencyPhoneController, "ER Hotline", Icons.emergency, type: TextInputType.phone, validator: (val) => val!.isEmpty || !GetUtils.isPhoneNumber(val) ? "Invalid phone" : null),
      _inputField(_websiteController, "Website (Optional)", Icons.language),
      SwitchListTile(
        title: const Text("Emergency / 24x7 Services", style: TextStyle(fontSize: 14)),
        value: _is24x7,
        activeColor: primaryRed,
        onChanged: (val) => setState(() => _is24x7 = val),
      ),
    ]);
  }

  Widget _buildAddressCard() {
    return _cardWrapper([
      _inputField(_streetController, "Street Address", Icons.location_on, validator: (val) => val!.isEmpty ? "Required" : null),
      Row(
        children: [
          Expanded(child: _inputField(_cityController, "City", Icons.location_city, validator: (val) => val!.isEmpty ? "Required" : null)),
          const SizedBox(width: 10),
          Expanded(child: _inputField(_postalController, "Postal", Icons.local_post_office, type: TextInputType.number, validator: (val) => val!.isEmpty ? "Required" : null)),
        ],
      ),
      _inputField(_stateController, "State", Icons.map, validator: (val) => val!.isEmpty ? "Required" : null),
      _inputField(_countryController, "Country", Icons.public, validator: (val) => val!.isEmpty ? "Required" : null),
    ]);
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: primaryRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        onPressed: _submitForm,
        child: const Text("Complete Profile", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
