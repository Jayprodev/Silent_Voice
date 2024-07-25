import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'silentvoice.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        password TEXT,
        phoneNumber TEXT,
        disabilityStatus TEXT
      )
    ''');
  }

  // CRUD operations for SQLite

  // Insert user
  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    int id = await db.insert('users', user);

    // Insert user into Firestore
    await FirebaseFirestore.instance.collection('users').doc(user['email']).set(user);

    return id;
  }

  // Get user by email
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (results.isNotEmpty) {
      return results.first;
    }

    // Fetch from Firestore if not found in SQLite
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(email).get();
    if (snapshot.exists) {
      return snapshot.data() as Map<String, dynamic>?;
    }

    return null;
  }

  // Get all users
  Future<List<Map<String, dynamic>>> getUsers() async {
    Database db = await database;
    return await db.query('users');
  }

  // Update user
  Future<int> updateUser(Map<String, dynamic> user) async {
    Database db = await database;
    int result = await db.update(
      'users',
      user,
      where: 'id = ?',
      whereArgs: [user['id']],
    );

    // Update user in Firestore
    await FirebaseFirestore.instance.collection('users').doc(user['email']).update(user);

    return result;
  }

  // Delete user
  Future<int> deleteUser(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      String email = results.first['email'];
      await FirebaseFirestore.instance.collection('users').doc(email).delete();
    }

    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
