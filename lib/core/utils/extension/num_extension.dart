import 'package:flutter/material.dart';

extension NumExtension on num {
  /// create a horizontal space with the given width
  SizedBox get horizontalSpace => SizedBox(width: toDouble());

  /// create a vertical space with the given heifht
  SizedBox get verticalSpace => SizedBox(height: toDouble());
}
