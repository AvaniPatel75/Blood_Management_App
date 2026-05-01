import 'package:flutter/material.dart';

// 1. Define the Enum
enum UserRole {
  donor,
  patient,
  bloodBank,
  hospital,
}
//
// // 2. Define the Extension (This fixes the .title error)
// extension UserRoleExtension on UserRole {
//
//   // This makes .title work
//   String get title {
//     switch (this) {
//       case UserRole.donor: return "Donor";
//       case UserRole.patient: return "Patient";
//       case UserRole.bloodBank: return "Blood Bank";
//       case UserRole.hospital: return "Hospital";
//     }
//   }
//
//   // This makes .icon work
//   IconData get icon {
//     switch (this) {
//       case UserRole.donor: return Icons.favorite;
//       case UserRole.patient: return Icons.person;
//       case UserRole.bloodBank: return Icons.bloodtype;
//       case UserRole.hospital: return Icons.local_hospital;
//     }
//   }
// }