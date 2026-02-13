import 'package:expense_tracker/imports.dart';
import 'package:expense_tracker/features/expense/data/model/expense_category.dart';

class CategorySummaryChip extends StatelessWidget {
  final ExpenseCategory category;
  final double amount;

  const CategorySummaryChip({
    super.key,
    required this.category,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 6.sp),
      decoration: BoxDecoration(
        color: category.color.withValues(alpha: 0.1),
        borderRadius: AppRadius.circular8,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(category.icon, size: 14.sp, color: category.color),
          SizedBox(width: 4.sp),
          Text(
            '\$${amount.toStringAsFixed(0)}',
            style: context.font12.copyWith(
              fontWeight: FontWeight.w600,
              color: category.color,
            ),
          ),
        ],
      ),
    );
  }
}
