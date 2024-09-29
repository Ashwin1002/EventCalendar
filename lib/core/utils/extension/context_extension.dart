import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  /// get theme data
  ThemeData get theme => Theme.of(this);
}
