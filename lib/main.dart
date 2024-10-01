import 'package:flutter/material.dart';
import 'package:google_calendar/core/theme/material_theme.dart';
import 'package:google_calendar/src/schedule/view/schedule_listview.dart';

void main() {
  runApp(const MyApp());
}

final materialTheme = MaterialTheme();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Calendar Demo',
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),
      themeMode: ThemeMode.system,
      home: const ScheduleListview(),
    );
  }
}
