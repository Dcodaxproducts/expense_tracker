import 'package:expense_tracker/imports.dart';
import 'package:expense_tracker/core/widgets/confirmation_dialog.dart';
import 'package:expense_tracker/features/expense/data/model/expense_model.dart';
import 'package:expense_tracker/features/expense/presentation/controller/expense_controller.dart';
import 'package:expense_tracker/features/expense/presentation/view/add_expense_screen.dart';
import 'package:expense_tracker/features/expense/presentation/widgets/expense_card.dart';
import 'package:expense_tracker/features/expense/presentation/widgets/category_summary_chip.dart';
import 'package:intl/intl.dart';

class ExpenseDashboardScreen extends StatefulWidget {
  const ExpenseDashboardScreen({super.key});

  @override
  State<ExpenseDashboardScreen> createState() => _ExpenseDashboardScreenState();
}

class _ExpenseDashboardScreenState extends State<ExpenseDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExpenseController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Expense Tracker',
              style: context.font20.copyWith(fontWeight: FontWeight.w700),
            ),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: primaryColor,
            onPressed: () => launchScreen(const AddExpenseScreen()),
            child: Icon(Iconsax.add, color: Colors.white, size: 24.sp),
          ),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: AppPadding.padding16,
                  children: [
                    // Total card
                    _buildTotalCard(context, controller),
                    SizedBox(height: 16.sp),

                    // Category breakdown
                    if (controller.categoryTotals.isNotEmpty) ...[
                      Text(
                        'By Category',
                        style: context.font16.copyWith(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 8.sp),
                      Wrap(
                        spacing: 8.sp,
                        runSpacing: 8.sp,
                        children: controller.categoryTotals.entries.map((entry) {
                          return CategorySummaryChip(
                            category: entry.key,
                            amount: entry.value,
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 24.sp),
                    ],

                    // Recent expenses
                    Text(
                      'Recent Expenses',
                      style: context.font16.copyWith(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 8.sp),

                    if (controller.expenses.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 60.sp),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Iconsax.wallet_3, size: 64.sp, color: hintColorLight),
                              SizedBox(height: 16.sp),
                              Text(
                                'No expenses yet',
                                style: context.font16.copyWith(color: hintColorLight),
                              ),
                              SizedBox(height: 4.sp),
                              Text(
                                'Tap + to add your first expense',
                                style: context.font12.copyWith(color: hintColorLight),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...controller.expenses.map((expense) {
                        return ExpenseCard(
                          expense: expense,
                          onDelete: () => _confirmDelete(context, controller, expense),
                          onTap: () => launchScreen(AddExpenseScreen(expense: expense)),
                        );
                      }),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildTotalCard(BuildContext context, ExpenseController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        gradient: primaryGradient,
        borderRadius: AppRadius.circular16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Expenses',
            style: context.font14.copyWith(color: Colors.white70, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8.sp),
          Text(
            NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(controller.totalExpenses),
            style: context.font28.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 4.sp),
          Text(
            '${controller.expenses.length} transaction${controller.expenses.length == 1 ? '' : 's'}',
            style: context.font12.copyWith(color: Colors.white60),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, ExpenseController controller, ExpenseModel expense) {
    showConfirmationDialog(
      title: 'Delete Expense',
      subtitle: 'Are you sure you want to delete "${expense.title}"?',
      actionText: 'Delete',
      onAccept: () {
        controller.deleteExpense(expense.id);
        pop();
      },
    );
  }
}
