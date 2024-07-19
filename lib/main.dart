/*
 *******************************************************************************
 Package:  euchrepal
 Class:    main.dart
 Author:   Nathan Cosgray | https://www.nathanatos.com
 -------------------------------------------------------------------------------
 Copyright (c) 2023-2024 Nathan Cosgray. All rights reserved.

 This source code is licensed under the BSD-style license found in LICENSE.txt.
 *******************************************************************************
*/

// EuchrePal

import 'package:euchrepal/home_page.dart';
import 'package:euchrepal/strings.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

// Globals
late SharedPreferences prefs;

void main() async {
  // Shared preferences
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

  runApp(const EuchrePalApp());
}

class EuchrePalApp extends StatelessWidget {
  const EuchrePalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return ShowCaseWidget(
          autoPlay: false,
          builder: (context) => child!,
        );
      },
      title: Str.appName,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      // Define color themes
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
        textTheme: Typography.blackMountainView,
        scaffoldBackgroundColor: const Color.fromARGB(255, 194, 234, 196),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        cardTheme: const CardTheme(
          color: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
        textTheme: Typography.whiteMountainView,
        scaffoldBackgroundColor: const Color.fromARGB(255, 0, 35, 0),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 0, 45, 0),
          foregroundColor: Colors.white,
        ),
        cardTheme: const CardTheme(
          color: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        brightness: Brightness.dark,
      ),
    );
  }
}
