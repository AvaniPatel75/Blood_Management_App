import 'dart:convert';
import 'package:uuid/uuid.dart';

class BloodBankModel {
  final String bloodBankId;
  final String userId;
  final String licenseNumber;
  final DateTime licenseExpiryDate;
  final String registeredAuthority;

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
  final List<String> workingDays; // ["Mon", "Tue"]
  final String openingTime; // "09:00"
  final String closingTime; // "18:00"

  final Map<String, int> bloodStock; // {"A+": 10, "O-": 2}

  final int dailyCapacity;
  final int availableUnitsToday;

  final bool isActive;
  final bool termsAccepted;
  final DateTime termsAcceptedAt;

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastActiveAt;

  BloodBankModel({
    String? bloodBankId,
    required this.userId,
    required this.licenseNumber,
    required this.licenseExpiryDate,
    required this.registeredAuthority,
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
    required this.bloodStock,
    required this.dailyCapacity,
    required this.availableUnitsToday,
    this.isActive = true,
    required this.termsAccepted,
    required this.termsAcceptedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.lastActiveAt,
  })  : bloodBankId = bloodBankId ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // ------------------ FROM MAP ------------------
  factory BloodBankModel.fromMap(Map<String, dynamic> map) {
    return BloodBankModel(
      bloodBankId: map['bloodBankId'] ?? const Uuid().v4(),
      userId: map['userId'] ?? '',
      licenseNumber: map['licenseNumber'] ?? '',
      licenseExpiryDate: DateTime.parse(map['licenseExpiryDate']),
      registeredAuthority: map['registeredAuthority'] ?? '',
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
      
      bloodStock: (map['bloodStock'] is String)
          ? Map<String, int>.from(jsonDecode(map['bloodStock']))
          : Map<String, int>.from(map['bloodStock'] ?? {}),
          
      dailyCapacity: map['dailyCapacity'] ?? 0,
      availableUnitsToday: map['availableUnitsToday'] ?? 0,
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
      'bloodBankId': bloodBankId,
      'userId': userId,
      'licenseNumber': licenseNumber,
      'licenseExpiryDate': licenseExpiryDate.toIso8601String(),
      'registeredAuthority': registeredAuthority,
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
      
      'bloodStock': jsonEncode(bloodStock), // store as JSON in SQLite
      
      'dailyCapacity': dailyCapacity,
      'availableUnitsToday': availableUnitsToday,
      'isActive': isActive ? 1 : 0,
      'termsAccepted': termsAccepted ? 1 : 0,
      'termsAcceptedAt': termsAcceptedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastActiveAt': lastActiveAt?.toIso8601String(),
    };
  }
}
extension BloodBankCopy on BloodBankModel {
  BloodBankModel copyWith({
    double? latitude,
    double? longitude,
  }) {
    return BloodBankModel(
      bloodBankId: bloodBankId,
      userId: userId,
      licenseNumber: licenseNumber,
      licenseExpiryDate: licenseExpiryDate,
      registeredAuthority: registeredAuthority,
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
      bloodStock: bloodStock,
      dailyCapacity: dailyCapacity,
      availableUnitsToday: availableUnitsToday,
      isActive: isActive,
      termsAccepted: termsAccepted,
      termsAcceptedAt: termsAcceptedAt,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      lastActiveAt: lastActiveAt,
    );
  }
}

