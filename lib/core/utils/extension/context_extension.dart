import 'package:flutter/material.dart';
import 'package:google_calendar/core/theme/theme_extension.dart';

// Threshold for distinguishing between mobile and tablet
const double _tabletThreshold = 600.0;

extension ContextExtension on BuildContext {
  /// get colors
  CustomThemeExtension get theme {
    return Theme.of(this).extension<CustomThemeExtension>()!;
  }

  /// get text themes
  TextTheme get textTheme => Theme.of(this).textTheme;

  // get available max Width using mediaquery
  double get maxWidth => MediaQuery.sizeOf(this).width;

  // get available max height using mediaquery
  double get maxHeight => MediaQuery.sizeOf(this).height;

  // check if the device is tablet
  bool get isTablet => maxWidth >= _tabletThreshold;

  // check if the device is mobile
  bool get isMobile => !isTablet;
}
