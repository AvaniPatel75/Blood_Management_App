import 'package:blood_bank_app/database/databse_service.dart';
import 'package:sqflite/sqflite.dart';
import '../../model/Inventory.dart';

class BloodInventoryService {
  final DatabaseService _dbHelper = DatabaseService();

  Future<void> createInventory(BloodInventoryModel inventory) async {
    final Database db = await _dbHelper.database;

    await db.insert(
      'blood_inventory',
      inventory.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<BloodInventoryModel>> getInventoryByBloodBankId(String bloodBankId) async {
    final Database db = await _dbHelper.database;

    final List<Map<String, dynamic>> result = await db.query(
      'blood_inventory',
      where: 'bloodBankId = ?',
      whereArgs: [bloodBankId],
    );

    return result
        .map((map) => BloodInventoryModel.fromMap(map))
        .toList();
  }

  Future<List<BloodInventoryModel>> getAllInventory() async {
    final Database db = await _dbHelper.database;

    final List<Map<String, dynamic>> result = await db.query('blood_inventory');

    return result
        .map((map) => BloodInventoryModel.fromMap(map))
        .toList();
  }

  Future<void> updateInventory(BloodInventoryModel inventory) async {
    final Database db = await _dbHelper.database;

    await db.update(
      'blood_inventory',
      inventory.toMap(),
      where: 'id = ?',
      whereArgs: [inventory.id],
    );
  }

  Future<void> deleteInventory(String id) async {
    final Database db = await _dbHelper.database;

    await db.delete(
      'blood_inventory',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
