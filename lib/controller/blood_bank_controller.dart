import 'package:blood_bank_app/model/Blood_bank_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import '../database/api/bloodBank_api_service.dart';

class BloodBankController extends GetxController {
  final BloodBankApiService _apiService = BloodBankApiService();

  final Rx<BloodBankModel?> currentBloodBank = Rx<BloodBankModel?>(null);
  final RxBool isLoading = false.obs;
  final RxList<BloodBankModel> allBloodBanks = <BloodBankModel>[].obs;
  final RxList<BloodBankModel> nearbyBloodBanks = <BloodBankModel>[].obs;

  // ------------------ GEO CODING ------------------
  Future<void> fetchAllBloodBanks() async {
    try {
      isLoading.value = true;
      final banks = await _apiService.getAllBloodBanks();
      allBloodBanks.assignAll(banks);
    } catch (e) {
      Get.snackbar("Error", "Failed to load blood banks");
    } finally {
      isLoading.value = false;
    }
  }

  Future<BloodBankModel?> _attachLatLng(BloodBankModel bank) async {
    try {
      final address =
          "${bank.street}, ${bank.city}, ${bank.state}, "
          "${bank.postalCode}, ${bank.country}";

      final locations = await locationFromAddress(address);

      if (locations.isEmpty) return bank;

      return bank.copyWith(
        latitude: locations.first.latitude,
        longitude: locations.first.longitude,
      );
    } catch (e) {
      // If geocoding fails, save without lat/lng
      return bank;
    }
  }
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return await Geolocator.getCurrentPosition();
  }

  // ---------------- NEARBY FILTER ----------------

  Future<void> loadNearbyBloodBanks({double radiusKm = 10}) async {
    try {
      isLoading.value = true;

      final position = await _getCurrentLocation();

      nearbyBloodBanks.assignAll(
        allBloodBanks.where((bank) {
          if (bank.latitude == null || bank.longitude == null) return false;

          final distance = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            bank.latitude!,
            bank.longitude!,
          );

          return (distance / 1000) <= radiusKm;
        }).toList(),
      );
    } catch (e) {
      Get.snackbar("Error", "Unable to fetch nearby blood banks");
    } finally {
      isLoading.value = false;
    }
  }

  // ------------------ GET PROFILE ------------------

  Future<void> fetchBloodBankProfile(String userId) async {
    try {
      isLoading.value = true;

      final bank = await _apiService.getBloodBankByUserId(userId);
      currentBloodBank.value = bank;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load blood bank profile');
    } finally {
      isLoading.value = false;
    }
  }

  // ------------------ CREATE / UPDATE ------------------

  Future<void> saveBloodBankProfile(BloodBankModel bank) async {
    try {
      isLoading.value = true;

      // Attach latitude & longitude before saving
      final updatedBank = await _attachLatLng(bank);

      if (updatedBank == null) {
        Get.snackbar('Error', 'Unable to fetch location');
        return;
      }

      if (currentBloodBank.value != null) {
        await _apiService.updateBloodBank(updatedBank);
      } else {
        await _apiService.createBloodBank(updatedBank);
      }

      currentBloodBank.value = updatedBank;

      Get.snackbar('Success', 'Profile saved successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save profile');
    } finally {
      isLoading.value = false;
    }
  }

  // ------------------ DELETE ------------------

  Future<void> deleteBloodBank(String bloodBankId) async {
    try {
      isLoading.value = true;

      await _apiService.deleteBloodBank(bloodBankId);
      currentBloodBank.value = null;

      Get.snackbar('Success', 'Blood bank deleted');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete blood bank');
    } finally {
      isLoading.value = false;
    }
  }
}
