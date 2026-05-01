import 'package:blood_bank_app/controller/donation_controller.dart';
import 'package:blood_bank_app/controller/user_controller.dart';
import 'package:blood_bank_app/model/User.dart';
import 'package:blood_bank_app/routes/app_routes.dart';
import 'package:blood_bank_app/view/donor/history_screen_donor.dart';
import 'package:blood_bank_app/view/donor/map_screen_donor.dart';
import 'package:blood_bank_app/view/donor/profile_screen_donor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/blood_request_controller.dart';
import '../../controller/donor_controller.dart';
import '../../model/Blood_request.dart';
import '../../model/Donor.dart';
import '../../utils/app_colors.dart';

class HomeScreenDonor extends StatefulWidget {
  const HomeScreenDonor({super.key});

  @override
  State<HomeScreenDonor> createState() => _HomeScreenDonorState();
}

class _HomeScreenDonorState extends State<HomeScreenDonor> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Color primaryRed = AppColors.primaryRed;
  final Color darkRedHeader = const Color(0xFFB71C1C);
  late UserModel argsUser;
  DonorModel? argsDonor;
  final DonorController donorController = Get.put(DonorController());
  final UserController _userController=Get.put(UserController());
  int _selectedIndex = 0;
  final BloodRequestController _bloodRequestController=Get.put(BloodRequestController());

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;

    if (args == null) {
      // GUEST MODE
      argsUser = UserModel(
        id: 'guest',
        name: 'Guest',
        email: '',
        phone: "",
        role: 'guest',
        status: 'active',
        password: '', // Dummy
      );
    } else if (args is UserModel) {
      argsUser = args;
      donorController.fetchDonorByUserId(argsUser.id!);
    } else {
      // Invalid state
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed(AppRoutes.loginDonor);
      });
      return;
    }

    _bloodRequestController.loadBloodRequests();
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Fetch specific data based on the tab selected
    if (index == 1) {
      // If History is selected, ensure we refresh the history records
      // Assuming you have Get.put(DonationController()) somewhere or find it here
      final donationController = Get.find<DonationController>();
      donationController.refreshHistory();
    }
  }

  // ----------------- DYNAMIC SCREEN -----------------
  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeView();
      case 1:
        return HistoryScreenDonor();
      case 2:
        return MapsScreen();
      case 3:
        return ProfileScreenDonor();
      default:
        return _buildHomeView();
    }
  }

  // ----------------- BUILD -----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryRed, darkRedHeader],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildTopNav(), // Title changes dynamically here
                Expanded(
                  child: _getSelectedScreen(), // Content injects below header
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryRed,
        onPressed: () => Get.offNamed(AppRoutes.createRequestScreenDonor,arguments: donorController.donor.value),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ----------------- TOP NAV -----------------
  Widget _buildTopNav() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          Text(
            _selectedIndex == 0
                ? "Home"
                : _selectedIndex == 1
                ? "History"
                : _selectedIndex == 2
                ? "Map"
                : "Profile",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // ----------------- HOME VIEW -----------------
  Widget _buildHomeView() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildSearchBar(_bloodRequestController),
        const SizedBox(height: 10),
        _buildFilterRow(),
        const SizedBox(height: 20),
        Obx(() {
          if (_bloodRequestController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_bloodRequestController.bloodRequests.isEmpty) {
            return const Center(child: Text("No blood requests found"));
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _bloodRequestController.bloodRequests.length,
            itemBuilder: (context, index) {
              final request = _bloodRequestController.bloodRequests[index];
              return _buildBloodRequestCard(request);
            },
          );
        }),

      ],
    );
  }

  Widget _buildHistoryView() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 5,
      itemBuilder: (context, index) => Card(
        margin: const EdgeInsets.only(bottom: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          leading: const Icon(Icons.check_circle, color: Colors.green),
          title: Text("Donation at City Hospital #${index + 1}"),
          subtitle: const Text("Completed on 12 Oct 2025"),
        ),
      ),
    );
  }

  Widget _buildMapView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map, size: 80, color: Colors.grey),
          Text("Map/Settings View Coming Soon",
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildProfileView() {
    return Obx(() {
      if (donorController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      final donor = donorController.donor.value;
      print("Donor frm home page profile $donor");
      if (donor == null) {
        return const Center(child: Text("Donor profile not found"));
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150'),
            ),
            const SizedBox(height: 15),

            Text(
              donor.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            Text(
              "${donor.bloodGroup} Donor",
              style: const TextStyle(color: Colors.red),
            ),

            const SizedBox(height: 10),
            Text(donor.email, style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 30),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Edit Profile"),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("My Donations"),
              onTap: () {},
            ),
          ],
        ),
      );
    });
  }


  // ----------------- UI COMPONENTS -----------------
  Widget _buildSearchBar(BloodRequestController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: controller.updateSearch,
              decoration: const InputDecoration(
                hintText: 'Search blood requests...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => _showFilterMenu(controller),
          )
        ],
      ),
    );
  }

  void _showFilterMenu(BloodRequestController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildFilterItem(controller, 'All'),
            buildFilterItem(controller, 'Active'),
            buildFilterItem(controller, 'Completed'),
            buildFilterItem(controller, 'High'),
            buildFilterItem(controller, 'Medium'),
            buildFilterItem(controller, 'Low'),
            buildFilterItem(controller, 'O+'),
            buildFilterItem(controller, 'A+'),
            buildFilterItem(controller, 'B+'),
          ],
        ),
      ),
    );
  }

  Widget buildFilterItem(
      BloodRequestController controller, String value) {
    return Obx(() => ListTile(
      title: Text(value),
      trailing: controller.selectedFilter.value == value
          ? const Icon(Icons.check, color: Colors.red)
          : null,
      onTap: () {
        controller.updateFilter(value);
        Get.back();
      },
    ));
  }

  Widget _buildFilterRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Nearby Requests",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        TextButton.icon(
          onPressed: () {},
          icon: const Text("Filter", style: TextStyle(color: Colors.black)),
          label: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
        )
      ],
    );
  }

  Widget _buildBloodRequestCard(BloodRequestModel request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Blood Type Needed",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    "Patient: ${request.requesterId ?? 'N/A'}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    "Urgency: ${request.urgency}",
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ],
              ),
              Text(
                request.bloodType!,
                style: TextStyle(
                  color: primaryRed,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: () {
                // donate / accept request logic
              },
              style: OutlinedButton.styleFrom(shape: const StadiumBorder()),
              child: const Text("Donate Now"),
            ),
          )
        ],
      ),
    );
  }


  // Widget _buildSideDrawer() {
  //   return Drawer(
  //     child: Column(
  //       children: [
  //         UserAccountsDrawerHeader(
  //           decoration: BoxDecoration(color: primaryRed),
  //           currentAccountPicture: const CircleAvatar(
  //             backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=32'),
  //           ),
  //           accountName: const Text("Farjana Afrin"),
  //           accountEmail: const Text("farjana822@gmail.com"),
  //         ),
  //         ListTile(
  //             leading: const Icon(Icons.person),
  //             title: const Text("Profile"),
  //             onTap: () => Navigator.pop(context)),
  //         ListTile(
  //             leading: const Icon(Icons.logout),
  //             title: const Text("Logout"),
  //             onTap: () {}),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (i) => _onItemTapped(i),
      selectedItemColor: primaryRed,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
        BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: "Map"),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
      ],
    );
  }
}
