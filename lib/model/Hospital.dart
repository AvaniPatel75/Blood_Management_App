import 'dart:convert';
import 'package:uuid/uuid.dart';

class HospitalModel {
  final String hospitalId; 
  final String userId;
  final String licenseNumber;
  final DateTime licenseExpiryDate;
  final String registeredAuthority;

  final bool isApproved;
  final bool isVerified;
  final String? verificationNote;
  final DateTime? verifiedAt;
  final String? verifiedBy;

  final String street;
  final String city;
  final String state;
  final String country;
  final String postalCode;

  final double? latitude;
  final double? longitude;

  final String emergencyPhone;
  final String? landline;
  final String? website;

  final bool is24x7;
  final List<String> workingDays;
  final String openingTime;
  final String closingTime;

  final int totalBeds;
  final int availableBeds;
  final List<String> departments;

  final bool isActive;
  final bool termsAccepted;
  final DateTime termsAcceptedAt;

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastActiveAt;

  HospitalModel({
    String? hospitalId,
    required this.userId,
    required this.licenseNumber,
    required this.licenseExpiryDate,
    required this.registeredAuthority,
    this.isApproved = false,
    this.isVerified = false,
    this.verificationNote,
    this.verifiedAt,
    this.verifiedBy,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    this.latitude,
    this.longitude,
    required this.emergencyPhone,
    this.landline,
    this.website,
    this.is24x7 = false,
    required this.workingDays,
    required this.openingTime,
    required this.closingTime,
    required this.totalBeds,
    required this.availableBeds,
    required this.departments,
    this.isActive = true,
    required this.termsAccepted,
    required this.termsAcceptedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.lastActiveAt,
  })  : hospitalId = hospitalId ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // ------------------ FROM MAP ------------------
  factory HospitalModel.fromMap(Map<String, dynamic> map) {
    return HospitalModel(
      hospitalId: map['hospitalId'] ?? const Uuid().v4(),
      userId: map['userId'] ?? '',
      licenseNumber: map['licenseNumber'] ?? '',
      licenseExpiryDate: DateTime.parse(map['licenseExpiryDate']),
      registeredAuthority: map['registeredAuthority'] ?? '',
      isApproved: map['isApproved'] == 1 || map['isApproved'] == true,
      isVerified: map['isVerified'] == 1 || map['isVerified'] == true,
      verificationNote: map['verificationNote'],
      verifiedAt: map['verifiedAt'] != null
          ? DateTime.parse(map['verifiedAt'])
          : null,
      verifiedBy: map['verifiedBy'],
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      country: map['country'] ?? '',
      postalCode: map['postalCode'] ?? '',
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      emergencyPhone: map['emergencyPhone'] ?? '',
      landline: map['landline'],
      website: map['website'],
      is24x7: map['is24x7'] == 1 || map['is24x7'] == true,
      workingDays: (map['workingDays'] is String)
          ? List<String>.from(jsonDecode(map['workingDays']))
          : List<String>.from(map['workingDays'] ?? []),
      openingTime: map['openingTime'] ?? '',
      closingTime: map['closingTime'] ?? '',
      totalBeds: map['totalBeds'] ?? 0,
      availableBeds: map['availableBeds'] ?? 0,
      departments: (map['departments'] is String)
          ? List<String>.from(jsonDecode(map['departments']))
          : List<String>.from(map['departments'] ?? []),
      isActive: map['isActive'] == 1 || map['isActive'] == true,
      termsAccepted: map['termsAccepted'] == 1 || map['termsAccepted'] == true,
      termsAcceptedAt: DateTime.parse(map['termsAcceptedAt']),
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

  // ------------------ TO MAP ------------------
  Map<String, dynamic> toMap() {
    return {
      'hospitalId': hospitalId,
      'userId': userId,
      'licenseNumber': licenseNumber,
      'licenseExpiryDate': licenseExpiryDate.toIso8601String(),
      'registeredAuthority': registeredAuthority,
      'isApproved': isApproved ? 1 : 0,
      'isVerified': isVerified ? 1 : 0,
      'verificationNote': verificationNote,
      'verifiedAt': verifiedAt?.toIso8601String(),
      'verifiedBy': verifiedBy,
      'street': street,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
      'latitude': latitude,
      'longitude': longitude,
      'emergencyPhone': emergencyPhone,
      'landline': landline,
      'website': website,
      'is24x7': is24x7 ? 1 : 0,
      'workingDays': jsonEncode(workingDays),
      'openingTime': openingTime,
      'closingTime': closingTime,
      'totalBeds': totalBeds,
      'availableBeds': availableBeds,
      'departments': jsonEncode(departments),
      'isActive': isActive ? 1 : 0,
      'termsAccepted': termsAccepted ? 1 : 0,
      'termsAcceptedAt': termsAcceptedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastActiveAt': lastActiveAt?.toIso8601String(),
    };
  }

}
extension HospitalCopy on HospitalModel {
  HospitalModel copyWith({
    double? latitude,
    double? longitude,
  }) {
    return HospitalModel(
      hospitalId: hospitalId,
      userId: userId,
      licenseNumber: licenseNumber,
      licenseExpiryDate: licenseExpiryDate,
      registeredAuthority: registeredAuthority,
      isApproved: isApproved,
      isVerified: isVerified,
      verificationNote: verificationNote,
      verifiedAt: verifiedAt,
      verifiedBy: verifiedBy,
      street: street,
      city: city,
      state: state,
      country: country,
      postalCode: postalCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      emergencyPhone: emergencyPhone,
      landline: landline,
      website: website,
      is24x7: is24x7,
      workingDays: workingDays,
      openingTime: openingTime,
      closingTime: closingTime,
      totalBeds: totalBeds,
      availableBeds: availableBeds,
      departments: departments,
      isActive: isActive,
      termsAccepted: termsAccepted,
      termsAcceptedAt: termsAcceptedAt,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      lastActiveAt: lastActiveAt,
    );
  }
}

