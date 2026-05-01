import 'package:uuid/uuid.dart';

class UserModel {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String status;
  final String? password;

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastActiveAt;

  UserModel({
    String? id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.status,
    this.password,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.lastActiveAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap({bool includePassword = false}) {
    final map = {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastActiveAt': lastActiveAt?.toIso8601String(),
    };

    if (includePassword) map['password'] = password;
    return map;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      role: map['role'],
      status: map['status'],
      password: map['password'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      lastActiveAt: map['lastActiveAt'] != null
          ? DateTime.parse(map['lastActiveAt'])
          : null,
    );
  }
}
