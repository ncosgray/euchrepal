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
        primarySwatch: Colors.green,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.green,
        toggleableActiveColor: Colors.green,
        cardTheme: const CardTheme(color: Colors.grey),
        brightness: Brightness.dark,
      ),
    );
  }
}
