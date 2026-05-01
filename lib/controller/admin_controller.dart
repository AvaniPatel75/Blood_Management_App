// import 'package:blood_bank_app/model/Blood_bank_model.dart';
// import 'package:blood_bank_app/model/User.dart';
//
// class AdminController {
//   final List<UserModel> users = [];
//
//
//   // void approveBloodBank(BloodBankModel bank) {
//   //   users.add(bank);
//   // }
//
//
//   void blockUser(String userId) {
//     final user = users.firstWhere((u) => u.id == userId);
//     users.remove(user);
//     users.add(UserModel(
//       id: user.id,
//       name: user.name,
//       email: user.email,
//       phone: user.phone,
//       role: user.role,
//       status: 'BLOCKED',
//     ));
//   }
// }