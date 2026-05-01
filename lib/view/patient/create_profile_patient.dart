import 'package:blood_bank_app/controller/patient_controller.dart';
import 'package:blood_bank_app/controller/user_controller.dart';
import 'package:blood_bank_app/database/api/patient_spi_service.dart';
import 'package:blood_bank_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../model/Patient.dart';
import '../../model/User.dart';

class CreateProfilePatientScreen extends StatefulWidget {
  const CreateProfilePatientScreen({super.key});

  @override
  State<CreateProfilePatientScreen> createState() =>
      _CreateProfilePatientScreenState();
}

class _CreateProfilePatientScreenState
    extends State<CreateProfilePatientScreen> {
  final _formKey = GlobalKey<FormState>();

  final PatientController _patientController = Get.put(PatientController());
  final _userController = Get.put(UserController());

  // Controllers
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final statusCtrl = TextEditingController();
  final roleCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final bloodGroupCtrl = TextEditingController();
  final medicalCtrl = TextEditingController();
  final emergencyCtrl = TextEditingController();
  final streetCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final countryCtrl = TextEditingController();
  final postalCtrl = TextEditingController();
  final genderCtrl = TextEditingController();
  final ageCtrl = TextEditingController();

  bool isCritical = false;

  final Color primaryRed = const Color(0xFFD32F2F);
  late UserModel user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeUser();
    });
  }

  void _initializeUser() {
    final args = Get.arguments;

    if (args is! UserModel) {
      Get.back();
      return;
    }

    user = args;

    emailCtrl.text = user.email;
    statusCtrl.text = user.status;
    roleCtrl.text = user.role;
    phoneCtrl.text = user.phone;
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    statusCtrl.dispose();
    roleCtrl.dispose();
    phoneCtrl.dispose();
    bloodGroupCtrl.dispose();
    medicalCtrl.dispose();
    emergencyCtrl.dispose();
    streetCtrl.dispose();
    cityCtrl.dispose();
    stateCtrl.dispose();
    countryCtrl.dispose();
    postalCtrl.dispose();
    genderCtrl.dispose();
    ageCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
      await _patientController.createPatientWithUserSync(
        userId: user.id!,
        email:  user.email,
        name: nameCtrl.text.trim(),
        status: user.status,
        gender: genderCtrl.text.trim().isEmpty ? "unknown" : genderCtrl.text.trim(),
        age: ageCtrl.text.trim().isEmpty ? 0 : int.parse(ageCtrl.text.trim()),
        bloodGroup: bloodGroupCtrl.text.trim().isEmpty ? "NA" : bloodGroupCtrl.text.trim(),
        medicalCondition: medicalCtrl.text.trim().isEmpty ? "none" : medicalCtrl.text.trim(),
        emergencyContact: emergencyCtrl.text.trim().isEmpty
            ? phoneCtrl.text
            : emergencyCtrl.text.trim(),
        street: streetCtrl.text.trim(),
        city: cityCtrl.text.trim(),
        state: stateCtrl.text.trim(),
        country: countryCtrl.text.trim(),
        postalCode: postalCtrl.text.trim(),
      );
      PatientModel patient=PatientModel(
          userId: user.id!,
          name: nameCtrl.text.trim(),
          email: user.email,
          status: user.status,
          gender: genderCtrl.text.trim(),
          age: int.tryParse(ageCtrl.text.trim()) ?? 18,
          bloodGroup: bloodGroupCtrl.text.trim(),
          medicalCondition: medicalCtrl.text.trim(),
          emergencyContact: emergencyCtrl.text.trim(),
          street: streetCtrl.text.trim(),
          city: cityCtrl.text.trim(),
          state: stateCtrl.text.trim(),
          country: countryCtrl.text.trim(),
          postalCode: postalCtrl.text.trim()
      );
      UserModel updatedUser=UserModel(name: nameCtrl.text.trim(), email: user.email, phone: phoneCtrl.text.trim(), role: user.role, status: user.status);
      await _userController.updateUser(updatedUser);

      Get.offNamed(AppRoutes.patientDashboard,arguments: patient);
    }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: BoxDecoration(
              color: primaryRed,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.offNamed(AppRoutes.signupPatient);
                        },
                        child: const Icon(Icons.arrow_back_ios,
                            color: Colors.white),
                      ),
                      const Text(
                        "Patient Profile",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text("1/1",
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                  const SizedBox(height: 25),
                  const CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 52,
                      backgroundImage: NetworkImage(
                        'https://static.vecteezy.com/system/resources/thumbnails/029/271/062/small/avatar-profile-icon-in-flat-style-male-user-profile-illustration-on-isolated-background-man-profile-sign-business-concept-vector.jpg',
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.1),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        _field("Full Name", nameCtrl, Icons.person),
                        _field("Email", emailCtrl, Icons.email, readOnly: true),
                        _field("Status", statusCtrl, Icons.stars, readOnly: true),
                        _field("Role", roleCtrl, Icons.badge, readOnly: true),
                        _field("Phone", phoneCtrl, Icons.phone,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ]),
                        _field("Gender", genderCtrl, Icons.person_outline),
                        _field("Age", ageCtrl, Icons.cake,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ]),
                        _field("Blood Group", bloodGroupCtrl, Icons.water_drop),
                        _field(
                            "Medical Condition", medicalCtrl, Icons.healing),
                        _field(
                            "Emergency Contact", emergencyCtrl, Icons.call),
                        SwitchListTile(
                          value: isCritical,
                          onChanged: (v) => setState(() => isCritical = v),
                          title: const Text("Critical Patient"),
                          activeColor: primaryRed,
                        ),
                        const Divider(),
                        _field("Street", streetCtrl, Icons.home),
                        _field("City", cityCtrl, Icons.location_city),
                        _field("State", stateCtrl, Icons.map),
                        _field("Country", countryCtrl, Icons.flag),
                        _field("Postal Code", postalCtrl,
                            Icons.local_post_office),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryRed,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              "Save Profile",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
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

  Widget _field(
      String hint,
      TextEditingController controller,
      IconData icon, {
        bool readOnly = false,
        TextInputType keyboardType = TextInputType.text,
        List<TextInputFormatter>? inputFormatters,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(icon,
              color: readOnly ? Colors.grey : Colors.grey[700]),
          hintText: hint,
        ),
      ),
    );
  }
}
