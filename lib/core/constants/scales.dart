import 'package:flutter/material.dart';

class AppScales {
  static const smallRadius = Radius.circular(4.0);
  static const mediumRadius = Radius.circular(8.0);
  static const largeRadius = Radius.circular(16.0);
  static const extraLargeRadius = Radius.circular(32.0);

  // For mobile devices
  static EdgeInsets mobilePadding =
      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);

// For tablet devices
  static EdgeInsets tabletPadding =
      const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0);
}
