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

  List<ExpenseModel> _allExpenses = [];
  List<ExpenseModel> _expenses = [];
  List<ExpenseModel> get expenses => _expenses;

  double _totalExpenses = 0.0;
  double get totalExpenses => _totalExpenses;

  Map<ExpenseCategory, double> _categoryTotals = {};
  Map<ExpenseCategory, double> get categoryTotals => _categoryTotals;

  DateTime _selectedMonth = DateTime.now();
  DateTime get selectedMonth => _selectedMonth;

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  double _budgetPercent = 0.6;
  double get budgetPercent => _budgetPercent;

  @override
  void onInit() {
    super.onInit();
    loadExpenses();
  }

  void loadExpenses() {
    try {
      isLoading = true;
      _allExpenses = service.getExpenses();
      _allExpenses.sort((a, b) => b.date.compareTo(a.date));
      _filterByMonth();
      isLoading = false;
    } catch (e) {
      showToast('Failed to load expenses: $e');
      isLoading = false;
    }
  }

  void _filterByMonth() {
    _expenses = _allExpenses.where((e) {
      return e.date.year == _selectedMonth.year && e.date.month == _selectedMonth.month;
    }).toList();
    _totalExpenses = service.getTotalExpenses(_expenses);
    _categoryTotals = service.getCategoryTotals(_expenses);

    // Budget percent (placeholder — total / 2700 budget)
    _budgetPercent = _totalExpenses > 0 ? (_totalExpenses / 2700).clamp(0.0, 1.0) : 0.0;
  }

  void selectMonth(DateTime month) {
    _selectedMonth = month;
    _filterByMonth();
    update();
  }

  void nextMonth() {
    selectMonth(DateTime(_selectedMonth.year, _selectedMonth.month + 1));
  }

  void previousMonth() {
    selectMonth(DateTime(_selectedMonth.year, _selectedMonth.month - 1));
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    update();
  }

  Future<void> addExpense({
    required String title,
    required double amount,
    required ExpenseCategory category,
    required DateTime date,
    String? note,
    double vatPercent = 0.0,
    String paymentMethod = 'Cash',
    bool isIncome = false,
  }) async {
    try {
      isLoading = true;
      final success = await service.addExpense(
        title: title,
        amount: amount,
        category: category,
        date: date,
        note: note,
        vatPercent: vatPercent,
        paymentMethod: paymentMethod,
        isIncome: isIncome,
      );
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
