import 'package:flutter/material.dart';
import 'package:google_calendar/core/constants/colors.dart';

class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color error;

  final Color onPrimary;
  final Color onSecondary;
  final Color onTertiary;
  final Color onError;

  final Color primaryContainer;
  final Color secondaryContainer;
  final Color tertiaryContainer;
  final Color errorContainer;

  final Color onPrimaryContainer;
  final Color onSecondaryContainer;
  final Color onTertiaryContainer;
  final Color onErrorContainer;

  final Color surface;
  final Color onSurface;
  final Color surfaceDim;
  final Color outline;
  final Color inverseSurface;
  final Color inverseOnSurface;

  const CustomThemeExtension({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.error,
    required this.onPrimary,
    required this.onSecondary,
    required this.onTertiary,
    required this.onError,
    required this.primaryContainer,
    required this.secondaryContainer,
    required this.tertiaryContainer,
    required this.errorContainer,
    required this.onPrimaryContainer,
    required this.onSecondaryContainer,
    required this.onTertiaryContainer,
    required this.onErrorContainer,
    required this.surface,
    required this.onSurface,
    required this.surfaceDim,
    required this.outline,
    required this.inverseSurface,
    required this.inverseOnSurface,
  });

  // Light Mode Colors
  static final lightMode = CustomThemeExtension(
    primary: AppColorsLight.primary,
    secondary: AppColorsLight.secondary,
    tertiary: AppColorsLight.tertiary,
    error: AppColorsLight.error,
    onPrimary: AppColorsLight.onPrimary,
    onSecondary: AppColorsLight.onSecondary,
    onTertiary: AppColorsLight.onTertiary,
    onError: AppColorsLight.onError,
    primaryContainer: AppColorsLight.primaryContainer,
    secondaryContainer: AppColorsLight.secondaryContainer,
    tertiaryContainer: AppColorsLight.tertiaryContainer,
    errorContainer: AppColorsLight.errorContainer,
    onPrimaryContainer: AppColorsLight.onPrimaryContainer,
    onSecondaryContainer: AppColorsLight.onSecondaryContainer,
    onTertiaryContainer: AppColorsLight.onTertiaryContainer,
    onErrorContainer: AppColorsLight.onErrorContainer,
    surface: AppColorsLight.surface,
    onSurface: AppColorsLight.onSurface,
    surfaceDim: AppColorsLight.surfaceDim,
    outline: AppColorsLight.outline,
    inverseSurface: AppColorsLight.inverseSurface,
    inverseOnSurface: AppColorsLight.inverseOnSurface,
  );

  // Dark Mode Colors
  static final darkMode = CustomThemeExtension(
    primary: AppColorsDark.primary,
    secondary: AppColorsDark.secondary,
    tertiary: AppColorsDark.tertiary,
    error: AppColorsDark.error,
    onPrimary: AppColorsDark.onPrimary,
    onSecondary: AppColorsDark.onSecondary,
    onTertiary: AppColorsDark.onTertiary,
    onError: AppColorsDark.onError,
    primaryContainer: AppColorsDark.primaryContainer,
    secondaryContainer: AppColorsDark.secondaryContainer,
    tertiaryContainer: AppColorsDark.tertiaryContainer,
    errorContainer: AppColorsDark.errorContainer,
    onPrimaryContainer: AppColorsDark.onPrimaryContainer,
    onSecondaryContainer: AppColorsDark.onSecondaryContainer,
    onTertiaryContainer: AppColorsDark.onTertiaryContainer,
    onErrorContainer: AppColorsDark.onErrorContainer,
    surface: AppColorsDark.surface,
    onSurface: AppColorsDark.onSurface,
    surfaceDim: AppColorsDark.surfaceDim,
    outline: AppColorsDark.outline,
    inverseSurface: AppColorsDark.inverseSurface,
    inverseOnSurface: AppColorsDark.inverseOnSurface,
  );

  @override
  CustomThemeExtension copyWith({
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? error,
    Color? onPrimary,
    Color? onSecondary,
    Color? onTertiary,
    Color? onError,
    Color? primaryContainer,
    Color? secondaryContainer,
    Color? tertiaryContainer,
    Color? errorContainer,
    Color? onPrimaryContainer,
    Color? onSecondaryContainer,
    Color? onTertiaryContainer,
    Color? onErrorContainer,
    Color? surface,
    Color? onSurface,
    Color? surfaceDim,
    Color? outline,
    Color? inverseSurface,
    Color? inverseOnSurface,
  }) {
    return CustomThemeExtension(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      tertiary: tertiary ?? this.tertiary,
      error: error ?? this.error,
      onPrimary: onPrimary ?? this.onPrimary,
      onSecondary: onSecondary ?? this.onSecondary,
      onTertiary: onTertiary ?? this.onTertiary,
      onError: onError ?? this.onError,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      secondaryContainer: secondaryContainer ?? this.secondaryContainer,
      tertiaryContainer: tertiaryContainer ?? this.tertiaryContainer,
      errorContainer: errorContainer ?? this.errorContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      onSecondaryContainer: onSecondaryContainer ?? this.onSecondaryContainer,
      onTertiaryContainer: onTertiaryContainer ?? this.onTertiaryContainer,
      onErrorContainer: onErrorContainer ?? this.onErrorContainer,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      surfaceDim: surfaceDim ?? this.surfaceDim,
      outline: outline ?? this.outline,
      inverseSurface: inverseSurface ?? this.inverseSurface,
      inverseOnSurface: inverseOnSurface ?? this.inverseOnSurface,
    );
  }

  @override
  CustomThemeExtension lerp(
      ThemeExtension<CustomThemeExtension>? other, double t) {
    if (other is! CustomThemeExtension) return this;

    return CustomThemeExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      error: Color.lerp(error, other.error, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      onTertiary: Color.lerp(onTertiary, other.onTertiary, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      primaryContainer:
          Color.lerp(primaryContainer, other.primaryContainer, t)!,
      secondaryContainer:
          Color.lerp(secondaryContainer, other.secondaryContainer, t)!,
      tertiaryContainer:
          Color.lerp(tertiaryContainer, other.tertiaryContainer, t)!,
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t)!,
      onPrimaryContainer:
          Color.lerp(onPrimaryContainer, other.onPrimaryContainer, t)!,
      onSecondaryContainer:
          Color.lerp(onSecondaryContainer, other.onSecondaryContainer, t)!,
      onTertiaryContainer:
          Color.lerp(onTertiaryContainer, other.onTertiaryContainer, t)!,
      onErrorContainer:
          Color.lerp(onErrorContainer, other.onErrorContainer, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      surfaceDim: Color.lerp(surfaceDim, other.surfaceDim, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      inverseSurface: Color.lerp(inverseSurface, other.inverseSurface, t)!,
      inverseOnSurface:
          Color.lerp(inverseOnSurface, other.inverseOnSurface, t)!,
    );
  }
}
