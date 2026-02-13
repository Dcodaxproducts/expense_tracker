import 'package:expense_tracker/imports.dart';
import 'package:expense_tracker/features/expense/data/model/expense_model.dart';
import 'package:intl/intl.dart';

class ExpenseCard extends StatelessWidget {
  final ExpenseModel expense;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const ExpenseCard({
    super.key,
    required this.expense,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.sp),
        padding: EdgeInsets.all(14.sp),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: AppRadius.circular12,
          boxShadow: [
            BoxShadow(
              color: shadowColorLight.withValues(alpha: 0.3),
              blurRadius: 4.sp,
              offset: Offset(0, 2.sp),
            ),
          ],
        ),
        child: Row(
          children: [
            // Category icon
            Container(
              width: 44.sp,
              height: 44.sp,
              decoration: BoxDecoration(
                color: expense.category.color.withValues(alpha: 0.15),
                borderRadius: AppRadius.circular8,
              ),
              child: Icon(expense.category.icon, color: expense.category.color, size: 22.sp),
            ),
            SizedBox(width: 12.sp),

            // Title + date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.title,
                    style: context.font14.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.sp),
                  Text(
                    '${expense.category.displayName} • ${DateFormat('MMM dd').format(expense.date)}',
                    style: context.font12.copyWith(color: hintColorLight),
                  ),
                ],
              ),
            ),

            // Amount + delete
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '-\$${expense.amount.toStringAsFixed(2)}',
                  style: context.font14.copyWith(
                    fontWeight: FontWeight.w700,
                    color: expenseColor,
                  ),
                ),
                SizedBox(height: 2.sp),
                GestureDetector(
                  onTap: onDelete,
                  child: Icon(Iconsax.trash, size: 16.sp, color: hintColorLight),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
