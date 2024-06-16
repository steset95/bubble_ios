

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/auth/auth.dart';
import 'package:socialmediaapp/firebase_options.dart';
import 'package:socialmediaapp/pages/register_page.dart';
import 'package:socialmediaapp/theme/dark_mode.dart';
import 'package:socialmediaapp/theme/light_mode.dart';
import 'package:socialmediaapp/old/register_page_backup2.dart';






void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // in Firebase einbinden
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
      theme: lightMode,
      //darkTheme: darkMode,
    );
  }
}

/// Navigationsleiste


