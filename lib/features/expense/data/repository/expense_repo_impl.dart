import 'package:shared_preferences/shared_preferences.dart';
import 'expense_repo.dart';

class ExpenseRepoImpl implements ExpenseRepo {
  final SharedPreferences prefs;
  ExpenseRepoImpl({required this.prefs});

  static const String _expensesKey = 'expenses_data';

  @override
  Future<bool> saveExpenses(String expensesJson) async {
    return await prefs.setString(_expensesKey, expensesJson);
  }

  @override
  String? getExpenses() => prefs.getString(_expensesKey);
}
