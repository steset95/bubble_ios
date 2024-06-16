import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.white,
  primary: Colors.blueAccent.withOpacity(0.7),
  secondary: Colors.pinkAccent.withOpacity(0.3),
  inversePrimary:  Colors.white,
    brightness: Brightness.light,
    ),

    textTheme: ThemeData.light().textTheme.apply(
    bodyColor: Colors.black,
    displayColor: Colors.black,
    ),
    );