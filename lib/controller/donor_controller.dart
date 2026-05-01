import 'package:blood_bank_app/model/Donor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blood_bank_app/database/api/donor_api_service.dart';

class DonorController extends GetxController {
  final DonorApiService _apiService = DonorApiService();

  RxList<DonorModel> donors = <DonorModel>[].obs;
  Rxn<DonorModel> donor = Rxn<DonorModel>();
  RxList<DonorModel> filteredDonors = <DonorModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllDonors();
  }

  Future<void> fetchAllDonors() async {
    try {
      isLoading.value = true;
      final result = await _apiService.getAllDonors();
      donors.assignAll(result);
      filteredDonors.assignAll(result);
    } catch (e) {
      print('Error fetching donors: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDonorByUserId(String userId) async {
    try {
      isLoading.value = true;

      final DonorModel? donorData =
      await _apiService.getDonorByUserId(userId);

      donor.value = donorData;
    } catch (e) {
      debugPrint("Error fetching donor: $e");
      donor.value = null;
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> createDonorWithUserSync({
    required String userId,
    required String bloodGroup,
    String? lastDonationDateString,
    bool isActiveDonor = true,
    String? medicalNotes,
    required String street,
    required String city,
    required String state,
    required String country,
    required String postalCode,
  }) async {

    DateTime? lastDonationDate;
    if (lastDonationDateString != null && lastDonationDateString.isNotEmpty) {
      lastDonationDate = DateTime.tryParse(lastDonationDateString);  // ✅ Safer
    }

    final donor = DonorModel(
      userId: userId,
      name: 'TEMP',
      email: 'temp@temp.com',
      status: 'pending',
      bloodGroup: bloodGroup,
      lastDonationDate: lastDonationDate,
      isActiveDonor: isActiveDonor,
      medicalNotes: medicalNotes,
      street: street,
      city: city,
      state: state,
      country: country,
      postalCode: postalCode,
    );

    await _apiService.createDonor(donor);
    fetchAllDonors();
  }

  Future<void> updateDonor(DonorModel donor) async {
    await _apiService.updateDonor(donor);
    fetchAllDonors();
  }

  Future<void> deleteDonor(String donorId) async {
    await _apiService.deleteDonor(donorId);
    fetchAllDonors();
  }

  void searchDonorByName(String query) {
    if (query.isEmpty) {
      filteredDonors.assignAll(donors);
    } else {
      filteredDonors.assignAll(
        donors.where((donor) => donor.name.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }

  void clearSearch() {
    filteredDonors.assignAll(donors);
  }

  void filterByBloodGroup(String bloodGroup) {
    filteredDonors.assignAll(
      donors.where((donor) => donor.bloodGroup == bloodGroup),
    );
  }

  void filterByStatus(String status) {
    filteredDonors.assignAll(
      donors.where((donor) => donor.status == status),
    );
  }

  bool get isEmpty => donors.isEmpty;
  int get totalDonors => donors.length;
  List<DonorModel> get activeDonors => donors.where((d) => d.isActiveDonor).toList();
}
