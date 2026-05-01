import 'package:get/get.dart';

import '../database/api/blood_request_service.dart';
import '../model/Blood_request.dart';

class BloodRequestController extends GetxController {
  final BloodRequestService _service = BloodRequestService();

  var isLoading = false.obs;

  var bloodRequests = <BloodRequestModel>[].obs;
  List<BloodRequestModel> _allRequests = [];

  var searchQuery = ''.obs;
  var selectedFilter = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    loadBloodRequests();
  }

  Future<void> loadBloodRequests() async {
    isLoading.value = true;

    _allRequests = await _service.getAllBloodRequests();
    bloodRequests.assignAll(_allRequests);

    isLoading.value = false;
  }

  // 🔍 APPLY SEARCH + FILTER (NO API CALL)
  void applySearchAndFilter() {
    List<BloodRequestModel> result = List.from(_allRequests);

    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result.where((req) {
        return (req.bloodType ?? '').toLowerCase().contains(query) ||
            (req.urgency ?? '').toLowerCase().contains(query) ||
            (req.status ?? '').toLowerCase().contains(query) ||
            (req.requiredDate ?? '').toLowerCase().contains(query);
      }).toList();
    }

    if (selectedFilter.value != 'All') {
      result = result.where((req) {
        return req.status == selectedFilter.value ||
            req.urgency == selectedFilter.value ||
            req.bloodType == selectedFilter.value;
      }).toList();
    }

    bloodRequests.assignAll(result);
  }

  // 🔴 LIVE SEARCH
  void updateSearch(String value) {
    searchQuery.value = value;
    applySearchAndFilter();
  }

  // 🎯 FILTER
  void updateFilter(String value) {
    selectedFilter.value = value;
    applySearchAndFilter();
  }

  Future<void> addBloodRequest(BloodRequestModel request) async {
    try {
      isLoading.value = true;
      await _service.createBloodRequest(request);
      await loadBloodRequests();
      Get.snackbar('Success', 'Blood request created successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create request: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateRequestStatus(
      BloodRequestModel request, String newStatus) async {
    try {
      isLoading.value = true;

      final updatedRequest = BloodRequestModel(
        id: request.id,
        requesterId: request.requesterId,
        bloodType: request.bloodType,
        urgency: request.urgency,
        status: newStatus,
        requiredDate: request.requiredDate,
      );

      await _service.updateBloodRequest(updatedRequest);
      await loadBloodRequests();
      Get.snackbar('Success', 'Request updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update request: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
