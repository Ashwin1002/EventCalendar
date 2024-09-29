import 'package:flutter/material.dart';
import 'package:google_calendar/core/core.dart';
import 'package:google_calendar/src/calendar/widgets/widgets.dart';

int? previousIndex;

DateTime firstDay = DateTime(2020);
DateTime lastDay = DateTime(DateTime.now().year + 5);

class CalendarListScreen extends StatelessWidget {
  const CalendarListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dateRange = DateTimeRange(start: firstDay, end: lastDay);
    return Scaffold(
      body: ListView.builder(
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
                  return ScheduleWeeklyDataView(weeklyRange: weeklyRange);
                },
              ),
              15.0.verticalSpace,
            ],
          );
        },
      ),
    );
  }
}
