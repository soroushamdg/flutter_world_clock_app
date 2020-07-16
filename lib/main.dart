import 'package:flutter/material.dart';
import 'package:WorldClock/pages/home.dart';
import 'package:WorldClock/loading.dart';
import 'package:WorldClock/pages/choose_location.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => LoadingScreen(),
      '/home': (context) => Home(),
      '/location': (context) => ChooseLocation()
    },
  ));
}
