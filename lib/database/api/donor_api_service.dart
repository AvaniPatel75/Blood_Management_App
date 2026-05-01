// ✅ DonorApiService.dart - Same pattern as PatientApiService
import 'package:blood_bank_app/database/databse_service.dart';
import 'package:blood_bank_app/database/api/user_api_service.dart';
import 'package:blood_bank_app/model/Donor.dart';
import 'package:blood_bank_app/model/user.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonorApiService {
  final DatabaseService _dbService = DatabaseService();
  final UserApiService _userApiService = UserApiService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get all donors WITH USER DATA auto-populated
  Future<List<DonorModel>> getAllDonors() async {
    final db = await _dbService.database;
    final result = await db.query('donors');
    final donors = result.map((d) => DonorModel.fromMap(d)).toList();

    for (var donor in donors) {
      await _populateUserFields(donor);
    }
    return donors;
  }

  Future<DonorModel?> getDonorByUserId(String userId) async {
    final db = await _dbService.database;
    final result = await db.query(
      'donors',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    if (result.isNotEmpty) {
      return DonorModel.fromMap(result.first);
    }
    return null;
  }

  /// Create donor - AUTO-FETCH user data
  Future<void> createDonor(DonorModel donor) async {
    try {
      //await _firestore.collection('donors').add(donor.toMap()); // ✅ Sends to Firebase
      Get.snackbar('Success', 'Donor added successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add donor: $e');
    }
    final db = await _dbService.database;

    // ✅ AUTO-POPULATE from USER table
    // final user = await _userApiService.getUserById(donor.userId);
    // if (user != null) {
    //   donor.name = user.name;
    //   donor.email = user.email;
    //   donor.status = user.status;
    // }

    await db.insert(
      'donors',
      donor.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Update donor - RE-POPULATE user data
  Future<void> updateDonor(DonorModel donor) async {
    final db = await _dbService.database;

    final user = await _userApiService.getUserById(donor.userId);
    if (user != null) {
      donor.name = user.name;
      donor.email = user.email;
      donor.status = user.status;
    }

    await db.update(
      'donors',
      donor.toMap(),
      where: 'donorId = ?',
      whereArgs: [donor.donorId],
    );
  }

  Future<void> _populateUserFields(DonorModel donor) async {
    final user = await _userApiService.getUserById(donor.userId);
    if (user != null) {
      donor.name = user.name;
      donor.email = user.email;
      donor.status = user.status;
    }
  }

  Future<void> deleteDonor(String donorId) async {
    final db = await _dbService.database;
    await db.delete('donors', where: 'donorId = ?', whereArgs: [donorId]);
  }

  Future<DonorModel?> getDonorById(String donorId) async {
    final db = await _dbService.database;
    final result = await db.query('donors', where: 'donorId = ?', whereArgs: [donorId]);
    if (result.isNotEmpty) {
      final donor = DonorModel.fromMap(result.first);
      await _populateUserFields(donor);
      return donor;
    }
    return null;
  }
}
