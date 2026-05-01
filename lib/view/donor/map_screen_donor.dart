import 'package:blood_bank_app/database/api/bloodBank_api_service.dart';
import 'package:blood_bank_app/database/api/donor_api_service.dart';
import 'package:blood_bank_app/database/api/hospital_api_service.dart';
import 'package:blood_bank_app/model/Blood_bank_model.dart';
import 'package:blood_bank_app/model/Donor.dart';
import 'package:blood_bank_app/model/Hospital.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};

  final DonorApiService _donorService = DonorApiService();
  final HospitalApiService _hospitalService = HospitalApiService();
  final BloodBankApiService _bloodBankService = BloodBankApiService(); // Assuming this service exists and works similar to others

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllMarkers();
  }

  Future<void> _loadAllMarkers() async {
    setState(() => _isLoading = true);
    
    try {
      final List<DonorModel> donors = await _donorService.getAllDonors();
      final List<HospitalModel> hospitals = await _hospitalService.getAllHospitals();
      final List<BloodBankModel> bloodBanks = await _bloodBankService.getAllBloodBanks();

      final Set<Marker> newMarkers = {};

      // Add Donors (Green)
      for (var donor in donors) {
        if (donor.latitude != null && donor.longitude != null && donor.latitude != 0) {
          newMarkers.add(Marker(
            markerId: MarkerId('donor_${donor.donorId}'),
            position: LatLng(donor.latitude!, donor.longitude!),
            infoWindow: InfoWindow(title: 'Donor: ${donor.name}', snippet: 'Group: ${donor.bloodGroup}'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          ));
        }
      }

      // Add Hospitals (Blue)
      for (var hospital in hospitals) {
        if (hospital.latitude != null && hospital.longitude != null && hospital.latitude != 0) {
          newMarkers.add(Marker(
            markerId: MarkerId('hospital_${hospital.hospitalId}'),
            position: LatLng(hospital.latitude!, hospital.longitude!),
            infoWindow: InfoWindow(title: 'Hospital', snippet: 'Lic: ${hospital.licenseNumber}'), // Name might be in user table, would need join or fetch
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ));
        }
      }

      // Add Blood Banks (Red)
      for (var bank in bloodBanks) {
        if (bank.latitude != null && bank.longitude != null && bank.latitude != 0) {
          newMarkers.add(Marker(
            markerId: MarkerId('bank_${bank.bloodBankId}'),
            position: LatLng(bank.latitude!, bank.longitude!),
            infoWindow: InfoWindow(title: 'Blood Bank', snippet: bank.city),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ));
        }
      }

      setState(() {
        _markers.addAll(newMarkers);
        _isLoading = false;
      });

    } catch (e) {
      print("Error loading markers: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;

    final pos = await Geolocator.getCurrentPosition();

    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(pos.latitude, pos.longitude),
        14,
      ),
    );
     // Optional: Add "My Location" marker if myLocationEnabled isn't enough
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Find Donors & Banks")),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator()) 
          : GoogleMap(
              onMapCreated: (controller) {
                mapController = controller;
                _getCurrentLocation(); // Auto zoom to user
              },
              initialCameraPosition: const CameraPosition(
                target: LatLng(22.8314, 70.3833), // Default fallback
                zoom: 12,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false, // Using custom button
              zoomControlsEnabled: false,
              markers: _markers,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
