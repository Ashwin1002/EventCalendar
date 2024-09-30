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
}
