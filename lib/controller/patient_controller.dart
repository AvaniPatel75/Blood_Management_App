// UPDATED PatientController.dart - Auto-sync user data
import 'package:blood_bank_app/controller/user_controller.dart';
import 'package:blood_bank_app/database/api/patient_spi_service.dart';
import 'package:blood_bank_app/model/Patient.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class PatientController extends GetxController {
  final PatientApiService _apiService = PatientApiService();

  RxList<PatientModel> patients = <PatientModel>[].obs;
  RxList<PatientModel> filteredPatients = <PatientModel>[].obs;
  RxBool isLoading = false.obs;
  final _userController = Get.find<UserController>();
  Rxn<PatientModel> patient = Rxn<PatientModel>();

  @override
  void onInit() {
    super.onInit();
    fetchAllPatients();
  }

  Future<void> fetchAllPatients() async {
    try {
      isLoading.value = true;

      final result = await _apiService.getAllPatients();

      await Future.wait(
        result.map((p) => _syncPatientWithUser(p)),
      );

      patients.assignAll(result);
      filteredPatients.assignAll(result);
    } catch (e) {
      print('Error fetching patients: $e');
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> fetchPatientByUserId(String userId) async {
    try {
      isLoading.value = true;
      final result = await _apiService.getPatientByUserId(userId);
      patient.value = result;
      print(' patient data from controller get by id ${patient.value}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _syncPatientWithUser(PatientModel patient) async {
    final user = await _userController.getUserById(patient.userId);

    if (user != null) {
      patient.name = user.name;
      patient.email = user.email;
      patient.status = user.status;
    }
  }

  Future<void> createPatientWithUserSync({
    required String userId,
    required String email,
    required String name,
    required String status,
    required String gender, 
    required int age,
    required String bloodGroup,
    required String medicalCondition,
    required String emergencyContact,
    required String street,
    required String city,
    required String state,
    required String country,
    required String postalCode,
    double? latitude,
    double? longitude,
  }) async {
    // 🔁 Get user FIRST
    final user = await _userController.getUserById(userId);

    if (user == null) {
      throw Exception("User not found for patient creation");
    }

    // Auto-calculate lat/long if not provided
    if (latitude == null || longitude == null) {
        try {
          String address = "$street, $city, $state, $country, $postalCode";
          List<Location> locations = await locationFromAddress(address);
          if (locations.isNotEmpty) {
            latitude = locations.first.latitude;
            longitude = locations.first.longitude;
          }
        } catch (e) {
            print("Geocoding failed for patient: $e");
             try {
               Position pos = await Geolocator.getCurrentPosition();
               latitude = pos.latitude;
               longitude = pos.longitude;
            } catch (locationError) {
              print("Location fetch failed: $locationError");
            }
        }
    }

    final patient = PatientModel(
      userId: userId,
      name: name,
      email: user.email,
      status: user.status,
      gender: gender,
      age: age,
      bloodGroup: bloodGroup,
      medicalCondition: medicalCondition,
      emergencyContact: emergencyContact,
      street: street,
      city: city,
      state: state,
      country: country,
      postalCode: postalCode,
      latitude: latitude,
      longitude: longitude,
    );

    await _apiService.createPatient(patient);
    await fetchAllPatients();
  }


  // Other methods unchanged...
  Future<void> addPatient(PatientModel patient) async {
    await _apiService.createPatient(patient);
    fetchAllPatients();
  }

  Future<void> deletePatient(String patientId) async {
    await _apiService.deletePatient(patientId);
    fetchAllPatients();
  }

  Future<void> updatePatient(PatientModel patient) async {
    await _apiService.updatePatient(patient);  // ✅ RE-SYNC USER DATA
    fetchAllPatients();
  }

  void searchPatientByName(String query) {
    if (query.isEmpty) {
      filteredPatients.assignAll(patients);
    } else {
      filteredPatients.assignAll(
        patients.where((patient) =>
            patient.name.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }

  void clearSearch() {
    filteredPatients.assignAll(patients);
  }

  bool get isEmpty => patients.isEmpty;
  int get totalPatients => patients.length;
}
