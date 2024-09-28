import 'package:flutter/material.dart';
import 'package:google_calendar/core/extension/date_extension.dart';

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
              Text(
                '$monthRange',
              ),
              ...List.generate(
                weeklyRanges.length,
                (index) {
                  final weeklyRange = weeklyRanges[index];
                  return Text('$weeklyRange');
                },
              ),
              const SizedBox(height: 20.0),
            ],
          );
        },
      ),
    );
  }
}
