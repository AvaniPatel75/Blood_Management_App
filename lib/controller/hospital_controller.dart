import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import '../model/Hospital.dart';

class HospitalController extends GetxController {
  // ------------------ STATE ------------------

  final RxList<HospitalModel> _allHospitals = <HospitalModel>[].obs;
  final RxList<HospitalModel> hospitals = <HospitalModel>[].obs;

  final Rxn<HospitalModel> selectedHospital = Rxn<HospitalModel>();

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // ------------------ GEO ------------------

  Future<HospitalModel?> _attachLatLng(HospitalModel hospital) async {
    try {
      final address =
          "${hospital.street}, ${hospital.city}, ${hospital.state}, "
          "${hospital.postalCode}, ${hospital.country}";

      final locations = await locationFromAddress(address);

      if (locations.isEmpty) return null;

      return hospital.copyWith(
        latitude: locations.first.latitude,
        longitude: locations.first.longitude,
      );
    } catch (e) {
      errorMessage.value = e.toString();
      return null;
    }
  }

  // ------------------ GET ------------------

  List<HospitalModel> getAll() => hospitals;

  HospitalModel? getById(String id) {
    return hospitals.firstWhereOrNull((h) => h.hospitalId == id);
  }

  // ------------------ ADD ------------------

  Future<void> addHospital(HospitalModel hospital) async {
    try {
      isLoading.value = true;

      final updated = await _attachLatLng(hospital);
      if (updated == null) return;

      _allHospitals.add(updated);
      hospitals.assignAll(_allHospitals);
    } finally {
      isLoading.value = false;
    }
  }

  // ------------------ UPDATE ------------------

  Future<void> updateHospital(HospitalModel hospital) async {
    try {
      isLoading.value = true;

      final updated = await _attachLatLng(hospital);
      if (updated == null) return;

      final index =
      _allHospitals.indexWhere((h) => h.hospitalId == hospital.hospitalId);

      if (index != -1) {
        _allHospitals[index] = updated;
        hospitals.assignAll(_allHospitals);
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ------------------ DELETE ------------------

  void deleteHospital(String id) {
    _allHospitals.removeWhere((h) => h.hospitalId == id);
    hospitals.assignAll(_allHospitals);
  }

  // ------------------ FILTERS ------------------

  void filterByCity(String city) {
    hospitals.assignAll(
      _allHospitals.where((h) => h.city.toLowerCase() == city.toLowerCase()),
    );
  }

  void filterByState(String state) {
    hospitals.assignAll(
      _allHospitals.where((h) => h.state.toLowerCase() == state.toLowerCase()),
    );
  }

  void filterByCountry(String country) {
    hospitals.assignAll(
      _allHospitals.where((h) => h.country.toLowerCase() == country.toLowerCase()),
    );
  }

  void filterByActive(bool isActive) {
    hospitals.assignAll(
      _allHospitals.where((h) => h.isActive == isActive),
    );
  }

  void filterByVerified(bool isVerified) {
    hospitals.assignAll(
      _allHospitals.where((h) => h.isVerified == isVerified),
    );
  }

  // ------------------ CLEAR ------------------

  void clearFilters() {
    hospitals.assignAll(_allHospitals);
  }

  // ------------------ SELECT ------------------

  void selectHospital(HospitalModel hospital) {
    selectedHospital.value = hospital;
  }

  void clearSelection() {
    selectedHospital.value = null;
  }
}
