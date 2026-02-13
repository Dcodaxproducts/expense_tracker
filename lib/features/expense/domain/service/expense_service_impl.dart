import 'dart:convert';
import 'package:expense_tracker/features/expense/data/model/expense_category.dart';
import 'package:expense_tracker/features/expense/data/model/expense_model.dart';
import 'package:expense_tracker/features/expense/data/repository/expense_repo.dart';
import 'expense_service.dart';

class ExpenseServiceImpl implements ExpenseService {
  final ExpenseRepo repo;
  ExpenseServiceImpl({required this.repo});

  @override
  List<ExpenseModel> getExpenses() {
    final String? data = repo.getExpenses();
    if (data == null || data.isEmpty) return [];
    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((e) => ExpenseModel.fromJson(e)).toList();
  }

  Future<bool> _saveAll(List<ExpenseModel> expenses) async {
    final String json = jsonEncode(expenses.map((e) => e.toJson()).toList());
    return await repo.saveExpenses(json);
  }

  @override
  Future<bool> addExpense(String title, double amount, ExpenseCategory category, DateTime date, String? note) async {
    final expenses = getExpenses();
    final expense = ExpenseModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      amount: amount,
      category: category,
      date: date,
      note: note,
    );
    expenses.add(expense);
    return await _saveAll(expenses);
  }

  @override
  Future<bool> updateExpense(ExpenseModel expense) async {
    final expenses = getExpenses();
    final index = expenses.indexWhere((e) => e.id == expense.id);
    if (index == -1) return false;
    expenses[index] = expense;
    return await _saveAll(expenses);
  }

  @override
  Future<bool> deleteExpense(String id) async {
    final expenses = getExpenses();
    expenses.removeWhere((e) => e.id == id);
    return await _saveAll(expenses);
  }

  @override
  double getTotalExpenses(List<ExpenseModel> expenses) {
    return expenses.fold(0.0, (sum, e) => sum + e.amount);
  }

  @override
  Map<ExpenseCategory, double> getCategoryTotals(List<ExpenseModel> expenses) {
    final Map<ExpenseCategory, double> totals = {};
    for (final expense in expenses) {
      totals[expense.category] = (totals[expense.category] ?? 0) + expense.amount;
    }
    return totals;
  }
}
