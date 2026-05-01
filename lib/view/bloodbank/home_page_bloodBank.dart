import 'package:blood_bank_app/controller/blood_bank_controller.dart';
import 'package:blood_bank_app/controller/blood_inventory_controller.dart';
import 'package:blood_bank_app/model/Blood_bank_model.dart';
import 'package:blood_bank_app/model/Inventory.dart';
import 'package:blood_bank_app/model/User.dart';
import 'package:blood_bank_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class HomeScreenBloodBank extends StatefulWidget {
  const HomeScreenBloodBank({super.key});

  @override
  State<HomeScreenBloodBank> createState() => _HomeScreenBloodBankState();
}

class _HomeScreenBloodBankState extends State<HomeScreenBloodBank> {
  final BloodBankController _bloodBankController = Get.put(BloodBankController());
  final BloodInventoryController _inventoryController = Get.put(BloodInventoryController());

  final Color primaryRed = const Color(0xFFD3002D);
  final Color darkBlue = const Color(0xFF1A1A2E);

  late UserModel currentUser;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args != null && args is List && args.isNotEmpty) {
      currentUser = args[0] as UserModel;
      _loadData(); // Load data on init
    }
  }

  void _loadData() async {
    if (currentUser.id == null) return;
    await _bloodBankController.fetchBloodBankProfile(currentUser.id!);
    if (_bloodBankController.currentBloodBank.value != null) {
      _inventoryController.loadInventoryByBank(_bloodBankController.currentBloodBank.value!.bloodBankId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Bank Dashboard", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => _buildWelcomeCard()),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Live Inventory", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                     if (_bloodBankController.currentBloodBank.value != null) {
                        _inventoryController.loadInventoryByBank(_bloodBankController.currentBloodBank.value!.bloodBankId);
                     }
                  },
                )
              ],
            ),
            const SizedBox(height: 15),
            Obx(() => _buildInventoryGrid()),
            const SizedBox(height: 25),
            const Text("Quick Actions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    BloodBankModel? bank = _bloodBankController.currentBloodBank.value;
    
    if (bank == null) {
       if (_bloodBankController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
       }
       return Container(
         padding: const EdgeInsets.all(20),
         decoration: BoxDecoration(color: darkBlue, borderRadius: BorderRadius.circular(20)),
         child: const Text("No Bank Profile Found. Please contact admin.", style: TextStyle(color: Colors.white)),
       );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: darkBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white12,
            child: Icon(Icons.local_hospital, color: Colors.white),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bank.userId.isNotEmpty ? "Blood Bank" : "Unknown Bank", // Ideally fetching actual name if stored separately
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text("License: ${bank.licenseNumber}", style: const TextStyle(color: Colors.white70, fontSize: 13)),
                Text(bank.city, style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInventoryGrid() {
    if (_inventoryController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
    }
    
    final inventoryList = _inventoryController.inventoryList;

    if (inventoryList.isEmpty) {
      return Center(
        child: Column(
           children: [
             Icon(Icons.bloodtype_outlined, size: 50, color: Colors.grey.shade400),
             const SizedBox(height: 10),
             Text("No inventory added yet", style: TextStyle(color: Colors.grey.shade600))
           ]
        ),
      );
    }

    // Sort to keep consistent order if desired
    // inventoryList.sort((a, b) => (a.bloodType ?? '').compareTo(b.bloodType ?? ''));

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: inventoryList.length,
      itemBuilder: (context, index) {
        final item = inventoryList[index];
        final units = item.unitsAvailable ?? 0;
        final isLow = units < 5;

        return InkWell(
          onTap: () => _updateStockDialog(item),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: isLow ? Colors.red.shade200 : Colors.transparent),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item.bloodType ?? '?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryRed)),
                const SizedBox(height: 5),
                Text("$units Units", style: TextStyle(color: isLow ? Colors.red : Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        InkWell(
           onTap: () => _addStockDialog(),
           child: _actionCard(Icons.add_box, "Add Stock", Colors.green)
        ),
        const SizedBox(width: 15),
        InkWell(
           onTap: () {
             // For now just show snackbar or navigate to request page
             Get.toNamed(AppRoutes.bloodBankManageRequests);
           },
           child: _actionCard(Icons.remove_from_queue, "Issue Blood", Colors.orange)
        ),
      ],
    );
  }

  Widget _actionCard(IconData icon, String title, Color color) {
    return Container(
      width: (MediaQuery.of(context).size.width - 55) / 2, // Approximate width sharing
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ---------------- DIALOGS ----------------

  void _addStockDialog() {
    final bloodTypes = ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"];
    String selectedType = "A+";
    final TextEditingController unitsController = TextEditingController();

    Get.defaultDialog(
      title: "Add Blood Stock",
      content: Column(
        children: [
           DropdownButtonFormField<String>(
             value: selectedType,
             items: bloodTypes.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
             onChanged: (val) => selectedType = val!,
             decoration: const InputDecoration(labelText: "Blood Type"),
           ),
           const SizedBox(height: 10),
           TextField(
             controller: unitsController,
             keyboardType: TextInputType.number,
             decoration: const InputDecoration(labelText: "Units (e.g. 5)"),
           )
        ],
      ),
      textConfirm: "Add",
      textCancel: "Cancel",
      onConfirm: () {
         final int? units = int.tryParse(unitsController.text);
         final bankId = _bloodBankController.currentBloodBank.value?.bloodBankId;
         
         if (bankId == null) {
           Get.back();
           Get.snackbar("Error", "No Blood Bank Profile loaded");
           return;
         }
         
         if (units != null && units > 0) {
            // Check if this blood type already exists in inventory, if so update it
            final existing = _inventoryController.inventoryList.firstWhereOrNull((e) => e.bloodType == selectedType);
            
            if (existing != null) {
                // Update
               final updated = BloodInventoryModel(
                  id: existing.id,
                  bloodBankId: existing.bloodBankId,
                  bloodType: existing.bloodType,
                  unitsAvailable: (existing.unitsAvailable ?? 0) + units,
                  lastUpdated: DateTime.now().toIso8601String(),
               );
               _inventoryController.updateInventory(updated);
            } else {
               // Create
               final newItem = BloodInventoryModel(
                 id: const Uuid().v4(),
                 bloodBankId: bankId,
                 bloodType: selectedType,
                 unitsAvailable: units,
                 lastUpdated: DateTime.now().toIso8601String(),
               );
               _inventoryController.addInventory(newItem);
            }
            Get.back();
         } else {
            Get.snackbar("Error", "Please enter valid units");
         }
      }
    );
  }
  
  void _updateStockDialog(BloodInventoryModel item) {
    final TextEditingController unitsController = TextEditingController(text: item.unitsAvailable?.toString() ?? '0');
    
    Get.defaultDialog(
      title: "Update ${item.bloodType}",
      content: Column(
        children: [
           TextField(
             controller: unitsController,
             keyboardType: TextInputType.number,
             decoration: const InputDecoration(labelText: "Total Units Available"),
           )
        ],
      ),
      textConfirm: "Update",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () {
         final int? units = int.tryParse(unitsController.text);
         if (units != null && units >= 0) {
            final updated = BloodInventoryModel(
               id: item.id,
               bloodBankId: item.bloodBankId,
               bloodType: item.bloodType,
               unitsAvailable: units,
               lastUpdated: DateTime.now().toIso8601String(),
            );
            _inventoryController.updateInventory(updated);
            Get.back();
         }
      }
    );
  }
}
