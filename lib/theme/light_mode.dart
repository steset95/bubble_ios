import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.white,
  primary: Colors.blueAccent.shade200,
  secondary: Colors.orange.shade300,
  inversePrimary:  Colors.white,
    brightness: Brightness.light,
    ),

    textTheme: ThemeData.light().textTheme.copyWith(
      titleLarge: TextStyle(fontFamily: 'Goli'),
      titleMedium: TextStyle(fontFamily: 'Goli'),
      titleSmall: TextStyle(fontFamily: 'Goli', ),
      headlineMedium: TextStyle(fontFamily: 'Goli',),
      headlineSmall: TextStyle(fontFamily: 'Goli',),
      bodyLarge: TextStyle(fontFamily: 'AllenSans'),
      bodyMedium: TextStyle(fontFamily: 'AllenSans'),
      bodySmall: TextStyle(fontFamily: 'AllenSans'),
      labelLarge: TextStyle(fontFamily: 'Goli',),
      labelMedium: TextStyle(fontFamily: 'Goli',),
      labelSmall: TextStyle(fontFamily: 'Goli',),

    ),


    );