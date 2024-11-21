import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/expense.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'expenses.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE expenses(id INTEGER PRIMARY KEY, title TEXT, category TEXT, amount REAL, date TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insertExpense(Expense expense) async {
    final db = await DBHelper.database();
    db.insert('expenses', expense.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Expense>> getExpenses() async {
    final db = await DBHelper.database();
    final data = await db.query('expenses');
    return data.map((item) => Expense(
      id: item['id'] as int,
      title: item['title'] as String,
      category: item['category'] as String,
      amount: item['amount'] as double,
      date: item['date'] as String,
    )).toList();
  }
}
