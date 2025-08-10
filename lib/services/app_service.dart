/* =======================================================
 *
 * Created by anele on 29/07/2025.
 *
 * @anele_ace
 *
 * =======================================================
 */

import 'package:intl/intl.dart';
import 'package:expense_tracker/services/services.dart';

class ExpenseAppService {

  ExpenseAppService._internal();

  factory ExpenseAppService() => _instance;

  static final ExpenseAppService _instance = ExpenseAppService._internal();

  final DatabaseService _dbService = DatabaseService();

  /// Private method to get all expenses
  Future<List<Map<String, dynamic>>> _fetchAllExpenses() async {
    return await _dbService.getExpenses();
  }

  /// Get Last Twenty Transactions
  Future<List<Map<String, dynamic>>> getLast20Expenses() async {
    final List<Map<String, dynamic>> allExpenses = List<Map<String, dynamic>>.from(await _fetchAllExpenses());

    // Now you can safely sort
    allExpenses.sort((Map<String, dynamic> a, Map<String, dynamic> b) =>
        (b['id'] as int).compareTo(a['id'] as int));

    return allExpenses.take(20).toList();
  }


  /// Truncate Expenses Table
  Future<void> truncateExpenses() async {
    await _dbService.truncateExpenses();
  }


  /// Truncate Expenses Table
  Future<void> dropExpensesTable() async {
    await _dbService.dropExpenseTable();
  }


  /// Get Current Month Expenses
  Future<List<Map<String, dynamic>>> getCurrentMonthExpenses() async {
    final List<Map<String, dynamic>> allExpenses = await _fetchAllExpenses();

    final DateTime now = DateTime.now();
    final int currentMonth = now.month;
    final int currentYear = now.year;
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    return allExpenses.where((Map<String, dynamic> expense) {
      try {
        final DateTime parsedDate = dateFormat.parse(expense['date']);
        return parsedDate.month == currentMonth && parsedDate.year == currentYear;
      } catch (e) {
        return false;
      }
    }).toList();
  }


  /// Get Previous Month Expenses
  Future<List<Map<String, dynamic>>> getPreviousMonthExpenses() async {
    final List<Map<String, dynamic>> allExpenses = await _fetchAllExpenses();

    final DateTime now = DateTime.now();
    final DateTime lastMonthDate = DateTime(now.year, now.month - 1, 1);
    final int lastMonth = lastMonthDate.month;
    final int lastMonthYear = lastMonthDate.year;
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    return allExpenses.where((Map<String, dynamic> expense) {
      try {
        final DateTime parsedDate = dateFormat.parse(expense['date']);
        return parsedDate.month == lastMonth && parsedDate.year == lastMonthYear;
      } catch (e) {
        return false;
      }
    }).toList();
  }


  /// Get all expenses from the database
  Future<List<Map<String, dynamic>>> getAllExpensesFromDB() async {
    return await _fetchAllExpenses();
  }


  /// Calculate Percentage Difference
  double calculateMonthlyChangePercentage({required double currentMonthTotal, required double lastMonthTotal,}) {
    if (lastMonthTotal == 0 && currentMonthTotal == 0) {
      return 0.0;
    }
    if (lastMonthTotal == 0) {
      // Avoid division by zero, treat as 100% increase
      return 100.0;
    }

    final double change = ((currentMonthTotal - lastMonthTotal) / lastMonthTotal) * 100;

    return change;
  }


  /// Insert An Expense to the DB
  Future<int> insertExpense({required String name, required double cost, required String date, required String categoryId, required String categoryName,}) async {
    // Convert date to yyyy-MM-dd for storage
    final DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(date);
    final String dbDate = DateFormat('yyyy-MM-dd').format(parsedDate);

    final Map<String, Object> expense = <String, Object>{
      'name': name,
      'cost': cost,
      'date': dbDate,
      'categoryId': categoryId,
      'categoryName': categoryName,
    };

    return await _dbService.insertExpense(expense);
  }


  /// Get Categories that have the most spend
  Future<Map<String, dynamic>> getCategoriesByTotal() async {
    final List<Map<String, dynamic>> allExpenses = await _dbService.getExpenses();

    final Map<String, double> categoryTotals = <String, double>{};
    double overallTotal = 0.0;

    for (final Map<String, dynamic> expense in allExpenses) {
      final String category = expense['categoryName'];
      final double cost = (expense['cost'] as num).toDouble();

      categoryTotals[category] = (categoryTotals[category] ?? 0) + cost;
      overallTotal += cost;
    }

    final List<Map<String, dynamic>> sortedCategories = categoryTotals.entries
        .map((MapEntry<String, double> e) => <String, Object>{'categoryName': e.key, 'total': e.value})
        .toList()
      ..sort((Map<String, Object> a, Map<String, Object> b) => (b['total'] as double).compareTo(a['total'] as double));

    return <String, dynamic>{
      'categories': sortedCategories,
      'grandTotal': overallTotal,
    };
  }

}
