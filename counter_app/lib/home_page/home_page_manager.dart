import 'package:flutter/material.dart';

class HomePageManager {
  final counterNotifier = ValueNotifier<int>(0);

  void increment() {
    counterNotifier.value++;
  }
}
