import 'package:blood_bank_app/controller/blood_bank_controller.dart';
import 'package:blood_bank_app/controller/patient_controller.dart';
import 'package:blood_bank_app/model/User.dart';
import 'package:blood_bank_app/view/donor/history_screen_donor.dart';
import 'package:blood_bank_app/view/donor/map_screen_donor.dart';
import 'package:blood_bank_app/view/patient/create_request_screen.dart';
import 'package:blood_bank_app/view/patient/profile_page_patient.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/blood_request_controller.dart';

class HomeScreenPatient extends StatefulWidget {
  const HomeScreenPatient({super.key});

  @override
  State<HomeScreenPatient> createState() => _HomeScreenPatientState();
}

class _HomeScreenPatientState extends State<HomeScreenPatient> {
  final Color primaryRed = const Color(0xFFD32F2F);
  final Color darkRedHeader = const Color(0xFFB71C1C);

  late UserModel argsUser;
  bool isGuest = false;

  final PatientController _patientController =
  Get.put(PatientController());
  final BloodRequestController _requestController =
  Get.put(BloodRequestController());
  final BloodBankController _bloodBankController =
  Get.put(BloodBankController());

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;

    if (args == null) {
      isGuest = true;
      argsUser = UserModel(
        id: 'guest',
        name: 'Guest',
        email: '',
        phone: '',
        role: 'guest',
        status: 'active',
        password: '',
      );
    } else if (args is UserModel) {
      argsUser = args;
      _patientController.fetchPatientByUserId(argsUser.id!);
    }

    _requestController.loadBloodRequests();

    _bloodBankController.fetchAllBloodBanks().then((_) {
      _bloodBankController.loadNearbyBloodBanks(radiusKm: 10);
    });
  }

  // ---------------- MAIN BUILD ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          _buildHeader(),
          SafeArea(
            child: Column(
              children: [
                _buildTopNav(),
                Expanded(child: _getSelectedScreen()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: (_selectedIndex == 0 && !isGuest)
          ? FloatingActionButton(
        backgroundColor: primaryRed,
        onPressed: () {
          final patient = _patientController.patient.value;
          if (patient == null) {
            Get.snackbar("Error", "Patient data not loaded");
            return;
          }
          Get.to(() => CreateRequestScreen(), arguments: patient);
        },
        child: const Icon(Icons.add, color: Colors.white),
      )
          : null,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ---------------- NAVIGATION ----------------

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 1:
        return const HistoryScreenDonor();
      case 2:
        return MapsScreen();
      case 3:
        return ProfileScreenPatient();
      default:
        return _buildHomeView();
    }
  }

  // ---------------- HOME VIEW ----------------

  Widget _buildHomeView() {
    return Obx(() {
      return ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSearchBar(),
          const SizedBox(height: 15),
          _buildFilterRow(),
          const SizedBox(height: 15),

          // 🔴 Blood Requests
          if (_requestController.bloodRequests.isEmpty)
            const Text("No blood requests found")
          else
            ..._requestController.bloodRequests
                .map((req) => _buildBloodRequestCard(req))
                .toList(),

          const SizedBox(height: 25),

          // 🏥 Nearby Blood Banks
          _buildNearbyBloodBanks(),
        ],
      );
    });
  }

  // ---------------- BLOOD BANK SECTION ----------------

  Widget _buildNearbyBloodBanks() {
    return Obx(() {
      if (_bloodBankController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (_bloodBankController.nearbyBloodBanks.isEmpty) {
        return const Text("No nearby blood banks found");
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Nearby Blood Banks",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ..._bloodBankController.nearbyBloodBanks
              .map((bank) => _buildBloodBankCard(bank))
              .toList(),
        ],
      );
    });
  }

  // ---------------- UI COMPONENTS ----------------

  Widget _buildHeader() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryRed, darkRedHeader],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
    );
  }

  Widget _buildTopNav() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.canPop(context)
                ? Navigator.pop(context)
                : null,
          ),
          Text(
            ["Home", "History", "Map", "Profile"][_selectedIndex],
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          const Icon(Icons.notifications, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        onChanged: _requestController.updateSearch,
        decoration: const InputDecoration(
          hintText: "Search blood requests...",
          border: InputBorder.none,
          icon: Icon(Icons.search),
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          "Nearby Requests",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Icon(Icons.filter_list),
      ],
    );
  }

  Widget _buildBloodRequestCard(request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Blood Needed",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Urgency: ${request.urgency ?? 'Normal'}"),
            ],
          ),
          Text(
            request.bloodType ?? "?",
            style: TextStyle(
                color: primaryRed,
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildBloodBankCard(bank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(bank.name ?? "Blood Bank",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text("${bank.city}, ${bank.state}",
                  style: const TextStyle(color: Colors.grey)),
            ],
          ),
          Icon(Icons.local_hospital, color: primaryRed),
        ],
      ),
    );
  }

  // ---------------- BOTTOM NAV ----------------

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (i) => setState(() => _selectedIndex = i),
      selectedItemColor: primaryRed,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
