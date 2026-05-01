// UPDATED PatientApiService.dart - Auto-populate from User table
import 'package:blood_bank_app/database/databse_service.dart';
import 'package:blood_bank_app/database/api/user_api_service.dart';  // ✅ NEW IMPORT
import 'package:blood_bank_app/model/Patient.dart';
import 'package:blood_bank_app/model/user.dart';  // ✅ NEW IMPORT
import 'package:sqflite/sqflite.dart';

class PatientApiService {
  final DatabaseService _dbService = DatabaseService();
  final UserApiService _userApiService = UserApiService();  // ✅ USER SERVICE

  /// Get all patients WITH USER DATA auto-populated
  Future<List<PatientModel>> getAllPatients() async {
    final db = await _dbService.database;
    final result = await db.query('patients');
    final patients = result.map((p) => PatientModel.fromMap(p)).toList();

    // ✅ AUTO-POPULATE USER FIELDS
    for (var patient in patients) {
      await _populateUserFields(patient);
    }
    return patients;
  }

  /// Create patient - AUTO-FETCH user data by userId
  Future<void> createPatient(PatientModel patient) async {
    final db = await _dbService.database;

    // ✅ 1. FETCH USER DATA first
    final user = await _userApiService.getUserById(patient.userId);
    if (user != null) {
      // ✅ 2. AUTO-POPULATE name, email, status from USER table
      patient = PatientModel(
        patientId: patient.patientId,
        userId: patient.userId,
        name: user.name,           // ✅ FROM USER
        email: user.email,         // ✅ FROM USER
        status: user.status,       // ✅ FROM USER
        gender: patient.gender,
        age: patient.age,
        bloodGroup: patient.bloodGroup,
        medicalCondition: patient.medicalCondition,
        emergencyContact: patient.emergencyContact,
        isCritical: patient.isCritical,
        street: patient.street,
        city: patient.city,
        state: patient.state,
        country: patient.country,
        postalCode: patient.postalCode,
      );
    }

    await db.insert(
      'patients',
      patient.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Update patient - RE-POPULATE user data on update
  Future<void> updatePatient(PatientModel patient) async {
    final db = await _dbService.database;

    // ✅ RE-POPULATE USER FIELDS on update
    final user = await _userApiService.getUserById(patient.userId);
    if (user != null) {
      patient = PatientModel(
        patientId: patient.patientId,
        userId: patient.userId,
        name: user.name,           // ✅ SYNC FROM USER
        email: user.email,         // ✅ SYNC FROM USER
        status: user.status,       // ✅ SYNC FROM USER
        gender: patient.gender,
        age: patient.age,
        bloodGroup: patient.bloodGroup,
        medicalCondition: patient.medicalCondition,
        emergencyContact: patient.emergencyContact,
        isCritical: patient.isCritical,
        street: patient.street,
        city: patient.city,
        state: patient.state,
        country: patient.country,
        postalCode: patient.postalCode,
        createdAt: patient.createdAt,
        updatedAt: DateTime.now(),  // ✅ UPDATE TIMESTAMP
      );
    }

    await db.update(
      'patients',
      patient.toMap(),
      where: 'patientId = ?',
      whereArgs: [patient.patientId],
    );
  }

  /// PRIVATE: Populate user fields for existing patient
  Future<void> _populateUserFields(PatientModel patient) async {
    final user = await _userApiService.getUserById(patient.userId);
    if (user != null && (patient.name.isEmpty || patient.email.isEmpty)) {
      // Update patient with user data (you might want to use a temp update here)
      patient.name = user.name;
      patient.email = user.email;
      patient.status = user.status;
    }
  }

  // Other methods remain same...
  Future<void> deletePatient(String patientId) async {
    final db = await _dbService.database;
    await db.delete('patients', where: 'patientId = ?', whereArgs: [patientId]);
  }

  Future<PatientModel?> getPatientById(String patientId) async {
    final db = await _dbService.database;
    final result = await db.query('patients', where: 'patientId = ?', whereArgs: [patientId]);
    if (result.isNotEmpty) {
      final patient = PatientModel.fromMap(result.first);
      await _populateUserFields(patient);  // ✅ ENSURE USER DATA
      return patient;
    }
    return null;
  }

  /// Get patient by User ID
  Future<PatientModel?> getPatientByUserId(String userId) async {
    final db = await _dbService.database;
    final result = await db.query('patients', where: 'userId = ?', whereArgs: [userId]);
    
    print("PatientApiService: Fetching patient for userId: $userId. Found: ${result.length} records.");

    if (result.isNotEmpty) {
      final patient = PatientModel.fromMap(result.first);
      await _populateUserFields(patient);
      return patient;
    }
    return null;
  }
}
