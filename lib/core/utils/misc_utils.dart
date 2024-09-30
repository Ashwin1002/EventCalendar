import 'package:google_calendar/core/core.dart';

class MiscUtils {
  static String generateMonthImages(int month) {
    return switch (month) {
      1 => AssetList.campingNight,
      2 => AssetList.grassLand,
      3 => AssetList.lakeBonefire,
      4 => AssetList.summerView,
      5 => AssetList.summerBeach,
      6 => AssetList.rainyBeach,
      7 => AssetList.festival,
      8 => AssetList.farmField,
      9 => AssetList.autumnLake,
      10 => AssetList.autumnMountain,
      11 => AssetList.winterCity,
      _ => AssetList.winteLake,
    };
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
}
