import 'package:blood_bank_app/database/databse_service.dart';
import 'package:blood_bank_app/model/Blood_bank_model.dart';
import 'package:sqflite/sqflite.dart';

class BloodBankApiService {
  final DatabaseService _db = DatabaseService();

  /// Get all blood banks
  Future<List<BloodBankModel>> getAllBloodBanks() async {
    final db = await _db.database;
    final result = await db.query('blood_banks');
    return result.map((b) => BloodBankModel.fromMap(b)).toList();
  }

  /// Create a new blood bank
  Future<void> createBloodBank(BloodBankModel bloodBank) async {
    final db = await _db.database;
    await db.insert(
      'blood_banks',
      bloodBank.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Delete a blood bank by ID
  Future<void> deleteBloodBank(String bloodBankId) async {
    final db = await _db.database;
    await db.delete(
      'blood_banks',
      where: 'bloodBankId = ?',
      whereArgs: [bloodBankId],
    );
  }

  /// Update a blood bank
  Future<void> updateBloodBank(BloodBankModel bloodBank) async {
    final db = await _db.database;
    await db.update(
      'blood_banks',
      bloodBank.toMap(),
      where: 'bloodBankId = ?',
      whereArgs: [bloodBank.bloodBankId],
    );
  }

  /// Get a blood bank by ID
  Future<BloodBankModel?> getBloodBankById(String bloodBankId) async {
    final db = await _db.database;
    final result = await db.query(
      'blood_banks',
      where: 'bloodBankId = ?',
      whereArgs: [bloodBankId],
    );
    if (result.isNotEmpty) {
      return BloodBankModel.fromMap(result.first);
    }
    return null;
  }

  /// Get a blood bank by User ID
  Future<BloodBankModel?> getBloodBankByUserId(String userId) async {
    final db = await _db.database;
    final result = await db.query(
      'blood_banks',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    if (result.isNotEmpty) {
      return BloodBankModel.fromMap(result.first);
    }
    return null;
  }
}
