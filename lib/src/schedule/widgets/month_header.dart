import 'package:flutter/material.dart';
import 'package:google_calendar/core/core.dart';

/// Builds the month header of the calendar dropdown.
///
/// Requires params `value` and `range`
///
/// [value] : the current index of the data range
/// [range] : the start date and end date range of the calendar
class MonthHeader extends StatelessWidget {
  const MonthHeader({
    super.key,
    this.visible = true,
    required this.value,
    required this.range,
    this.icon,
  });
  final bool visible;
  final double value;
  final DateTimeRange range;
  final Widget? icon;

  static const _animationDuration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    const Size size = Size(110, 40.0);
    return TweenAnimationBuilder(
      duration: _animationDuration,
      tween: Tween(end: value),
      curve: Curves.ease,
      builder: (_, double value, __) {
        final monthRounded = value ~/ 1;
        final monthWithFractionalValue = value - monthRounded;
        final w = size.width;
        final h = size.height;

        return SizedBox(
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
                value: monthRounded + 1,
                // offset: h * monthWithFractionalValue - h,
                offset: h * monthWithFractionalValue - h,
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
    // final currentDate = DateTime.now().toUtc();
    final monthDate = range.monthRanges[value].start;
    final monthName =
        monthDate.format(monthDate.isCurrentYear ? 'MMMM' : 'MMM y');

    // Try to avoid using the `Opacity` widget when possible, for performance.
    final Widget child;
    if (opacity == 1) {
      // If the text style does not involve transparency, we can modify
      // the text color directly.
      child = Row(
        children: [
          Text(
            monthName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black.withOpacity(
                opacity.clamp(0, 1),
              ),
            ),
          ),
          icon ??
              const Icon(
                Icons.arrow_drop_down,
                size: 24.0,
              ),
        ],
      );
    } else {
      // log('in animating condition');
      // Otherwise, we have to use the `Opacity` widget (less performant).
      child = Opacity(
        opacity: opacity.clamp(0, 1),
        child: Row(
          children: [
            Text(
              monthName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            icon ??
                const Icon(
                  Icons.arrow_drop_down,
                  size: 24.0,
                ),
          ],
        ),
      );
    }
    return Positioned(
      left: 0,
      // right: 0,
      top: 0,
      bottom: offset + EdgeInsets.zero.bottom,
      child: child,
    );
  }
}
