import 'package:expense_tracker/imports.dart';
import 'package:expense_tracker/features/expense/presentation/controller/expense_controller.dart';
import 'package:expense_tracker/features/expense/presentation/view/add_expense_screen.dart';
import 'package:expense_tracker/features/expense/presentation/widgets/week_calendar_widget.dart';
import 'package:expense_tracker/features/expense/presentation/widgets/budget_circle_widget.dart';
import 'package:expense_tracker/features/expense/presentation/widgets/category_donut_widget.dart';
import 'package:expense_tracker/features/expense/presentation/widgets/transaction_tile.dart';
import 'package:expense_tracker/features/account/presentation/view/accounts_screen.dart';

class ExpenseDashboardScreen extends StatefulWidget {
  const ExpenseDashboardScreen({super.key});

  @override
  State<ExpenseDashboardScreen> createState() => _ExpenseDashboardScreenState();
}

class _ExpenseDashboardScreenState extends State<ExpenseDashboardScreen> {
  final ValueNotifier<int> _tabIndex = ValueNotifier(0);

  @override
  void dispose() {
    _tabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExpenseController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () => launchScreen(const AccountsScreen()),
              child: Padding(
                padding: EdgeInsets.all(10.sp),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Theme.of(context).dividerColor, width: 1.5.sp),
                  ),
                  child: Icon(Iconsax.arrow_left_2, size: 16.sp),
                ),
              ),
            ),
            title: Text(
              'Total Expenses',
              style: context.font18.copyWith(fontWeight: FontWeight.w700),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16.sp),
                  children: [
                    SizedBox(height: 8.sp),

                    // Week calendar
                    const WeekCalendarWidget(),
                    SizedBox(height: 24.sp),

                    // Budget circle
                    BudgetCircleWidget(
                      amount: controller.totalExpenses,
                      percent: controller.budgetPercent,
                    ),
                    SizedBox(height: 24.sp),

                    // Divider
                    Divider(color: Theme.of(context).dividerColor, height: 1.sp),
                    SizedBox(height: 8.sp),

                    // Tab bar: Spends | Categories
                    ValueListenableBuilder<int>(
                      valueListenable: _tabIndex,
                      builder: (context, selectedTab, _) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                _buildTab(context, 'Spends', 0, selectedTab),
                                _buildTab(context, 'Categories', 1, selectedTab),
                              ],
                            ),
                            SizedBox(height: 16.sp),

                            // Tab content
                            if (selectedTab == 0) _buildSpendsTab(context, controller),
                            if (selectedTab == 1) _buildCategoriesTab(context, controller),
                          ],
                        );
                      },
                    ),

                    SizedBox(height: 80.sp), // Space for bottom nav
                  ],
                ),
          bottomNavigationBar: _buildBottomNav(context),
        );
      },
    );
  }

  Widget _buildTab(BuildContext context, String text, int index, int selectedTab) {
    final isSelected = index == selectedTab;
    return Expanded(
      child: GestureDetector(
        onTap: () => _tabIndex.value = index,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.sp),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: context.font14.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? Theme.of(context).textTheme.bodyMedium?.color
                      : Theme.of(context).hintColor,
                ),
              ),
            ),
            Container(
              height: 2.5.sp,
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : transparent,
                borderRadius: AppRadius.circular4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpendsTab(BuildContext context, ExpenseController controller) {
    if (controller.expenses.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 40.sp),
        child: Center(
          child: Column(
            children: [
              Icon(Iconsax.wallet_3, size: 48.sp, color: Theme.of(context).hintColor),
              SizedBox(height: 12.sp),
              Text('No expenses this month', style: context.font14.copyWith(color: Theme.of(context).hintColor)),
            ],
          ),
        ),
      );
    }

    return Column(
      children: controller.expenses.map((expense) {
        return TransactionTile(
          expense: expense,
          onTap: () => launchScreen(AddExpenseScreen(expense: expense)),
        );
      }).toList(),
    );
  }

  Widget _buildCategoriesTab(BuildContext context, ExpenseController controller) {
    return CategoryDonutWidget(
      categoryTotals: controller.categoryTotals,
      totalExpenses: controller.totalExpenses,
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8.sp, bottom: MediaQuery.of(context).padding.bottom + 8.sp),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.08),
            blurRadius: 10.sp,
            offset: Offset(0, -2.sp),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(context, Iconsax.home_2, true),
          _navItem(context, Iconsax.task_square, false),
          // Center FAB
          GestureDetector(
            onTap: () => launchScreen(const AddExpenseScreen()),
            child: Container(
              width: 52.sp,
              height: 52.sp,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.4),
                    blurRadius: 12.sp,
                    offset: Offset(0, 4.sp),
                  ),
                ],
              ),
              child: Icon(Iconsax.add, color: Colors.white, size: 26.sp),
            ),
          ),
          _navItem(context, Iconsax.notification, false),
          GestureDetector(
            onTap: () => launchScreen(const AccountsScreen()),
            child: Icon(Iconsax.setting_2, size: 24.sp, color: Theme.of(context).hintColor),
          ),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, bool active) {
    return Icon(
      icon,
      size: 24.sp,
      color: active ? Theme.of(context).textTheme.bodyMedium?.color : Theme.of(context).hintColor,
    );
  }
}
