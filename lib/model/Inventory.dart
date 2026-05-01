class BloodInventoryModel {
  final String id;
  final String bloodBankId;
  final String? bloodType;
  final int? unitsAvailable;
  final String? lastUpdated;

  BloodInventoryModel({
    required this.id,
    required this.bloodBankId,
    this.bloodType,
    this.unitsAvailable,
    this.lastUpdated,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bloodBankId': bloodBankId,
      'bloodType': bloodType,
      'unitsAvailable': unitsAvailable,
      'lastUpdated': lastUpdated,
    };
  }

  factory BloodInventoryModel.fromMap(Map<String, dynamic> map) {
    return BloodInventoryModel(
      id: map['id'],
      bloodBankId: map['bloodBankId'],
      bloodType: map['bloodType'],
      unitsAvailable: map['unitsAvailable'],
      lastUpdated: map['lastUpdated'],
    );
  }
}