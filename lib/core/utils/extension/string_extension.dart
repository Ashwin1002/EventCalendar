import 'dart:ui';

extension StringExtension on String {
  /// Converts a hex color string to a Flutter [Color].
  Color toColor() {
    final hex = replaceFirst('#', ''); // Remove the '#' if it exists
    if (hex.length == 6) {
      return Color(int.parse('FF$hex', radix: 16)); // Add alpha channel (FF)
    } else if (hex.length == 8) {
      return Color(int.parse(hex, radix: 16)); // If alpha is included
    } else {
      throw const FormatException("Invalid hex color format.");
    }
  }
}
