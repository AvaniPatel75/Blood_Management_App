import 'package:blood_bank_app/model/donation.dart';
import 'package:sqflite/sqflite.dart';

import '../databse_service.dart';

class DonationApiService {
  final DatabaseService _db = DatabaseService();

  /// Get all donations recorded in the system
  Future<List<DonationModel>> getAllDonations() async {
    final db = await _db.database;
    final result = await db.query('donations');
    return result.map((d) => DonationModel.fromMap(d)).toList();
  }

  /// Create a new donation record
  Future<void> createDonation(DonationModel donation) async {
    final db = await _db.database;
    await db.insert(
      'donations',
      donation.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<List<DonationModel>> getDonationsByDonorId(String donorId) async {
    final db = await _db.database;
    final result = await db.query(
      'donations',
      where: 'donorId = ?',
      whereArgs: [donorId],
      orderBy: 'donationDate DESC',
    );
    return result.map((d) => DonationModel.fromMap(d)).toList();
  }

  Future<DonationModel?> getDonationById(String id) async {
    final db = await _db.database;
    final result = await db.query(
      'donations',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return DonationModel.fromMap(result.first);
    }
    return null;
  }

  Future<void> updateDonation(DonationModel donation) async {
    final db = await _db.database;
    await db.update(
      'donations',
      donation.toMap(),
      where: 'id = ?',
      whereArgs: [donation.id],
    );
  }

  Future<void> deleteDonation(String id) async {
    final db = await _db.database;
    await db.delete(
      'donations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> approveDonation(String donationId) async {
    final db = await _db.database;

    await db.update(
      'donations',
      {'status': 'completed'},
      where: 'id = ?',
      whereArgs: [donationId],
    );
  }
}