import 'package:flutter/material.dart';
import 'package:google_calendar/core/core.dart';

class DateTimeUtils {
  /// Gets the List of weekly Date range. If the weekly range of the ending month is int
  /// starting days of next month, then next month week is shown to
  ///
  /// Params used `monthStart` and `monthEnd`
  static List<DateTimeRange> getWeeklyDatesRange(
    DateTime monthStart,
    DateTime monthEnd,
  ) {
    List<DateTimeRange> weekRanges = [];
    DateTime current = monthStart;

    while (current.isBefore(monthEnd) || current.isAtSameMomentAs(monthEnd)) {
      // Calculate the end of the week (7 days from current)
      DateTime weekEnd = current.add(const Duration(days: 6));

      // If the week end exceeds the month end, extend to the next month to complete the week
      if (weekEnd.isAfter(monthEnd)) {
        if (weekEnd.isAfter(monthStart.lastDayOfNextMonth)) {
          weekEnd = monthStart.lastDayOfNextMonth;
        }
      }

      // Add the current week range
      weekRanges.add(DateTimeRange(start: current, end: weekEnd));

      // Move to the next week (start of next week is the day after the current week end)
      current = weekEnd.add(const Duration(days: 1));
    }

    return weekRanges;
  }

  static DateTime updateDateByMonth(DateTime currentDate, int monthOffset) {
    // Calculate the new year and month by adding the offset
    int newYear =
        currentDate.year + ((currentDate.month + monthOffset - 1) ~/ 12);
    int newMonth = (currentDate.month + monthOffset - 1) % 12 + 1;

    // Handle cases where day may not exist in the new month (e.g., February 30th)
    int lastDayOfNewMonth = DateTime(newYear, newMonth + 1, 0).day;
    int newDay = currentDate.day <= lastDayOfNewMonth
        ? currentDate.day
        : lastDayOfNewMonth;

    // Return the updated date
    return DateTime(newYear, newMonth, newDay);
  }

  /// gets the first day of the month
  static DateTime firstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// gets last day of the month
  static DateTime lastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 1)
        .subtract(const Duration(days: 1));
  }
}
