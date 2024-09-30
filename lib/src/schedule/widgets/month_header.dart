import 'package:flutter/material.dart';
import 'package:google_calendar/core/core.dart';

class MonthHeader extends StatelessWidget {
  const MonthHeader({
    super.key,
    this.visible = true,
    required this.value,
  });
  final bool visible;
  final double value;

  static const _animationDuration = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    const Size size = Size(110, 40.0);
    return TweenAnimationBuilder(
      duration: _animationDuration,
      tween: Tween(end: value),
      builder: (_, double value, __) {
        final monthRounded = value ~/ 1;
        final monthWithFractionalValue = value - monthRounded;
        final w = size.width;
        final h = size.height;

        return SizedBox(
          // key: ValueKey<double>(value),
          width: w,
          height: h,
          child: Stack(
            children: <Widget>[
              _buildMonthName(
                value: monthRounded,
                offset: h * monthWithFractionalValue,
                opacity: 1 - monthWithFractionalValue,
              ),
              _buildMonthName(
                value: monthRounded,
                // offset: h * monthWithFractionalValue - h,
                offset: h * monthWithFractionalValue - h - 5,
                opacity: monthWithFractionalValue,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMonthName({
    required int value,
    required double offset,
    required double opacity,
  }) {
    final currentDate = DateTime.now().toUtc();
    final monthDate = DateTimeUtils.updateDateByMonth(currentDate, value);
    final monthName =
        monthDate.format(monthDate.isCurrentYear ? 'MMMM' : 'MMM y');

    // Try to avoid using the `Opacity` widget when possible, for performance.
    final Widget child;
    if (Colors.black.opacity == 1) {
      // If the text style does not involve transparency, we can modify
      // the text color directly.
      child = Text(
        monthName,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black.withOpacity(
            opacity.clamp(0, 1),
          ),
        ),
      );
    } else {
      // Otherwise, we have to use the `Opacity` widget (less performant).
      child = AnimatedOpacity(
        opacity: opacity.clamp(0, 1),
        duration: const Duration(milliseconds: 150),
        child: Text(
          monthName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
      );
    }
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      bottom: offset + EdgeInsets.zero.bottom,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          2.0.horizontalSpace,
          const Icon(
            Icons.arrow_drop_down,
            size: 24.0,
          ),
        ],
      ),
    );
  }
}
