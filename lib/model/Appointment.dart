class AppointmentModel {
  final String id;
  final String donorId;
  final String? hospitalId;
  final String? bloodBankId;
  final String? scheduledAt;
  final String? status;

  AppointmentModel({
    required this.id,
    required this.donorId,
    this.hospitalId,
    this.bloodBankId,
    this.scheduledAt,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'donorId': donorId,
      'hospitalId': hospitalId,
      'bloodBankId': bloodBankId,
      'scheduledAt': scheduledAt,
      'status': status,
    };
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'],
      donorId: map['donorId'],
      hospitalId: map['hospitalId'],
      bloodBankId: map['bloodBankId'],
      scheduledAt: map['scheduledAt'],
      status: map['status'],
    );
  }
}