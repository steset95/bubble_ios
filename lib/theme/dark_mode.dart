import 'package:flutter/material.dart';


ThemeData darkMode = ThemeData(
brightness: Brightness.dark,
colorScheme: ColorScheme.light(
background: Colors.grey.shade900,
primary: Colors.grey.shade800,
secondary: Colors.grey.shade700,
inversePrimary:  Colors.grey.shade300,
  brightness: Brightness.dark,
),

textTheme: ThemeData.dark().textTheme.apply(
bodyColor: Colors.grey.shade300,
displayColor: Colors.white,

),
);