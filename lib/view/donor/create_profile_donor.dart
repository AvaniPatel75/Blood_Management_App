import 'package:blood_bank_app/database/api/donor_api_service.dart';
import 'package:blood_bank_app/model/Donor.dart';
import 'package:blood_bank_app/model/User.dart';
import 'package:blood_bank_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../controller/user_controller.dart';

class CreateProfileDonor extends StatefulWidget {
  const CreateProfileDonor({super.key});

  @override
  State<CreateProfileDonor> createState() => _CreateProfileDonorState();
}

class _CreateProfileDonorState extends State<CreateProfileDonor> {
  final _formKey = GlobalKey<FormState>();
  final DonorApiService _donorApi = DonorApiService();

  // USER (FROM SIGNUP)
  final _userController = Get.put(UserController());
  late UserModel user;
  late UserModel argsUser;
  // Controllers (Prefilled)
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _roleController = TextEditingController();

  // Donor fields
  final _lastDonationController = TextEditingController();
  final _medicalController = TextEditingController();

  // Address
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _postalController = TextEditingController();

  String _bloodGroup = 'A+';
  DateTime? _selectedLastDonation;

  final Color primaryRed = const Color(0xFFD32F2F);

  // ---------------- INIT ----------------
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeUser();
    });
    // // _nameController.text = user!.name;
    // // _emailController.text = user!.email;
    // // _roleController.text = user!.role.toUpperCase();
    // print("User from login donor to create profile screen donor ${Get.arguments}");

  }

  void _initializeUser() {
    final args = Get.arguments;

    if (args is! UserModel) {
      Get.back();
      Get.snackbar("Error", "User ID required");
      return;
    }

    user = args;

    // Prefill controllers
    _nameController.text = user.name;
    _emailController.text = user.email;
    _roleController.text = user.role.toLowerCase();
    _phoneController.text = user.phone;

    print("User ID in create profile: ${user.id}");
  }





  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    _lastDonationController.dispose();
    _medicalController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  // ---------------- DATE PICKER ----------------
  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 365)), // Last year max
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

  // ---------------- SUBMIT ----------------
  Future<void> _submitForm() async {
    print("User name form create profile page: ${user.name}");
    if (!_formKey.currentState!.validate()) return;
        print("${user.name}");
    try {
      double? lat;
      double? lng;
      
      try {
        String address = "${_streetController.text}, ${_cityController.text}, ${_stateController.text}, ${_countryController.text}, ${_postalController.text}";
        List<Location> locations = await locationFromAddress(address);
        if (locations.isNotEmpty) {
          lat = locations.first.latitude;
          lng = locations.first.longitude;
        }
      } catch (e) {
        print("Geocoding failed: $e, trying device location");
        try {
           Position pos = await Geolocator.getCurrentPosition();
           lat = pos.latitude;
           lng = pos.longitude;
        } catch (locationError) {
          print("Location fetch failed: $locationError");
        }
      }

      await _donorApi.createDonor(DonorModel(
        userId: user.id!,
        name: _nameController.text.trim(),
        email: user.email,
        status: user.status,
        bloodGroup: _bloodGroup,
        lastDonationDate: _selectedLastDonation,
        isActiveDonor: true,
        medicalNotes: _medicalController.text.trim().isEmpty ? null : _medicalController.text.trim(),
        street: _streetController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        country: _countryController.text.trim(),
        postalCode: _postalController.text.trim(),
        latitude: lat,
        longitude: lng,
      ));

      print("Donor Profile from door submit profile page ${Get.arguments}");
      Get.snackbar (
        "Success ✅",
        "Donor Profile Created Successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offNamed(AppRoutes.donorDashboard);
    } catch (e) {
      Get.snackbar("Error ❌", "Failed to create profile: $e",backgroundColor: Colors.white);
    }
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text("Create Donor Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: primaryRed,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _userInfoCard(),
              SizedBox(height: 24),
              _donorInfoCard(),
              SizedBox(height: 24),
              _addressCard(),
              SizedBox(height: 32),
              _submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- USER INFO CARD ----------------
  Widget _userInfoCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: primaryRed,
                  child: Icon(Icons.person, color: Colors.white, size: 30),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("User Info", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("Auto-filled from your account", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            _input(_nameController, "Name", Icons.person),
            _input(_phoneController, "Phone", Icons.phone, keyboardType: TextInputType.phone),
            _input(_emailController, "Email", Icons.email, readOnly: true),
            _input(_roleController, "Role", Icons.badge, readOnly: true),
          ],
        ),
      ),
    );
  }

  // ---------------- DONOR INFO CARD ----------------
  Widget _donorInfoCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Donor Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            _bloodDropdown(),
            _input(_lastDonationController, "Last Donation (Optional)", Icons.calendar_today, onTap: () => _selectDate(context)),
            _input(_medicalController, "Medical Notes (Optional)", Icons.notes),
          ],
        ),
      ),
    );
  }

  // ---------------- ADDRESS CARD ----------------
  Widget _addressCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Address", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            _input(_streetController, "Street", Icons.location_on),
            Row(
              children: [
                Expanded(child: _input(_cityController, "City", Icons.location_city)),
                SizedBox(width: 12),
                Expanded(child: _input(_stateController, "State", Icons.map)),
              ],
            ),
            Row(
              children: [
                Expanded(child: _input(_countryController, "Country", Icons.public)),
                SizedBox(width: 12),
                Expanded(child: _input(_postalController, "Postal Code", Icons.markunread_mailbox)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- INPUT HELPER ----------------
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


  Widget _bloodDropdown() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: _bloodGroup,
        validator: (v) => v == null ? "Blood group is required" : null,
        items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
            .map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(fontSize: 16))))
            .toList(),
        onChanged: (v) => setState(() => _bloodGroup = v!),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.bloodtype, color: primaryRed),
          hintText: "Select Blood Group",
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return SizedBox(
      height: 55,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 4,
        ),
        child: Text(
          "Create Donor Profile",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
