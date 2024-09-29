import 'package:flutter/material.dart';

extension DateExtension on DateTime {
  /// get first day of month from current date
  DateTime get firstDayOfMonth => DateTime.utc(year, month, 1);

  /// get last day of month from current date
  DateTime get lastDayOfMonth {
    final date = month < 12
        ? DateTime.utc(year, month + 1, 1)
        : DateTime.utc(year + 1, 1, 1);
    return date.subtract(const Duration(days: 1));
  }

  // get the last day of upcoming month from current date
  DateTime get lastDayOfNextMonth =>
      DateTime(year, month + 2, 1).subtract(const Duration(days: 1));

  bool get isCurrentYear => year == DateTime.now().toUtc().year;
}

extension DateTimeRangeExtension on DateTimeRange {
  /// get the no. of months in between the current date range
  int get totalMonthsCount {
    int yearDiff = end.year - start.year;
    int monthDiff = end.month - start.month;
    // Total months difference (including full years and partial months)
    int totalMonths = (yearDiff * 12) + monthDiff;
    // Return total months
    return totalMonths;
  }

  /// get the list of month range in between the current date range
  List<DateTimeRange> get monthRanges {
    List<DateTimeRange> monthRanges = [];
    DateTime current = DateTime(start.year, start.month);

    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      DateTime monthStart = DateTime(current.year, current.month, 1);
      DateTime monthEnd = DateTime(current.year, current.month + 1, 1)
          .subtract(const Duration(days: 1));

      // If the month end exceeds the endDate, adjust the monthEnd
      if (monthEnd.isAfter(end)) {
        monthEnd = end;
      }

      monthRanges.add(DateTimeRange(start: monthStart, end: monthEnd));

      // Move to the next month
      current = DateTime(current.year, current.month + 1);
    }

    return monthRanges;
  }

  bool get isSameMonth => start.month == end.month;
}

List<DateTimeRange> getWeeklyDatesRange(
    DateTime monthStart, DateTime monthEnd) {
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
