class BloodRequestModel {
  final String id;
  final String requesterId;
  final String? bloodType;
  final String? urgency;
  final String? status;
  final String? requiredDate;

  BloodRequestModel({
    required this.id,
    required this.requesterId,
    this.bloodType,
    this.urgency,
    this.status,
    this.requiredDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'requesterId': requesterId,
      'bloodType': bloodType,
      'urgency': urgency,
      'status': status,
      'requiredDate': requiredDate,
    };
  }

  factory BloodRequestModel.fromMap(Map<String, dynamic> map) {
    return BloodRequestModel(
      id: map['id'],
      requesterId: map['requesterId'],
      bloodType: map['bloodType'],
      urgency: map['urgency'],
      status: map['status'],
      requiredDate: map['requiredDate'],
    );
  }
}