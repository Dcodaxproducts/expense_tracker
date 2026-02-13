import 'package:expense_tracker/imports.dart';
import 'package:expense_tracker/features/expense/presentation/controller/expense_controller.dart';
import 'package:intl/intl.dart';

class WeekCalendarWidget extends StatelessWidget {
  const WeekCalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExpenseController>(
      builder: (controller) {
        final month = controller.selectedMonth;
        final selected = controller.selectedDate;
        final weekDates = _getWeekDates(selected);

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 14.sp),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: AppRadius.circular16,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha: 0.08),
                blurRadius: 12.sp,
                offset: Offset(0, 4.sp),
              ),
            ],
          ),
          child: Column(
            children: [
              // Month navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _navButton(context, Iconsax.arrow_left_2, controller.previousMonth),
                  Text(
                    DateFormat('MMMM - yyyy').format(month),
                    style: context.font14.copyWith(fontWeight: FontWeight.w600),
                  ),
                  _navButton(context, Iconsax.arrow_right_3, controller.nextMonth),
                ],
              ),
              SizedBox(height: 14.sp),

              // Day labels
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su']
                    .map((d) => SizedBox(
                          width: 36.sp,
                          child: Center(
                            child: Text(
                              d,
                              style: context.font12.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(height: 8.sp),

              // Date numbers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: weekDates.map((date) {
                  final isSelected = date.day == selected.day &&
                      date.month == selected.month &&
                      date.year == selected.year;
                  final isCurrentMonth = date.month == month.month;

                  return GestureDetector(
                    onTap: () => controller.selectDate(date),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 36.sp,
                      height: 36.sp,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? primaryColor : transparent,
                      ),
                      child: Center(
                        child: Text(
                          '${date.day}',
                          style: context.font14.copyWith(
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : isCurrentMonth
                                    ? Theme.of(context).textTheme.bodyMedium?.color
                                    : primaryColor.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _navButton(BuildContext context, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.sp,
        height: 32.sp,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).dividerColor, width: 1.sp),
        ),
        child: Icon(icon, size: 14.sp, color: Theme.of(context).textTheme.bodyMedium?.color),
      ),
    );
  }

  List<DateTime> _getWeekDates(DateTime date) {
    // Get Monday of the week
    final monday = date.subtract(Duration(days: date.weekday - 1));
    return List.generate(7, (i) => monday.add(Duration(days: i)));
  }
}
