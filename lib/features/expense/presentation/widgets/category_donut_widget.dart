import 'dart:math';
import 'package:expense_tracker/imports.dart';
import 'package:expense_tracker/features/expense/data/model/expense_category.dart';

class CategoryDonutWidget extends StatelessWidget {
  final Map<ExpenseCategory, double> categoryTotals;
  final double totalExpenses;

  const CategoryDonutWidget({
    super.key,
    required this.categoryTotals,
    required this.totalExpenses,
  });

  @override
  Widget build(BuildContext context) {
    if (categoryTotals.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.sp),
          child: Text('No data', style: context.font14.copyWith(color: Theme.of(context).hintColor)),
        ),
      );
    }

    final entries = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppRadius.circular16,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.06),
            blurRadius: 10.sp,
            offset: Offset(0, 4.sp),
          ),
        ],
      ),
      child: Column(
        children: [
          // Donut chart
          SizedBox(
            width: 160.sp,
            height: 160.sp,
            child: CustomPaint(
              painter: _DonutPainter(
                entries: entries,
                total: totalExpenses,
              ),
              child: Center(
                child: Container(
                  width: 12.sp,
                  height: 12.sp,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).hintColor.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.sp),

          // Legend
          Wrap(
            spacing: 20.sp,
            runSpacing: 8.sp,
            alignment: WrapAlignment.center,
            children: entries.map((entry) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10.sp,
                    height: 10.sp,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: entry.key.color,
                    ),
                  ),
                  SizedBox(width: 6.sp),
                  Text(
                    entry.key.displayName,
                    style: context.font12.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<MapEntry<ExpenseCategory, double>> entries;
  final double total;

  _DonutPainter({required this.entries, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    const strokeWidth = 22.0;

    double startAngle = -pi / 2; // Start from top

    for (final entry in entries) {
      final sweepAngle = (entry.value / total) * 2 * pi;
      final paint = Paint()
        ..color = entry.key.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle - 0.02, // small gap between segments
        false,
        paint,
      );

      // Percentage label
      final midAngle = startAngle + sweepAngle / 2;
      final percent = (entry.value / total * 100).round();
      if (percent >= 8) {
        // Only show label if segment is big enough
        final labelRadius = radius + 14;
        final labelX = center.dx + labelRadius * cos(midAngle);
        final labelY = center.dy + labelRadius * sin(midAngle);

        final textPainter = TextPainter(
          text: TextSpan(
            text: '$percent%',
            style: TextStyle(
              color: entry.key.color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(labelX - textPainter.width / 2, labelY - textPainter.height / 2),
        );
      }

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) => true;
}
