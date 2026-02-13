import 'package:expense_tracker/imports.dart';
import 'package:expense_tracker/features/account/data/model/account_model.dart';
import 'package:intl/intl.dart';

class AccountCard extends StatelessWidget {
  final AccountModel account;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const AccountCard({
    super.key,
    required this.account,
    required this.onTap,
    required this.onDelete,
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
              color: Theme.of(context).shadowColor.withValues(alpha: 0.3),
              blurRadius: 4.sp,
              offset: Offset(0, 2.sp),
            ),
          ],
        ),
        child: Row(
          children: [
            // Account type icon
            Container(
              width: 44.sp,
              height: 44.sp,
              decoration: BoxDecoration(
                color: account.type.color.withValues(alpha: 0.15),
                borderRadius: AppRadius.circular8,
              ),
              child: Icon(account.type.icon, color: account.type.color, size: 22.sp),
            ),
            SizedBox(width: 12.sp),

            // Name + type
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.name,
                    style: context.font14.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.sp),
                  Text(
                    account.type.displayName,
                    style: context.font12.copyWith(color: Theme.of(context).hintColor),
                  ),
                ],
              ),
            ),

            // Balance + delete
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(account.balance),
                  style: context.font14.copyWith(
                    fontWeight: FontWeight.w700,
                    color: account.balance >= 0 ? incomeColor : expenseColor,
                  ),
                ),
                SizedBox(height: 2.sp),
                GestureDetector(
                  onTap: onDelete,
                  child: Icon(Iconsax.trash, size: 16.sp, color: Theme.of(context).hintColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
