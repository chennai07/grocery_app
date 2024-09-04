import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Private constructor to prevent direct instantiation
  DatabaseHelper._internal();

  // Single instance of DatabaseHelper
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  // Factory constructor to provide access to the single instance
  factory DatabaseHelper() => _instance;

  static Database? _database;

  // Getter for database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Method to initialize the database
  Future<Database> _initDatabase() async {
    // Path to the database file
    String path = join(await getDatabasesPath(), 'app_database.db');

    // Open the database and create tables if they don't exist
    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE shipping_addresses ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'user_id INTEGER NOT NULL, '
          'recipient_name TEXT NOT NULL, '
          'street_address TEXT NOT NULL, '
          'city TEXT NOT NULL, '
          'state TEXT NOT NULL, '
          'postal_code TEXT NOT NULL, '
          'country TEXT NOT NULL, '
          'phone_number TEXT, '
          'created_at DATETIME DEFAULT CURRENT_TIMESTAMP, '
          'updated_at DATETIME DEFAULT CURRENT_TIMESTAMP'
          ')',
        );
      },
      version: 1,
    );
  }

  // Method to insert a record
  Future<void> insertAddress(Map<String, dynamic> address) async {
    final db = await database;
    await db.insert(
      'shipping_addresses',
      address,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Method to retrieve all records
  Future<List<Map<String, dynamic>>> getAddresses() async {
    final db = await database;
    return await db.query('shipping_addresses');
  }

  // Method to update a record
  Future<void> updateAddress(int id, Map<String, dynamic> updatedValues) async {
    final db = await database;

    // Set the updated_at field to the current timestamp
    updatedValues['updated_at'] = DateTime.now().toIso8601String();

    await db.update(
      'shipping_addresses',
      updatedValues,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Method to delete a record
  Future<void> deleteAddress(int id) async {
    final db = await database;
    await db.delete(
      'shipping_addresses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
