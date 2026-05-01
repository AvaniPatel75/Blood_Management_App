import 'package:flutter/material.dart';

class HomeScreenHospital extends StatefulWidget {
  const HomeScreenHospital({super.key});

  @override
  State<HomeScreenHospital> createState() => _HomeScreenHospitalState();
}

class _HomeScreenHospitalState extends State<HomeScreenHospital> {
  final Color primaryRed = const Color(0xFFD73535);
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          // -------------------- Red Header (Persistent) --------------------
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: primaryRed,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),

          // -------------------- Content Area --------------------
          SafeArea(
            child: Column(
              children: [
                // Top Row: Back + Title + Profile
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                        onPressed: () {
                          if (Navigator.canPop(context)) Navigator.pop(context);
                        },
                      ),
                      const Text(
                        "Hospital Dashboard",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.account_circle, color: Colors.white, size: 30),
                        onPressed: () => setState(() => _selectedIndex = 3),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // -------------------- Bottom Content (Dynamic) --------------------
                Expanded(child: _getSelectedScreen()),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        backgroundColor: primaryRed,
        onPressed: () {
          // Action: Add Blood Request
        },
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      )
          : null,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        selectedItemColor: primaryRed,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: "Inventory"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), label: "Requests"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }

  // -------------------- Dynamic Screens --------------------
  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildInventoryTab();
      case 2:
        return _buildRequestsTab();
      case 3:
        return _buildProfileTab();
      default:
        return _buildHomeTab();
    }
  }

  // -------------------- Tabs --------------------
  Widget _buildHomeTab() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        itemCount: 3,
        itemBuilder: (context, index) => _buildBloodRequestCard(),
      ),
    );
  }

  Widget _buildInventoryTab() {
    final inventory = {"A+": 12, "B+": 8, "O-": 2, "AB+": 15, "O+": 20, "A-": 5};
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 75),
      child: ListView.builder(
        itemCount: inventory.length,
        itemBuilder: (context, index) {
          String key = inventory.keys.elementAt(index);
          int units = inventory[key]!;
          bool isLow = units <= 3;
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(key, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text("$units Units", style: TextStyle(color: isLow ? primaryRed : Colors.grey)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRequestsTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 80),
      child: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) => ListTile(
          leading: const CircleAvatar(
            backgroundColor: Color(0xFFFDECEA),
            child: Icon(Icons.emergency, color: Colors.red, size: 20),
          ),
          title: Text("Urgent Request #${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: const Text("Hospital • 2 units"),
          trailing: TextButton(onPressed: () {}, child: Text("View", style: TextStyle(color: primaryRed))),
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const CircleAvatar(radius: 50, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=32')),
          const SizedBox(height: 15),
          const Text("City Central Hospital", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Text("ID: HSP-9902-BX", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 30),
          ListTile(leading: const Icon(Icons.person), title: const Text("Edit Profile"), onTap: () {}),
          ListTile(leading: const Icon(Icons.logout), title: const Text("Logout"), onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildBloodRequestCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Blood Type Needed", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                Text("Patient: City Hospital", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Text("O+", style: TextStyle(color: primaryRed, fontSize: 32, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
