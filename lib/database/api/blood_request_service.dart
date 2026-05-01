import 'package:blood_bank_app/database/databse_service.dart';
import 'package:sqflite/sqflite.dart';
import '../../model/Blood_request.dart';

class BloodRequestService {
  final DatabaseService _dbHelper = DatabaseService();

  Future<void> createBloodRequest(BloodRequestModel request) async {
    final Database db = await _dbHelper.database;

    await db.insert(
      'blood_requests',
      request.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<BloodRequestModel>> getAllBloodRequests() async {
    final Database db = await _dbHelper.database;

    final List<Map<String, dynamic>> result =
    await db.query('blood_requests');

    return result
        .map((map) => BloodRequestModel.fromMap(map))
        .toList();
  }

  Future<BloodRequestModel?> getBloodRequestById(String id) async {
    final Database db = await _dbHelper.database;

    final List<Map<String, dynamic>> result = await db.query(
      'blood_requests',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return BloodRequestModel.fromMap(result.first);
    }
    return null;
  }

  Future<int> updateBloodRequest(BloodRequestModel request) async {
    final Database db = await _dbHelper.database;

    return await db.update(
      'blood_requests',
      request.toMap(),
      where: 'id = ?',
      whereArgs: [request.id],
    );
  }

  Future<int> deleteBloodRequest(String id) async {
    final Database db = await _dbHelper.database;

    return await db.delete(
      'blood_requests',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<BloodRequestModel>> searchBloodRequests(String keyword) async {
    final Database db = await _dbHelper.database;

    final List<Map<String, dynamic>> result = await db.query(
      'blood_requests',
      where: '''
        bloodType LIKE ? OR
        urgency LIKE ? OR
        status LIKE ? OR
        requiredDate LIKE ?
      ''',
      whereArgs: List.filled(4, '%$keyword%'),
    );

    return result
        .map((map) => BloodRequestModel.fromMap(map))
        .toList();
  }
}
