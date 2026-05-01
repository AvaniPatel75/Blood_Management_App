import 'package:blood_bank_app/database/api/user_api_service.dart';
import 'package:blood_bank_app/model/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final UserApiService _apiService = UserApiService();

  // -------------------------------
  // STATE
  // -------------------------------
  RxList<UserModel> users = <UserModel>[].obs;
  RxList<UserModel> filteredUsers = <UserModel>[].obs;

  Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  RxBool isLoading = false.obs;
  RxBool isLoggedIn = false.obs;

  // -------------------------------
  // LIFECYCLE
  // -------------------------------
  @override
  void onInit() {
    super.onInit();
    fetchAllUsers();
  }

  // -------------------------------
  // FETCH
  // -------------------------------
  Future<void> fetchAllUsers() async {
    try {
      isLoading.value = true;

      final List<UserModel> result = await _apiService.getAllUsers();

      users.assignAll(result);
      filteredUsers.assignAll(result);

    } catch (e) {
      print('Error fetching users: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<UserModel?> getUserById(String userId)async{
    return await _apiService.getUserById(userId);
  }


  Future<UserModel?> login(String email, String password) async {
    isLoading.value = true;
    print("UserController Login: Attempting login for $email with password '$password'");

    final user = await _apiService.getUserByEmail(email);

    if (user == null) {
      print("UserController Login: User not found in DB for email $email");
      isLoading.value = false;
      return null;
    }

    print("UserController Login: User found. DB Password: '${user.password}'");

    if (user.password != password) {
      print("UserController Login: Password mismatch! Input: '$password' vs DB: '${user.password}'");
      isLoading.value = false;
      return null;
    }

    print("UserController Login: Success!");
    currentUser.value = user;
    isLoggedIn.value = true;
    await _apiService.updateLastActive(user.id!);

    isLoading.value = false;
    return user;
  }



  void logout() {
    currentUser.value = null;
    isLoggedIn.value = false;
  }

  Future<void> addUser(UserModel user) async {
    await _apiService.createUser(user);
    fetchAllUsers();
  }

  Future<void> updateUser(UserModel user) async {
    await _apiService.updateUser(user);
    fetchAllUsers();
  }

  Future<void> deleteUser(String userId) async {
    await _apiService.deleteUser(userId);
    fetchAllUsers();
  }

  Future<void> updatePassword(String userId, String newPassword) async {
    await _apiService.updatePassword(userId, newPassword);
  }

  // -------------------------------
  // SEARCH & FILTER
  // -------------------------------

  /// Search users by name or email
  void searchUsers(String query) {
    if (query.isEmpty) {
      filteredUsers.assignAll(users);
    } else {
      filteredUsers.assignAll(
        users.where(
              (u) =>
          u.name.toLowerCase().contains(query.toLowerCase()) ||
              u.email.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

  /// Filter by role
  void filterByRole(String role) {
    filteredUsers.assignAll(
      users.where((u) => u.role == role),
    );
  }

  /// Filter by status
  void filterByStatus(String status) {
    filteredUsers.assignAll(
      users.where((u) => u.status == status),
    );
  }

  /// Clear filters
  void clearFilters() {
    filteredUsers.assignAll(users);
  }

  // -------------------------------
  // HELPERS
  // -------------------------------
  bool get hasUsers => users.isNotEmpty;
  int get totalUsers => users.length;
  bool get isAdmin => currentUser.value?.role == 'admin';
}
