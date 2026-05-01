// ✅ FIXED PatientModel.dart - Added Lat/Lng
import 'package:uuid/uuid.dart';

class PatientModel {
  final String patientId;
  final String userId;

  String name;
  String email;
  String status;

  final String gender;
  final int age;
  final String bloodGroup;
  final String medicalCondition;
  final String emergencyContact;
  final bool isCritical;
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

  PatientModel({
    String? patientId,
    required this.userId,
    required this.name,
    required this.email,
    required this.status,
    required this.gender,
    required this.age,
    required this.bloodGroup,
    required this.medicalCondition,
    required this.emergencyContact,
    this.isCritical = false,
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
  })  : patientId = patientId ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory PatientModel.fromMap(Map<String, dynamic> map) {
    return PatientModel(
      patientId: map['patientId'] ?? const Uuid().v4(),
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      status: map['status'] ?? '',
      gender: map['gender'] ?? 'OTHER',
      age: map['age'] ?? 0,
      bloodGroup: map['bloodGroup'] ?? '',
      medicalCondition: map['medicalCondition'] ?? '',
      emergencyContact: map['emergencyContact'] ?? '',
      isCritical: map['isCritical'] == 1,
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
      'patientId': patientId,
      'userId': userId,
      'name': name,
      'email': email,
      'status': status,
      'gender': gender,
      'age': age,
      'bloodGroup': bloodGroup,
      'medicalCondition': medicalCondition,
      'emergencyContact': emergencyContact,
      'isCritical': isCritical ? 1 : 0,
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
