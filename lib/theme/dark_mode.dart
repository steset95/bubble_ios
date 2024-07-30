import 'package:flutter/material.dart';


ThemeData darkMode = ThemeData(
brightness: Brightness.dark,
colorScheme: ColorScheme.light(
primary: Colors.grey.shade800,
secondary: Colors.grey.shade700,
inversePrimary:  Colors.grey.shade300,
  brightness: Brightness.dark,

),

  textTheme: ThemeData.light().textTheme.copyWith(
    titleLarge: TextStyle(fontFamily: 'Goli-Medium'),
    titleMedium: TextStyle(fontFamily: 'Goli-Regular'),
    titleSmall: TextStyle(fontFamily: 'Goli',),
    headlineMedium: TextStyle(fontFamily: 'Goli',),
    headlineSmall: TextStyle(fontFamily: 'Goli',),
    bodyLarge: TextStyle(fontFamily: 'Goli',),
    bodyMedium: TextStyle(fontFamily: 'Goli',),
    bodySmall: TextStyle(fontFamily: 'Goli',),
    labelLarge: TextStyle(fontFamily: 'Goli-Medium',),
    labelMedium: TextStyle(fontFamily: 'Goli',),
    labelSmall: TextStyle(fontFamily: 'Goli',),


  ),
  appBarTheme: AppBarTheme(
    centerTitle: false,
    titleTextStyle: TextStyle(fontFamily: 'Goli-Bold', color: Colors.white, fontSize: 25,),
    iconTheme: IconThemeData(
      color: Colors.white, //change your color here
    ),
  ),


    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor:
      Colors.grey.shade400,
    )


);