// ✅ UPDATED DonorModel.dart - Added Lat/Lng
import 'package:uuid/uuid.dart';

class DonorModel {
  final String donorId;
  final String userId;

  String name;
  String email;
  String status;

  final String bloodGroup;
  final DateTime? lastDonationDate;
  final bool isActiveDonor;
  final String? medicalNotes;

  final String street;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  
  final double? latitude;
  final double? longitude;

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastActiveAt;
  

  DonorModel({
    String? donorId,
    required this.userId,
    required this.name,
    required this.email,
    required this.status,
    required this.bloodGroup,
    this.lastDonationDate,
    this.isActiveDonor = true,
    this.medicalNotes,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    this.latitude,
    this.longitude,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.lastActiveAt,
  })  : donorId = donorId ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory DonorModel.fromMap(Map<String, dynamic> map) {
    return DonorModel(
      donorId: map['donorId'] ?? const Uuid().v4(),
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      status: map['status'] ?? '',
      bloodGroup: map['bloodGroup'] ?? '',
      lastDonationDate: map['lastDonationDate'] != null
          ? DateTime.parse(map['lastDonationDate'])
          : null,
      isActiveDonor: map['isActiveDonor'] == 1,
      medicalNotes: map['medicalNotes'],
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      country: map['country'] ?? '',
      postalCode: map['postalCode'] ?? '',
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
      lastActiveAt: map['lastActiveAt'] != null
          ? DateTime.parse(map['lastActiveAt'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'donorId': donorId,
      'userId': userId,
      'name': name,
      'email': email,
      'status': status,
      'bloodGroup': bloodGroup,
      'lastDonationDate': lastDonationDate?.toIso8601String(),
      'isActiveDonor': isActiveDonor ? 1 : 0,
      'medicalNotes': medicalNotes,
      'street': street,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastActiveAt': lastActiveAt?.toIso8601String(),
    };
  }
}
