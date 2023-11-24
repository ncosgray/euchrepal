/*
 *******************************************************************************
 Package:  euchrepal
 Class:    main.dart
 Author:   Nathan Cosgray | https://www.nathanatos.com
 -------------------------------------------------------------------------------
 Copyright (c) 2023 Nathan Cosgray. All rights reserved.

 This source code is licensed under the BSD-style license found in LICENSE.txt.
 *******************************************************************************
*/

// EuchrePal

import 'package:euchrepal/home_page.dart';
import 'package:euchrepal/strings.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const EuchrePalApp());
}

class EuchrePalApp extends StatelessWidget {
  const EuchrePalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Str.appName,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      // Define color themes
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
        textTheme: Typography.blackMountainView,
        scaffoldBackgroundColor: Colors.green.shade200,
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
        scaffoldBackgroundColor: Colors.green.shade900,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green.shade800,
          foregroundColor: Colors.white,
        ),
        cardTheme: CardTheme(
          color: Colors.grey.shade300,
          surfaceTintColor: Colors.white,
        ),
        brightness: Brightness.dark,
      ),
    );
  }
}
