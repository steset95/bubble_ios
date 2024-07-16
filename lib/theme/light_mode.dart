import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
primaryColor: Colors.blueAccent.shade200,
  colorScheme: ColorScheme.light(
    background: Colors.white,
  primary: Colors.indigo.shade500,
  secondary: Colors.orange.shade300,
  inversePrimary:  Colors.white,
    brightness: Brightness.light,
    ),

    textTheme: ThemeData.light().textTheme.copyWith(
      titleLarge: TextStyle(fontFamily: 'Goli'),
      titleMedium: TextStyle(fontFamily: 'Goli'),
      titleSmall: TextStyle(fontFamily: 'Goli', ),
      headlineMedium: TextStyle(fontFamily: 'Goli', color: Colors.red),
      headlineSmall: TextStyle(fontFamily: 'Goli',),
      bodyLarge: TextStyle(fontFamily: 'AllenSans'),
      bodyMedium: TextStyle(fontFamily: 'AllenSans'),
      bodySmall: TextStyle(fontFamily: 'AllenSans'),
      labelLarge: TextStyle(fontFamily: 'Goli',),
      labelMedium: TextStyle(fontFamily: 'Goli',),
      labelSmall: TextStyle(fontFamily: 'Goli',),


    ),
  appBarTheme: AppBarTheme(
  titleTextStyle: TextStyle(fontFamily: 'Goli', color: Colors.white, fontSize: 25),
    iconTheme: IconThemeData(
      color: Colors.white, //change your color here
    ),
),


    );

