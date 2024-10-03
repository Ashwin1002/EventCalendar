import "package:flutter/material.dart";
import "package:google_calendar/core/core.dart";

class MaterialTheme {
  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff1266F1),
      surfaceTint: Color(0xff445e91),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffd8e2ff),
      onPrimaryContainer: Color(0xff001a41),
      secondary: Color(0xff575e71),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffdbe2f9),
      onSecondaryContainer: Color(0xff141b2c),
      tertiary: Color(0xff0b6780),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffb9eaff),
      onTertiaryContainer: Color(0xff001f29),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfff9f9ff),
      onSurface: Color(0xff1a1b20),
      onSurfaceVariant: Color(0xff44474f),
      outline: Color(0xff74777f),
      outlineVariant: Color(0xffc4c6d0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f3036),
      inversePrimary: Color(0xffadc6ff),
      primaryFixed: Color(0xffd8e2ff),
      onPrimaryFixed: Color(0xff001a41),
      primaryFixedDim: Color(0xffadc6ff),
      onPrimaryFixedVariant: Color(0xff2b4678),
      secondaryFixed: Color(0xffdbe2f9),
      onSecondaryFixed: Color(0xff141b2c),
      secondaryFixedDim: Color(0xffbfc6dc),
      onSecondaryFixedVariant: Color(0xff3f4759),
      tertiaryFixed: Color(0xffb9eaff),
      onTertiaryFixed: Color(0xff001f29),
      tertiaryFixedDim: Color(0xff89d0ed),
      onTertiaryFixedVariant: Color(0xff004d62),
      surfaceDim: Color(0xffd9d9e0),
      surfaceBright: Color(0xfff9f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f3fa),
      surfaceContainer: Color(0xffededf4),
      surfaceContainerHigh: Color(0xffe8e7ee),
      surfaceContainerHighest: Color(0xffe2e2e9),
    );
  }

  /// Light Theme Data
  ThemeData light() {
    return _theme(lightScheme())
        .copyWith(extensions: [CustomThemeExtension.lightMode]);
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffadc6ff),
      surfaceTint: Color(0xffadc6ff),
      onPrimary: Color(0xff102f60),
      primaryContainer: Color(0xff2b4678),
      onPrimaryContainer: Color(0xffd8e2ff),
      secondary: Color(0xffbfc6dc),
      onSecondary: Color(0xff293041),
      secondaryContainer: Color(0xff3f4759),
      onSecondaryContainer: Color(0xffdbe2f9),
      tertiary: Color(0xff89d0ed),
      onTertiary: Color(0xff003544),
      tertiaryContainer: Color(0xff004d62),
      onTertiaryContainer: Color(0xffb9eaff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff111318),
      onSurface: Color(0xffe2e2e9),
      onSurfaceVariant: Color(0xffc4c6d0),
      outline: Color(0xff8e9099),
      outlineVariant: Color(0xff44474f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e9),
      inversePrimary: Color(0xff445e91),
      primaryFixed: Color(0xffd8e2ff),
      onPrimaryFixed: Color(0xff001a41),
      primaryFixedDim: Color(0xffadc6ff),
      onPrimaryFixedVariant: Color(0xff2b4678),
      secondaryFixed: Color(0xffdbe2f9),
      onSecondaryFixed: Color(0xff141b2c),
      secondaryFixedDim: Color(0xffbfc6dc),
      onSecondaryFixedVariant: Color(0xff3f4759),
      tertiaryFixed: Color(0xffb9eaff),
      onTertiaryFixed: Color(0xff001f29),
      tertiaryFixedDim: Color(0xff89d0ed),
      onTertiaryFixedVariant: Color(0xff004d62),
      surfaceDim: Color(0xff111318),
      surfaceBright: Color(0xff37393e),
      surfaceContainerLowest: Color(0xff0c0e13),
      surfaceContainerLow: Color(0xff1a1b20),
      surfaceContainer: Color(0xff1e1f25),
      surfaceContainerHigh: Color(0xff282a2f),
      surfaceContainerHighest: Color(0xff33353a),
    );
  }

  /// Dark Theme Data
  ThemeData dark() {
    return _theme(darkScheme())
        .copyWith(extensions: [CustomThemeExtension.darkMode]);
  }

  ThemeData _theme(ColorScheme colorScheme) => ThemeData(
        fontFamily: 'OpenSans',
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: _appTextThemes.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}

/// Text Styles according to material3
const TextTheme _appTextThemes = TextTheme(
  displayLarge: TextStyle(
    fontSize: 57.0,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.25,
    color: Colors.black,
  ),
  displayMedium: TextStyle(
    fontSize: 45.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    color: Colors.black,
  ),
  displaySmall: TextStyle(
    fontSize: 36.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    color: Colors.black,
  ),
  headlineLarge: TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    color: Colors.black,
  ),
  headlineMedium: TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    color: Colors.black,
  ),
  headlineSmall: TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.0,
    color: Colors.black,
  ),
  titleLarge: TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.0,
    color: Colors.black,
  ),
  titleMedium: TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    color: Colors.black,
  ),
  titleSmall: TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: Colors.black,
  ),
  bodyLarge: TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    color: Colors.black87,
  ),
  bodyMedium: TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    color: Colors.black87,
  ),
  bodySmall: TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: Colors.black87,
  ),
  labelLarge: TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: Colors.black,
  ),
  labelMedium: TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: Colors.black,
  ),
  labelSmall: TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: Colors.black,
  ),
);
