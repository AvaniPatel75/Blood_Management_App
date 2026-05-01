import 'package:blood_bank_app/database/databse_service.dart';
import 'package:blood_bank_app/model/User.dart';
import 'package:sqflite/sqflite.dart';

class UserApiService {
  final DatabaseService _dbService = DatabaseService();

  // ----------------------------------
  // CREATE
  // ----------------------------------
  Future<void> createUser(UserModel user) async {
    final db = await _dbService.database;
    await db.insert(
      'users',
      user.toMap(includePassword: true),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ----------------------------------
  // READ
  // ----------------------------------

  /// Get all users
  Future<List<UserModel>> getAllUsers() async {
    final db = await _dbService.database;
    final result = await db.query(
      'users',
      orderBy: 'createdAt DESC',
    );
    return result.map((u) => UserModel.fromMap(u)).toList();
  }

  /// Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    final db = await _dbService.database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }

  /// Get user by email (for login)
  Future<UserModel?> getUserByEmail(String email) async {
    final db = await _dbService.database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    print("User from Service file $result");
    if ( result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }

  // ----------------------------------
  // UPDATE
  // ----------------------------------
  Future<void> updateUser(UserModel user) async {
    final db = await _dbService.database;
    await db.update(
      'users',
      user.toMap(includePassword: false),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  /// Update last active timestamp
  Future<void> updateLastActive(String userId) async {
    final db = await _dbService.database;
    await db.update(
      'users',
      {
        'lastActiveAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  /// Update user password
  Future<void> updatePassword(String userId, String newPassword) async {
    final db = await _dbService.database;
    await db.update(
      'users',
      {
        'password': newPassword,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // ----------------------------------
  // DELETE
  // ----------------------------------
  Future<void> deleteUser(String userId) async {
    final db = await _dbService.database;
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // ----------------------------------
  // SEARCH & FILTER
  // ----------------------------------

  /// Search users by name or email
  Future<List<UserModel>> searchUsers(String query) async {
    final db = await _dbService.database;
    final result = await db.query(
      'users',
      where: 'name LIKE ? OR email LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );

    return result.map((u) => UserModel.fromMap(u)).toList();
  }

  /// Filter users by role
  Future<List<UserModel>> getUsersByRole(String role) async {
    final db = await _dbService.database;
    final result = await db.query(
      'users',
      where: 'role = ?',
      whereArgs: [role],
    );

    return result.map((u) => UserModel.fromMap(u)).toList();
  }

  /// Filter users by status (active/inactive)
  Future<List<UserModel>> getUsersByStatus(String status) async {
    final db = await _dbService.database;
    final result = await db.query(
      'users',
      where: 'status = ?',
      whereArgs: [status],
    );

    return result.map((u) => UserModel.fromMap(u)).toList();
  }
}
