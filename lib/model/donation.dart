import 'package:uuid/uuid.dart';

class DonationModel {
  String id;
  final String donorId;
  final String targetId;
  final String? bloodType;
  final int? units;
  final String? status;
  final String? donationDate;

  DonationModel({
    String? id,
    required this.donorId,
    required this.targetId,
    this.bloodType,
    this.units,
    this.status,
    this.donationDate,
  }): id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'donorId': donorId,
      'targetId': targetId,
      'bloodType': bloodType,
      'units': units,
      'status': status,
      'donationDate': donationDate,
    };
  }

  factory DonationModel.fromMap(Map<String, dynamic> map) {
    return DonationModel(
      id: map['id'],
      donorId: map['donorId'],
      targetId: map['targetId'],
      bloodType: map['bloodType'],
      units: map['units'],
      status: map['status'],
      donationDate: map['donationDate'],
    );
  }
}