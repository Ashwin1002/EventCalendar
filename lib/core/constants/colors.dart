import 'package:flutter/material.dart';
import 'package:google_calendar/core/core.dart';

/// Light Colors pallete for theme ligh
class AppColorsLight {
  // main colors light
  static final primary = "#1266F1".toColor();
  static final secondary = "#575e71".toColor();
  static final tertiary = "#0b6780".toColor();
  static final error = "#ba1a1a".toColor();
  // on main colors light
  static final onPrimary = "#ffffff".toColor();
  static final onSecondary = "#ffffff".toColor();
  static final onTertiary = "#ffffff".toColor();
  static final onError = "#ffffff".toColor();

  // container colors light
  static final primaryContainer = "#d8e2ff".toColor();
  static final secondaryContainer = "#dbe2f9".toColor();
  static final tertiaryContainer = "#b9eaff".toColor();
  static final errorContainer = "#ffdad6".toColor();

  // on container colors light
  static final onPrimaryContainer = "#001a41".toColor();
  static final onSecondaryContainer = "#141b2c".toColor();
  static final onTertiaryContainer = "#001f29".toColor();
  static final onErrorContainer = "#410002".toColor();

  // surface colors
  static final surfaceDim = "#d9d9e0".toColor();
  static final surface = "#f9f9ff".toColor();
  static final surfaceBright = "#f9f9ff".toColor();
  static final surfContainerLowest = "#ffffff".toColor();
  static final surfContainerLow = "#f3f3fa".toColor();
  static final surfContainer = "#ededf4".toColor();
  static final surfContainerHigh = "#e8e7ee".toColor();
  static final surfContainerHighest = "#e2e2e9".toColor();

  // on Surface Colors
  static final onSurface = "#1a1b20".toColor();
  static final onSurfaceVariant = "#44474f".toColor();
  static final outline = "#74777f".toColor();
  static final outlineVariant = "#c4c6d0".toColor();

  // inverse colors
  static final inverseSurface = "#2f3036".toColor();
  static final inverseOnSurface = "#f0f0f7".toColor();
  static final inversePrimary = "#adc6ff".toColor();

  // extras
  static final scrim = "#000000".toColor();
  static final shadow = "#000000".toColor();

  static const lightEventColorScheme = {
    "peacock": Color(0xFF7986CB), // Light Blue (default event color)
    "pistachio": Color(0xFF33B679), // Green
    "tomato": Color(0xFFF4511E), // Red
    "banana": Color(0xFFFBBC05), // Yellow
    "cobalt": Color(0xFF46BDDC), // Teal
    "pumpkin": Color(0xFFE37400), // Orange
    "grape": Color(0xFFA142F4), // Purple
    "radicchio": Color(0xFFD50000), // Dark Red
  };
}

class AppColorsDark {
  // main colors light
  static final primary = "#adc6ff".toColor();
  static final secondary = "#bfc6dc".toColor();
  static final tertiary = "#89d0ed".toColor();
  static final error = "#ffb4ab".toColor();
  // on main colors light
  static final onPrimary = "#102f60".toColor();
  static final onSecondary = "#293041".toColor();
  static final onTertiary = "#003544".toColor();
  static final onError = "#690005".toColor();

  // container colors light
  static final primaryContainer = "#2b4678".toColor();
  static final secondaryContainer = "#3f4759".toColor();
  static final tertiaryContainer = "#004d62".toColor();
  static final errorContainer = "#93000a".toColor();

  // on container colors light
  static final onPrimaryContainer = "#d8e2ff".toColor();
  static final onSecondaryContainer = "#dbe2f9".toColor();
  static final onTertiaryContainer = "#b9eaff".toColor();
  static final onErrorContainer = "#ffdad6".toColor();

  // surface colors
  static final surfaceDim = "#111318".toColor();
  static final surface = "#111318".toColor();
  static final surfaceBright = "#37393e".toColor();
  static final surfContainerLowest = "#0c0e13".toColor();
  static final surfContainerLow = "#1a1b20".toColor();
  static final surfContainer = "#1e1f25".toColor();
  static final surfContainerHigh = "#282a2f".toColor();
  static final surfContainerHighest = "#33353a".toColor();

  // on Surface Colors
  static final onSurface = "#e2e2e9".toColor();
  static final onSurfaceVariant = "#c4c6d0".toColor();
  static final outline = "#8e9099".toColor();
  static final outlineVariant = "#44474f".toColor();

  // inverse colors
  static final inverseSurface = "#e2e2e9".toColor();
  static final inverseOnSurface = "#2f3036".toColor();
  static final inversePrimary = "#445e91".toColor();

  // extras
  static final scrim = "#000000".toColor();
  static final shadow = "#445e91".toColor();

  static const darkEventColorScheme = {
    "peacock": Color(0xFF8AB4F8), // Lighter blue for events in dark mode
    "pistachio": Color(0xFF57BB8A), // Light green
    "tomato": Color(0xFFEA7D55), // Red-orange
    "banana": Color(0xFFFFCA28), // Yellow
    "cobalt": Color(0xFF00ACC1), // Light teal
    "pumpkin": Color(0xFFF09300), // Lighter orange
    "grape": Color(0xFFBB86FC), // Light purple
    "radicchio": Color(0xFFCF6679), // Light red
  };
}
