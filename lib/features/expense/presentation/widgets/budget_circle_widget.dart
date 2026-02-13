import 'dart:math';
import 'package:expense_tracker/imports.dart';
import 'package:intl/intl.dart';

class BudgetCircleWidget extends StatelessWidget {
  final double amount;
  final double percent;

  const BudgetCircleWidget({
    super.key,
    required this.amount,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 180.sp,
          height: 180.sp,
          child: CustomPaint(
            painter: _GaugePainter(
              percent: percent,
              trackColor: Theme.of(context).dividerColor,
              progressColor: primaryColor,
            ),
            child: Center(
              child: Container(
                width: 120.sp,
                height: 120.sp,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.3),
                      blurRadius: 20.sp,
                      offset: Offset(0, 6.sp),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    NumberFormat.currency(symbol: '\$', decimalDigits: 0).format(amount),
                    style: context.font22.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 12.sp),
        Text(
          'You have Spend total',
          style: context.font14.copyWith(
            color: Theme.of(context).textTheme.bodyMedium?.color,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2.sp),
        Text(
          '${(percent * 100).toInt()}% of you budget',
          style: context.font12.copyWith(
            color: Theme.of(context).hintColor,
          ),
        ),
      ],
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double percent;
  final Color trackColor;
  final Color progressColor;

  _GaugePainter({
    required this.percent,
    required this.trackColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const startAngle = 0.75 * pi; // 135 degrees
    const sweepAngle = 1.5 * pi; // 270 degrees arc

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      trackPaint,
    );

    // Progress
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * percent.clamp(0.0, 1.0),
      false,
      progressPaint,
    );

    // End dot (gray circle at bottom)
    const dotAngle = startAngle + sweepAngle;
    final dotX = center.dx + radius * cos(dotAngle);
    final dotY = center.dy + radius * sin(dotAngle);
    final dotPaint = Paint()..color = trackColor;
    canvas.drawCircle(Offset(dotX, dotY), 6, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter old) =>
      old.percent != percent || old.trackColor != trackColor;
}
