import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blood_bank_app/model/blood_bank_model.dart';
import 'package:blood_bank_app/model/User.dart';
import 'package:blood_bank_app/routes/app_routes.dart';

class CreateProfileBloodBank extends StatefulWidget {
  const CreateProfileBloodBank({super.key});

  @override
  State<CreateProfileBloodBank> createState() =>
      _CreateProfileBloodBankState();
}

class _CreateProfileBloodBankState extends State<CreateProfileBloodBank> {
  final _formKey = GlobalKey<FormState>();
  final Color primaryRed = const Color(0xFFD32F2F);

  // ---------------- USER FROM SIGNUP ----------------
  late UserModel user;

  // ---------------- USER CONTROLLERS ----------------
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _roleController = TextEditingController();
  final _statusController = TextEditingController();

  // ---------------- BLOOD BANK CONTROLLERS ----------------
  final _licenseController = TextEditingController();
  final _authorityController = TextEditingController();
  final _expiryController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();

  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _postalController = TextEditingController();

  final _openingTimeController = TextEditingController();
  final _closingTimeController = TextEditingController();
  final _capacityController = TextEditingController();

  DateTime? _selectedExpiry;
  bool _is24x7 = false;

  // ---------------- INIT ----------------
  @override
  @override
  void initState() {
    super.initState();

    final args = Get.arguments;
    if (args != null && args['user'] != null) {
      user = args['user'] as UserModel;

      debugPrint('User from arguments: ${user.toMap()}');

      _nameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phone;
      _roleController.text = user.role.toUpperCase();
      _statusController.text = user.status;
    }
  }


  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _roleController.dispose();
    _statusController.dispose();
    _licenseController.dispose();
    _authorityController.dispose();
    _expiryController.dispose();
    _emergencyPhoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _postalController.dispose();
    _openingTimeController.dispose();
    _closingTimeController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  // ---------------- DATE PICKER ----------------
  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2040),
    );

    if (picked != null) {
      setState(() {
        _selectedExpiry = picked;
        _expiryController.text =
        "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  // ---------------- SUBMIT ----------------
  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();

    final updatedUser = UserModel(
      id: user.id,   // ✅ KEEP SAME UUID
      name: _nameController.text.trim(),
      email: user.email,
      phone: _phoneController.text.trim(),
      role: user.role,
      status: "ACTIVE",
      password: user.password,
      createdAt: user.createdAt,
      updatedAt: now,
      lastActiveAt: now,
    );




    /// 2️⃣ CREATE BLOOD BANK MODEL
    final bloodBank = BloodBankModel(
      userId: updatedUser.id!,
      licenseNumber: _licenseController.text.trim(),
      licenseExpiryDate: _selectedExpiry ?? now,
      registeredAuthority: _authorityController.text.trim(),
      street: _streetController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      country: _countryController.text.trim(),
      postalCode: _postalController.text.trim(),
      emergencyPhone: _emergencyPhoneController.text.trim(),
      is24x7: _is24x7,
      workingDays: const ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"],
      openingTime: _openingTimeController.text,
      closingTime: _closingTimeController.text,
      bloodStock: const {
        "A+":0,"A-":0,"B+":0,"B-":0,"O+":0,"O-":0,"AB+":0,"AB-":0
      },
      dailyCapacity: int.tryParse(_capacityController.text) ?? 0,
      availableUnitsToday: 0,
      termsAccepted: true,
      termsAcceptedAt: now,
      createdAt: now,
      updatedAt: now,
    );

    /// 3️⃣ SAVE BOTH (SQLite / API later)
    // userRepository.updateUser(updatedUser);
    // bloodBankRepository.insertBloodBank(bloodBank);

    Get.snackbar("Success", "Blood Bank Profile Created");
    Get.offNamed(AppRoutes.bloodBankDashboard);
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: primaryRed,
        title: const Text("Create Blood Bank Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _section("Account Info", [
                _input(_nameController, "Bank Name", Icons.business, readOnly: true),
                _input(_emailController, "Email", Icons.email, readOnly: true),
                _input(_phoneController, "Phone", Icons.phone,keyboardType: TextInputType.phone),
                _input(_roleController, "Role", Icons.badge, readOnly: true),
                _input(_statusController, "Status", Icons.info, readOnly: true),
              ]),
              _section("License", [
                _input(_licenseController, "License Number", Icons.verified_user),
                _input(_authorityController, "Authority", Icons.gavel),
                _input(_expiryController, "Expiry Date", Icons.calendar_today,
                    readOnly: true, onTap: _selectDate),
              ]),
              _section("Address", [
                _input(_streetController, "Street", Icons.location_on),
                _input(_cityController, "City", Icons.location_city),
                _input(_stateController, "State", Icons.map),
                _input(_countryController, "Country", Icons.public),
                _input(_postalController, "Postal Code", Icons.markunread_mailbox),
              ]),
              _section("Operations", [
                _input(_emergencyPhoneController, "Emergency Phone", Icons.phone),
                _input(_capacityController, "Daily Capacity", Icons.inventory,
                    keyboardType: TextInputType.number),
              ]),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryRed,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    "Create Profile",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- HELPERS ----------------
  Widget _section(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(title,
              style: TextStyle(
                  color: primaryRed,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _input(
      TextEditingController controller,
      String hint,
      IconData icon, {
        bool readOnly = false,
        VoidCallback? onTap,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        validator: readOnly
            ? null
            : (v) => v == null || v.trim().isEmpty ? "$hint is required" : null,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: primaryRed),
          hintText: hint,
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

}
