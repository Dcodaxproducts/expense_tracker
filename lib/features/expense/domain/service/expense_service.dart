import 'package:expense_tracker/features/expense/data/model/expense_category.dart';
import 'package:expense_tracker/features/expense/data/model/expense_model.dart';

abstract class ExpenseService {
  List<ExpenseModel> getExpenses();
  Future<bool> addExpense(String title, double amount, ExpenseCategory category, DateTime date, String? note);
  Future<bool> updateExpense(ExpenseModel expense);
  Future<bool> deleteExpense(String id);
  double getTotalExpenses(List<ExpenseModel> expenses);
  Map<ExpenseCategory, double> getCategoryTotals(List<ExpenseModel> expenses);
}
