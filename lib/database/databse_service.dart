import 'dart:async';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  DatabaseService._internal();
  factory DatabaseService() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'blood_bank_final.db');
    return await openDatabase(
      path,
      version: 9,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 8) {
      await db.execute('ALTER TABLE patients ADD COLUMN email TEXT');
      await db.execute('ALTER TABLE patients ADD COLUMN status TEXT');
    }
    if (oldVersion < 9) {
      // Add Lat/Lng to Donors
      try {
        await db.execute('ALTER TABLE donors ADD COLUMN latitude REAL');
        await db.execute('ALTER TABLE donors ADD COLUMN longitude REAL');
      } catch (e) {
        print("Error adding lat/lng to donors: $e");
      }
      // Add Lat/Lng to Patients
      try {
        await db.execute('ALTER TABLE patients ADD COLUMN latitude REAL');
        await db.execute('ALTER TABLE patients ADD COLUMN longitude REAL');
      } catch (e) {
        print("Error adding lat/lng to patients: $e");
      }
    }
  }



  // ------------------ CREATE TABLES ------------------
  Future<void> _createTables(Database db, int version) async {
    // 1. USERS TABLE (AUTH & ROLE)
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        phone TEXT,
        role TEXT NOT NULL,
        status TEXT,
        password TEXT,
        createdAt TEXT,
        updatedAt TEXT,
        lastActiveAt TEXT
      )
    ''');

    // 2. PATIENTS TABLE
    await db.execute('''
      CREATE TABLE patients (
        patientId TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        gender TEXT,
        age INTEGER,
        bloodGroup TEXT,
        medicalCondition TEXT,
        emergencyContact TEXT,
        isCritical INTEGER,

        street TEXT,
        city TEXT,
        state TEXT,
        country TEXT,
        postalCode TEXT,
        latitude REAL,
        longitude REAL,

        createdAt TEXT,
        updatedAt TEXT,
        lastActiveAt TEXT,

        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // 3. DONORS TABLE
    await db.execute('''
      CREATE TABLE donors (
        donorId TEXT PRIMARY KEY,
        userId TEXT NOT NULL,

        bloodGroup TEXT,
        lastDonationDate TEXT,
        isActiveDonor INTEGER,
        medicalNotes TEXT,

        street TEXT,
        city TEXT,
        state TEXT,
        country TEXT,
        postalCode TEXT,
        latitude REAL,
        longitude REAL,

        createdAt TEXT,
        updatedAt TEXT,
        lastActiveAt TEXT,

        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // 4. HOSPITALS TABLE
    await db.execute('''
      CREATE TABLE hospitals (
        hospitalId TEXT PRIMARY KEY,
        userId TEXT NOT NULL,

        licenseNumber TEXT,
        licenseExpiryDate TEXT,
        registeredAuthority TEXT,

        isApproved INTEGER,
        isVerified INTEGER,
        verificationNote TEXT,
        verifiedAt TEXT,
        verifiedBy TEXT,

        street TEXT,
        city TEXT,
        state TEXT,
        country TEXT,
        postalCode TEXT,
        latitude REAL,
        longitude REAL,

        emergencyPhone TEXT,
        landline TEXT,
        website TEXT,

        is24x7 INTEGER,
        workingDays TEXT,
        openingTime TEXT,
        closingTime TEXT,

        totalBeds INTEGER,
        availableBeds INTEGER,
        departments TEXT,

        isActive INTEGER,
        termsAccepted INTEGER,
        termsAcceptedAt TEXT,

        createdAt TEXT,
        updatedAt TEXT,
        lastActiveAt TEXT,

        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // 5. BLOOD BANKS TABLE
    await db.execute('''
      CREATE TABLE blood_banks (
        bloodBankId TEXT PRIMARY KEY,
        userId TEXT NOT NULL,

        licenseNumber TEXT,
        licenseExpiryDate TEXT,
        registeredAuthority TEXT,

        isVerified INTEGER,
        verificationNote TEXT,
        verifiedAt TEXT,
        verifiedBy TEXT,

        street TEXT,
        city TEXT,
        state TEXT,
        country TEXT,
        postalCode TEXT,
        latitude REAL,
        longitude REAL,

        emergencyPhone TEXT,
        landline TEXT,
        website TEXT,

        is24x7 INTEGER,
        workingDays TEXT,
        openingTime TEXT,
        closingTime TEXT,

        bloodStock TEXT,
        dailyCapacity INTEGER,
        availableUnitsToday INTEGER,

        isActive INTEGER,
        termsAccepted INTEGER,
        termsAcceptedAt TEXT,

        createdAt TEXT,
        updatedAt TEXT,
        lastActiveAt TEXT,

        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // 6. DONATIONS TABLE
    await db.execute('''
      CREATE TABLE donations (
        id TEXT PRIMARY KEY,
        donorId TEXT NOT NULL,
        targetId TEXT NOT NULL,
        bloodType TEXT,
        units INTEGER,
        status TEXT,
        donationDate TEXT,

        FOREIGN KEY (donorId) REFERENCES donors (donorId) ON DELETE CASCADE
      )
    ''');

    // 7. BLOOD REQUESTS TABLE
    await db.execute('''
      CREATE TABLE blood_requests (
        id TEXT PRIMARY KEY,
        requesterId TEXT NOT NULL,
        bloodType TEXT,
        urgency TEXT,
        status TEXT,
        requiredDate TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE appointments (
        id TEXT PRIMARY KEY,
        donorId TEXT NOT NULL,
        hospitalId TEXT,
        bloodBankId TEXT,
        scheduledAt TEXT,
        status TEXT,
        FOREIGN KEY(donorId) REFERENCES donors(donorId),
        FOREIGN KEY(hospitalId) REFERENCES hospitals(hospitalId),
        FOREIGN KEY(bloodBankId) REFERENCES blood_banks(bloodBankId)
      );
    ''');
    await db.execute('''
      CREATE TABLE blood_inventory (
        id TEXT PRIMARY KEY,
        bloodBankId TEXT NOT NULL,
        bloodType TEXT,
        unitsAvailable INTEGER,
        lastUpdated TEXT,
        FOREIGN KEY(bloodBankId) REFERENCES blood_banks(bloodBankId)
      );
    ''');

    await db.execute('''
      CREATE TABLE notifications (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        title TEXT,
        message TEXT,
        isRead INTEGER DEFAULT 0,
        createdAt TEXT,
        FOREIGN KEY(userId) REFERENCES users(id) ON DELETE CASCADE
      );
    ''');
  }

}
