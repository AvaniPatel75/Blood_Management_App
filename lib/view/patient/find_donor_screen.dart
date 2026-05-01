import 'package:flutter/material.dart';

class FindDonorScreen extends StatefulWidget {
  const FindDonorScreen({super.key});

  @override
  State<FindDonorScreen> createState() => _FindDonorScreenState();
}

class _FindDonorScreenState extends State<FindDonorScreen> {
  // Controllers & State
  String? _selectedBloodGroup;
  final TextEditingController _locationController = TextEditingController();

  // Theme Color
  final Color primaryRed = const Color(0xFFD3002D);

  // Blood Groups List
  final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  // Dummy Donor Data
  final List<Map<String, dynamic>> _donors = [
    {
      'bloodGroup': 'AB+',
      'units': '0.3',
      'gender': 'Female',
      'age': 21,
      'name': 'Kirithika',
      'location': 'Rediyarpalayam, Puducherry',
      'distance': '3 Km',
      'timeLimit': '15/11/2022',
    },
    {
      'bloodGroup': 'O+',
      'units': '1.0',
      'gender': 'Male',
      'age': 25,
      'name': 'Rajesh Kumar',
      'location': 'Lawspet, Puducherry',
      'distance': '5 Km',
      'timeLimit': '16/11/2022',
    },
    {
      'bloodGroup': 'B-',
      'units': '0.5',
      'gender': 'Female',
      'age': 20,
      'name': 'Sneha Sharma',
      'location': 'Muthialpet, Puducherry',
      'distance': '2.5 Km',
      'timeLimit': '15/11/2022',
    },
    {
      'bloodGroup': 'A+',
      'units': '0.8',
      'gender': 'Male',
      'age': 23,
      'name': 'Arun Vijay',
      'location': 'Villianur, Puducherry',
      'distance': '7 Km',
      'timeLimit': '17/11/2022',
    },
  ];


  @override
  Widget build(BuildContext context) {
    // Note: This screen is designed to be part of a Scaffold with a BottomNavigationBar
    // (e.g., inside your HomeScreen's body).
    return Column(
      children: [
        // 1. HEADER SECTION (Pink area with filters)
        _buildHeader(),

        // 2. RESULTS SECTION (List of donors)
        Expanded(
          child: _buildResultsList(),
        ),
      ],
    );
  }

  // --- WIDGET BUILDER METHODS ---

  Widget _buildHeader() {
    return Container(
      // Add padding for status bar and content
      padding: const EdgeInsets.fromLTRB(24, 50, 24, 30),
      decoration: BoxDecoration(
        color: primaryRed,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        // Optional: Add subtle background pattern here if needed
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Find Donor",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "Blood donors around you",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 25),

          // Blood Group Label & Dropdown
          const Text("Choose Blood group", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
          const SizedBox(height: 10),
          _buildDropdown(),

          const SizedBox(height: 20),

          // Location Label & Input
          const Text("Location", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
          const SizedBox(height: 10),
          _buildLocationInput(),

          const SizedBox(height: 30),

          // Search Button
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement search logic here
                print("Search for: Blood Group: $_selectedBloodGroup, Location: ${_locationController.text}");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: primaryRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                elevation: 0,
              ),
              icon: const Icon(Icons.search),
              label: const Text(
                "Search",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedBloodGroup,
          hint: Text("Select", style: TextStyle(color: Colors.grey.shade400)),
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
          isExpanded: true,
          items: _bloodGroups.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (val) => setState(() => _selectedBloodGroup = val),
        ),
      ),
    );
  }

  Widget _buildLocationInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _locationController,
        decoration: InputDecoration(
          hintText: "Enter your location",
          hintStyle: TextStyle(color: Colors.grey.shade400),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          // Optional: Add a location icon
          // prefixIcon: Icon(Icons.location_on_outlined, color: Colors.grey.shade400),
        ),
      ),
    );
  }

  Widget _buildResultsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
          child: Text(
            "Found ${_donors.length} donors around you", // Corrected typo from image
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            itemCount: _donors.length,
            itemBuilder: (context, index) {
              return _buildDonorCard(_donors[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDonorCard(Map<String, dynamic> donor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Top Part of the card (Details)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Blood Group & Unit Badge
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50, // Light red background
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      // Using a standard icon, a custom asset would be more exact
                      Icon(Icons.bloodtype, color: primaryRed, size: 28),
                      const SizedBox(height: 5),
                      Text(
                        donor['bloodGroup'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: primaryRed,
                        ),
                      ),
                      Text(
                        "${donor['units']} Unit",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Donor Details Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name, Age, Gender & Actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "${donor['gender']}, ${donor['age']}yr old",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  // TODO: Implement call functionality
                                  print("Call ${donor['name']}");
                                },
                                icon: Icon(Icons.phone, color: primaryRed, size: 20),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              const SizedBox(width: 15),
                              Icon(Icons.more_vert, color: Colors.grey.shade400, size: 20),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Details with Icons
                      _buildIconText(Icons.person_outline, donor['name']),
                      _buildIconText(Icons.location_on_outlined, donor['location']),
                      _buildIconText(Icons.near_me_outlined, donor['distance']),

                      const SizedBox(height: 10),

                      // Time Limit Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "Time Limit: ${donor['timeLimit']}",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Divider(height: 1, color: Colors.grey.shade200),

          // Bottom Actions (Share & Request)
          Row(
            children: [
              // Share Button
              Expanded(
                child: TextButton.icon(
                  onPressed: () {
                    // TODO: Implement share functionality
                    print("Share donor ${donor['name']}");
                  },
                  icon: const Icon(Icons.share_outlined, color: Colors.grey, size: 18),
                  label: const Text("share", style: TextStyle(color: Colors.grey)),
                ),
              ),

              // Vertical Divider
              Container(width: 1, height: 40, color: Colors.grey.shade200),

              // Request Button
              Expanded(
                child: TextButton(
                  onPressed: () {
                    // TODO: Implement request functionality
                    print("Request sent to ${donor['name']}");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Request",
                        style: TextStyle(
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(Icons.arrow_forward_ios, color: Colors.grey.shade800, size: 14),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper widget for rows with an icon and text
  Widget _buildIconText(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade500),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}