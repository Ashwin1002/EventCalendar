import 'package:flutter/material.dart';
import 'package:google_calendar/core/theme/theme_extension.dart';

extension ContextExtension on BuildContext {
  /// get colors
  CustomThemeExtension get theme {
    return Theme.of(this).extension<CustomThemeExtension>()!;
  }

  /// get text themes
  TextTheme get textTheme => Theme.of(this).textTheme;
}
