import 'package:flutter/material.dart';
import 'package:google_calendar/core/core.dart';
import 'package:intl/intl.dart';

class ScheduleWeeklyDataView extends StatelessWidget {
  const ScheduleWeeklyDataView({
    super.key,
    required this.weeklyRange,
    this.hasData = false,
  });

  final DateTimeRange weeklyRange;
  final bool hasData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 14.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              60.horizontalSpace,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    '${DateFormat('MMMM d').format(weeklyRange.start).toUpperCase()}'
                    ' - '
                    '${DateFormat(weeklyRange.isSameMonth ? 'd' : 'MMMM d').format(weeklyRange.end).toUpperCase()}',
                    style: const TextStyle(
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (hasData)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 60.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MON',
                        style: context.textTheme.labelSmall?.copyWith(
                          color: context.theme.tertiary,
                        ),
                      ),
                      Text(
                        '30',
                        textAlign: TextAlign.center,
                        style: context.textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
                10.0.horizontalSpace,
                Expanded(
                  child: Container(),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
