import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_calendar/core/core.dart';
import 'package:google_calendar/src/calendar/widgets/widgets.dart';

int? previousIndex;

DateTime firstDay = DateTime(2020);
DateTime lastDay = DateTime(DateTime.now().year + 5);

class CalendarListScreen extends StatefulWidget {
  const CalendarListScreen({super.key});

  @override
  State<CalendarListScreen> createState() => _CalendarListScreenState();
}

class _CalendarListScreenState extends State<CalendarListScreen> {
  int value = 0;
  @override
  Widget build(BuildContext context) {
    final dateRange = DateTimeRange(start: firstDay, end: lastDay);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MiscUtils.updateDateByMonth(
            DateTime.now().toUtc(),
            value++,
          );
          setState(() {});
        },
        heroTag: 'add-fab',
        key: const ValueKey('fab_normal'),
        child: const Icon(
          Icons.add,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ColoredBox(
              color: Colors.red,
              child: DropdownMonth(
                value: value.toDouble(),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: dateRange.totalMonthsCount,
                itemBuilder: (context, index) {
                  final monthRange = dateRange.monthRanges[index];

                  final weeklyRanges = getWeeklyDatesRange(
                    monthRange.start,
                    monthRange.end,
                  );
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MonthlyImageView(monthRange: monthRange),
                      5.0.verticalSpace,
                      ...List.generate(
                        weeklyRanges.length,
                        (index) {
                          final weeklyRange = weeklyRanges[index];
                          return ScheduleWeeklyDataView(
                              weeklyRange: weeklyRange);
                        },
                      ),
                      15.0.verticalSpace,
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DropdownMonth extends StatelessWidget {
  const DropdownMonth({
    super.key,
    this.visible = true,
    required this.value,
  });
  final bool visible;
  final double value;

  @override
  Widget build(BuildContext context) {
    // Merge the text style with the default style, and request tabular figures
    // for consistent width of digits (if supported by the font).
    final style = DefaultTextStyle.of(context)
        .style
        .merge(const TextStyle(fontFeatures: [FontFeature.tabularFigures()]));
    // Layout number "0" (probably the widest digit) to see its size
    final prototypeDigit = TextPainter(
      text: TextSpan(text: 'September', style: style),
      textDirection: TextDirection.ltr,
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();

    final size = prototypeDigit.size;

    log('size => $size');
    const padding = EdgeInsets.zero;
    return TweenAnimationBuilder(
      duration: kThemeAnimationDuration,
      tween: Tween(end: value),
      builder: (_, double value, __) {
        final whole = value ~/ 1;
        final decimal = value - whole;
        final w = size.width + padding.horizontal;
        final h = size.height + padding.vertical;

        log('whole => $whole');

        return Padding(
          key: ValueKey(value),
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: visible ? w : 0,
            height: h,
            child: Stack(
              children: <Widget>[
                _buildSingleDigit(
                  digit: whole,
                  offset: h * decimal,
                  opacity: 1 - decimal,
                ),
                _buildSingleDigit(
                  digit: whole,
                  offset: h * decimal - h,
                  opacity: decimal,
                ),
              ],
            ),
          ),
        );

        // return Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Row(
        //     children: [
        //       Text(
        //         'July',
        //         style: context.theme.textTheme.titleMedium?.copyWith(
        //           fontWeight: FontWeight.w400,
        //           letterSpacing: -.4,
        //         ),
        //       ),
        //       const Icon(
        //         Icons.arrow_drop_down,
        //         size: 20.0,
        //       )
        //     ],
        //   ),
        // );
      },
    );
  }

  Widget _buildSingleDigit({
    required int digit,
    required double offset,
    required double opacity,
  }) {
    final currentDate = DateTime.now().toUtc();
    final monthDate = MiscUtils.updateDateByMonth(currentDate, digit);
    final monthName =
        monthDate.format(monthDate.isCurrentYear ? 'MMMM' : 'MMM y');

    log('month name => $monthName');
    // Try to avoid using the `Opacity` widget when possible, for performance.
    final Widget child;
    if (Colors.black.opacity == 1) {
      // If the text style does not involve transparency, we can modify
      // the text color directly.
      child = Text(
        monthName,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black.withOpacity(opacity.clamp(0, 1))),
      );
    } else {
      // Otherwise, we have to use the `Opacity` widget (less performant).
      child = Opacity(
        opacity: opacity.clamp(0, 1),
        child: Text(
          monthName,
          textAlign: TextAlign.center,
        ),
      );
    }
    return Positioned(
      left: 0,
      right: 0,
      bottom: offset + EdgeInsets.zero.bottom,
      child: child,
    );
  }
}

enum Months {
  jan(1),
  feb(2),
  mar(3),
  apr(4),
  may(5),
  jun(6),
  july(7),
  august(8),
  sept(9),
  oct(10);

  const Months(this.value);

  final int value;

  factory Months.fromNum(int number) {
    return switch (number) {
      1 => Months.jan,
      2 => Months.feb,
      3 => Months.mar,
      4 => Months.apr,
      5 => Months.may,
      6 => Months.jun,
      7 => Months.july,
      8 => Months.august,
      9 => Months.oct,
      _ => Months.oct,
    };
  }
}
