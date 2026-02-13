import 'package:expense_tracker/features/expense/data/model/expense_category.dart';
import 'package:expense_tracker/features/expense/data/model/expense_model.dart';

abstract class ExpenseService {
  List<ExpenseModel> getExpenses();
  Future<bool> addExpense({
    required String title,
    required double amount,
    required ExpenseCategory category,
    required DateTime date,
    String? note,
    double vatPercent,
    String paymentMethod,
    bool isIncome,
  });
  Future<bool> updateExpense(ExpenseModel expense);
  Future<bool> deleteExpense(String id);
  double getTotalExpenses(List<ExpenseModel> expenses);
  Map<ExpenseCategory, double> getCategoryTotals(List<ExpenseModel> expenses);
}
