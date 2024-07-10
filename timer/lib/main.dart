import 'package:flutter/material.dart';
import 'package:timer/pages/timer_page/timer_page.dart';
import 'package:timer/services/service_locator.dart';

void main() {
  setupGetIt();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TimerPage(),
    );
  }
}
