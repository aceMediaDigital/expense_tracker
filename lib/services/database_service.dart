/* =======================================================
 *
 * Created by anele on 29/07/2025.
 *
 * @anele_ace
 *
 * =======================================================
 */

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {

  DatabaseService._internal();

  factory DatabaseService() => _instance;

  static final DatabaseService _instance = DatabaseService._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'expenses.db');

    return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
        onOpen: (Database db) async {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS expenses (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT,
              cost REAL,
              date TEXT,
              categoryId TEXT,
              categoryName TEXT
            )
          ''');
        }
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        cost REAL,
        date TEXT,
        categoryId TEXT,
        categoryName TEXT
      )
    ''');
  }

  /// Insert expense
  Future<int> insertExpense(Map<String, dynamic> expense) async {
    final Database db = await database;
    return await db.insert('expenses', expense);
  }

  /// Get all expenses
  Future<List<Map<String, dynamic>>> getExpenses() async {
    final Database db = await database;
    return await db.query('expenses', orderBy: 'id DESC');
  }

  /// Delete expense
  Future<int> deleteExpense(int id) async {
    final Database db = await database;
    return await db.delete('expenses', where: 'id = ?', whereArgs: <Object?>[id]);
  }


  /// Truncate Table
  Future<void> truncateExpenses() async {
    final Database db = await database;
    await db.delete('expenses');
  }


  /// Drop Table
  Future<void> dropExpenseTable() async {
    final Database db = await database;
    await db.execute('DROP TABLE IF EXISTS expenses');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        cost REAL,
        date TEXT,
        categoryId TEXT,
        categoryName TEXT
      )
    ''');
  }

  /// Close DB
  Future<void> close() async {
    final Database db = await database;
    db.close();
  }

}
