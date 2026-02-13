import 'package:expense_tracker/imports.dart';
import 'package:expense_tracker/features/expense/data/model/expense_model.dart';
import 'package:expense_tracker/features/expense/data/model/expense_category.dart';
import 'package:expense_tracker/features/expense/domain/service/expense_service.dart';

class ExpenseController extends GetxController implements GetxService {
  final ExpenseService service;
  ExpenseController({required this.service});

  static ExpenseController get find => Get.find<ExpenseController>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    update();
  }

  List<ExpenseModel> _expenses = [];
  List<ExpenseModel> get expenses => _expenses;

  double _totalExpenses = 0.0;
  double get totalExpenses => _totalExpenses;

  Map<ExpenseCategory, double> _categoryTotals = {};
  Map<ExpenseCategory, double> get categoryTotals => _categoryTotals;

  @override
  void onInit() {
    super.onInit();
    loadExpenses();
  }

  void loadExpenses() {
    try {
      isLoading = true;
      _expenses = service.getExpenses();
      _expenses.sort((a, b) => b.date.compareTo(a.date));
      _totalExpenses = service.getTotalExpenses(_expenses);
      _categoryTotals = service.getCategoryTotals(_expenses);
      isLoading = false;
    } catch (e) {
      showToast('Failed to load expenses: $e');
      isLoading = false;
    }
  }

  Future<void> addExpense(String title, double amount, ExpenseCategory category, DateTime date, String? note) async {
    try {
      isLoading = true;
      final success = await service.addExpense(title, amount, category, date, note);
      if (success) {
        loadExpenses();
        showToast('Expense added');
      }
    } catch (e) {
      showToast('Failed to add expense: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> updateExpense(ExpenseModel expense) async {
    try {
      isLoading = true;
      final success = await service.updateExpense(expense);
      if (success) {
        loadExpenses();
        showToast('Expense updated');
      }
    } catch (e) {
      showToast('Failed to update expense: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      isLoading = true;
      final success = await service.deleteExpense(id);
      if (success) {
        loadExpenses();
        showToast('Expense deleted');
      }
    } catch (e) {
      showToast('Failed to delete expense: $e');
    } finally {
      isLoading = false;
    }
  }
}
