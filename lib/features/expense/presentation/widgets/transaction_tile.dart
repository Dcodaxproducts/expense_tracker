import 'package:expense_tracker/imports.dart';
import 'package:expense_tracker/features/expense/data/model/expense_model.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatelessWidget {
  final ExpenseModel expense;
  final VoidCallback onTap;

  const TransactionTile({
    super.key,
    required this.expense,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sign = expense.isIncome ? '+' : '-';
    final amountText = '$sign \$${expense.amount.toStringAsFixed(0)}';
    final vatText = expense.vatPercent > 0 ? ' + Vat ${expense.vatPercent}%' : '';

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.sp),
        child: Row(
          children: [
            // Category icon
            Container(
              width: 44.sp,
              height: 44.sp,
              decoration: BoxDecoration(
                color: expense.category.color.withValues(alpha: 0.12),
                borderRadius: AppRadius.circular12,
              ),
              child: Icon(expense.category.icon, color: expense.category.color, size: 20.sp),
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
                    DateFormat('dd MMM yyyy').format(expense.date),
                    style: context.font12.copyWith(color: Theme.of(context).hintColor),
                  ),
                ],
              ),
            ),

            // Amount + payment method
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$amountText$vatText',
                  style: context.font12.copyWith(
                    fontWeight: FontWeight.w600,
                    color: expense.isIncome ? incomeColor : Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                SizedBox(height: 2.sp),
                Text(
                  expense.paymentMethod,
                  style: context.font12.copyWith(color: Theme.of(context).hintColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
