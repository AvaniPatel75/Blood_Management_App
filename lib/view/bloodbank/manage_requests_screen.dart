import 'package:blood_bank_app/controller/blood_inventory_controller.dart';
import 'package:blood_bank_app/controller/blood_request_controller.dart';
import 'package:blood_bank_app/controller/blood_bank_controller.dart';
import 'package:blood_bank_app/model/Blood_request.dart';
import 'package:blood_bank_app/model/Inventory.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageRequestsScreen extends StatefulWidget {
  const ManageRequestsScreen({super.key});

  @override
  State<ManageRequestsScreen> createState() => _ManageRequestsScreenState();
}

class _ManageRequestsScreenState extends State<ManageRequestsScreen> {
  final BloodRequestController _requestController = Get.put(BloodRequestController());
  final BloodInventoryController _inventoryController = Get.find<BloodInventoryController>();
  final BloodBankController _bloodBankController = Get.find<BloodBankController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Requests"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Obx(() {
        if (_requestController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final requests = _requestController.bloodRequests;
        if (requests.isEmpty) {
          return const Center(child: Text("No Pending Requests"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            return _buildRequestCard(request);
          },
        );
      }),
    );
  }

  Widget _buildRequestCard(BloodRequestModel request) {
    // Check if we have stock for this request
    final stock = _inventoryController.inventoryList.firstWhereOrNull(
        (i) => i.bloodType == request.bloodType
    );
    final hasStock = stock != null && (stock.unitsAvailable ?? 0) > 0;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text("Type: ${request.bloodType}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFD3002D))),
                 Chip(
                   label: Text(request.urgency ?? 'Normal'),
                   backgroundColor: request.urgency == 'Critical' ? Colors.red.shade100 : Colors.blue.shade100,
                 )
               ],
             ),
             const SizedBox(height: 8),
             Text("Status: ${request.status}"),
             Text("Required: ${request.requiredDate}"),
             const SizedBox(height: 16),
             Row(
               mainAxisAlignment: MainAxisAlignment.end,
               children: [
                 if (request.status == 'Pending') ...[
                    OutlinedButton(
                      onPressed: hasStock ? () => _fulfillRequest(request, stock!) : null,
                      child: Text(hasStock ? "Fulfill Request" : "No Stock"),
                    ),
                 ]
               ],
             )
          ],
        ),
      ),
    );
  }

  void _fulfillRequest(BloodRequestModel request, BloodInventoryModel stock) {
    Get.defaultDialog(
      title: "Confirm Fulfillment",
      middleText: "This will deduct 1 unit from your inventory.",
      textConfirm: "Confirm",
      textCancel: "Cancel",
      onConfirm: () async {
         Get.back(); // Close dialog
         
         // 1. Update Inventory
         final updatedStock = BloodInventoryModel(
           id: stock.id,
           bloodBankId: stock.bloodBankId,
           bloodType: stock.bloodType,
           unitsAvailable: (stock.unitsAvailable ?? 1) - 1,
           lastUpdated: DateTime.now().toIso8601String(),
         );
         await _inventoryController.updateInventory(updatedStock);
         
         // 2. Update Request Status (Assuming we can edit request, but BloodRequestController logic might need check)
         // Actually BloodRequest model handling is needed. Assuming we can just update status locally for now or via a service method if it existed.
         // Since BloodRequestController only has addRequest, I need to check if it has update.
         // It DOES NOT have updateRequest exposed clearly in controller, but service has it.
         
         // 2. Update Request Status
         await _requestController.updateRequestStatus(request, 'Fulfilled');
      }
    );
  }
}
