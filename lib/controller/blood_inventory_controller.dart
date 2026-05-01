import 'package:get/get.dart';
import '../database/api/blood_inventory_service.dart';
import '../model/Inventory.dart';

class BloodInventoryController extends GetxController {
  final BloodInventoryService _service = BloodInventoryService();

  var isLoading = false.obs;
  var inventoryList = <BloodInventoryModel>[].obs;
  var filteredList = <BloodInventoryModel>[].obs;

  var searchQuery = ''.obs;
  var selectedBloodType = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    // Initially load nothing or all? 
    // Usually we wait for a call with bloodBankId, or load all if user is admin.
    // For now, let's just expose the methods.
    loadAllInventory();
  }

  Future<void> loadAllInventory() async {
    isLoading.value = true;
    try {
      var result = await _service.getAllInventory();
      inventoryList.value = result;
      applySearchAndFilter();
    } catch (e) {
      print("Error loading inventory: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadInventoryByBank(String bloodBankId) async {
    isLoading.value = true;
    try {
      var result = await _service.getInventoryByBloodBankId(bloodBankId);
      inventoryList.value = result;
      applySearchAndFilter();
    } catch (e) {
      print("Error loading inventory for bank $bloodBankId: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addInventory(BloodInventoryModel item) async {
    isLoading.value = true;
    try {
      await _service.createInventory(item);
      // Refresh list based on context - for now just reload all or reload by bank if we knew it
      // Since we don't track current bank ID in state efficiently yet, we might just update local list
      inventoryList.add(item);
      applySearchAndFilter();
      Get.snackbar('Success', 'Inventory added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add inventory: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateInventory(BloodInventoryModel item) async {
    isLoading.value = true;
    try {
      await _service.updateInventory(item);
      int index = inventoryList.indexWhere((element) => element.id == item.id);
      if (index != -1) {
        inventoryList[index] = item;
        applySearchAndFilter();
      }
      Get.snackbar('Success', 'Inventory updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update inventory: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteInventory(String id) async {
    isLoading.value = true;
    try {
      await _service.deleteInventory(id);
      inventoryList.removeWhere((item) => item.id == id);
      applySearchAndFilter();
      Get.snackbar('Success', 'Inventory deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete inventory: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearch(String value) {
    searchQuery.value = value;
    applySearchAndFilter();
  }

  void updateFilter(String value) {
    selectedBloodType.value = value;
    applySearchAndFilter();
  }

  void applySearchAndFilter() {
    List<BloodInventoryModel> result = inventoryList;

    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result.where((item) {
        return (item.bloodType ?? '').toLowerCase().contains(query);
      }).toList();
    }

    if (selectedBloodType.value != 'All') {
      result = result.where((item) {
        return item.bloodType == selectedBloodType.value;
      }).toList();
    }

    filteredList.value = result;
  }
}
