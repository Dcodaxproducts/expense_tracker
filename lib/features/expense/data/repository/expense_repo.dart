abstract class ExpenseRepo {
  Future<bool> saveExpenses(String expensesJson);
  String? getExpenses();
}
