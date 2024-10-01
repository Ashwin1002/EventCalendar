import 'package:flutter/material.dart';
import 'package:google_calendar/core/core.dart';

typedef WidgetBuilder = Widget Function(BuildContext context);

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    required this.mobile,
    required this.tablet,
    this.appBar,
    this.bottomSheet,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.drawer,
  });

  final AppBar? appBar;
  final WidgetBuilder mobile;
  final WidgetBuilder tablet;
  final Widget? bottomSheet;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? drawer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      bottomSheet: bottomSheet,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      body: context.isMobile ? mobile.call(context) : tablet.call(context),
    );
  }
}
