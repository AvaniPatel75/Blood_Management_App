import 'package:get/get.dart';
import 'package:blood_bank_app/model/donation.dart';
import 'package:blood_bank_app/database/api/donation_api_service.dart';
import 'package:blood_bank_app/controller/donor_controller.dart';

class DonationController extends GetxController {

  final DonationApiService _apiService = DonationApiService();

  DonorController get _donorController => Get.find<DonorController>();

  var donorHistory = <DonationModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    if (_donorController.donor.value != null) {
      refreshHistory();
    }
  }

  // The primary method to call from the UI
  // It safely checks for a donorId before querying the database.
  Future<void> refreshHistory() async {
    final donor = _donorController.donor.value;

    if (donor != null && donor.donorId != null) {
      print("Refreshing history for Donor ID: ${donor.donorId}");
      await fetchHistoryByDonor(donor.donorId);
    } else {
      print("Warning: Cannot refresh history. Donor ID is null.");
      // If donor is null, we might want to ensure the donor list is empty
      donorHistory.clear();
    }
  }


  Future<void> fetchHistoryByDonor(String donorId) async {
    try {
      isLoading.value = true;

      final result = await _apiService.getDonationsByDonorId(donorId);

      donorHistory.assignAll(result);

      print("Successfully fetched ${result.length} donation records.");
    } catch (e) {
      print("Error in fetchHistoryByDonor: $e");
      Get.snackbar(
          "History Error",
          "Failed to load your donation records.",
          snackPosition: SnackPosition.BOTTOM
      );
    } finally {
      isLoading.value = false;
    }
  }

  // donation_controller.dart

  Future<void> addDonation(DonationModel donation) async {
    try {
      await _apiService.createDonation(donation);
      await refreshHistory();

      print("Donation added with ID: ${donation.id}");
    } catch (e) {
      print("Error in Controller: $e");
      rethrow;
    }
  }

  Future<void> approveDonation(String donationId) async {
    try {
      isLoading.value = true;
      await _apiService.approveDonation(donationId);

      await refreshHistory();
    } catch (e) {
      Get.snackbar("Error", "Failed to approve: $e");
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> deleteDonation(String donationId) async {
    try {
      isLoading.value = true;
      // Call the delete method from your ApiService
      await _apiService.deleteDonation(donationId);

      // Refresh the list so the UI updates immediately
      await refreshHistory();

      Get.snackbar("Deleted", "Record removed successfully",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", "Could not delete record: $e");
    } finally {
      isLoading.value = false;
    }
  }
}