// import 'package:blood_bank_app/database/api/user_api_service.dart';
// import 'package:blood_bank_app/model/User.dart';
// import 'package:get/get.dart';
//
// class UserController extends GetxController {
//   final UserApiService _apiService = UserApiService();
//
//   RxList<UserModel> users = <UserModel>[].obs;
//   RxList<UserModel> filteredUsers = <UserModel>[].obs;
//
//   Rx<UserModel?> currentUser = Rx<UserModel?>(null);
//
//   RxBool isLoading = false.obs;
//   RxBool isLoggedIn = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchAllUsers();
//   }
//
//   Future<void> fetchAllUsers() async {
//     try {
//       isLoading.value = true;
//       final result = await _apiService.getAllUsers();
//       users.value = result;
//       filteredUsers.value = result;
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // 🔐 Blood Bank Login Only
//   Future<UserModel?> loginBloodBank(String email, String password) async {
//     isLoading.value = true;
//
//     final user = await _apiService.getUserByEmail(email);
//
//     isLoading.value = false;
//
//     if (user == null) return null;
//     if (user.role != 'bloodBank') return null;
//     if (user.password != password) return null;
//
//     currentUser.value = user;
//     isLoggedIn.value = true;
//
//     await _apiService.updateLastActive(user.id!);
//     return user;
//   }
//
//   void logout() {
//     currentUser.value = null;
//     isLoggedIn.value = false;
//   }
// }
