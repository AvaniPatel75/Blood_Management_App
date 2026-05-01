import 'package:blood_bank_app/database/databse_service.dart';
import 'package:blood_bank_app/model/Hospital.dart';
import 'package:sqflite/sqflite.dart';

class HospitalApiService {
  final DatabaseService _db = DatabaseService();

  /// Get all hospitals
  Future<List<HospitalModel>> getAllHospitals() async {
    final db = await _db.database;
    final result = await db.query('hospitals');
    return result.map((h) => HospitalModel.fromMap(h)).toList();
  }

  /// Create a new hospital
  Future<void> createHospital(HospitalModel hospital) async {
    final db = await _db.database;
    await db.insert(
      'hospitals',
      hospital.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Delete a hospital by ID
  Future<void> deleteHospital(String hospitalId) async {
    final db = await _db.database;
    await db.delete(
      'hospitals',
      where: 'hospitalId = ?',
      whereArgs: [hospitalId],
    );
  }

  /// Update a hospital
  Future<void> updateHospital(HospitalModel hospital) async {
    final db = await _db.database;
    await db.update(
      'hospitals',
      hospital.toMap(),
      where: 'hospitalId = ?',
      whereArgs: [hospital.hospitalId],
    );
  }

  /// Get a hospital by ID
  Future<HospitalModel?> getHospitalById(String hospitalId) async {
    final db = await _db.database;
    final result = await db.query(
      'hospitals',
      where: 'hospitalId = ?',
      whereArgs: [hospitalId],
    );
    if (result.isNotEmpty) {
      return HospitalModel.fromMap(result.first);
    }
    return null;
  }
  /// Update hospital dynamically based on any field(s)
  Future<void> updateHospitalDynamic({
    required HospitalModel hospital,
    required Map<String, dynamic> whereFields,
  }) async {
    final db = await _db.database;

    if (whereFields.isEmpty) {
      throw Exception("No fields provided to identify which row to update.");
    }

    // Build WHERE clause dynamically
    final whereClause = whereFields.keys.map((k) => '$k = ?').join(' AND ');
    final whereArgs = whereFields.values.toList();

    await db.update(
      'hospitals',
      hospital.toMap(),
      where: whereClause,
      whereArgs: whereArgs,
    );
  }
  Future<void> searchHospitalByName() async{
    final db = await _db.database;

  }

}
