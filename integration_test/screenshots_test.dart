/*
 *******************************************************************************
 Package:  euchrepal
 Class:    screenshots_test.dart
 Author:   Nathan Cosgray | https://www.nathanatos.com
 -------------------------------------------------------------------------------
 Copyright (c) 2023 Nathan Cosgray. All rights reserved.

 This source code is licensed under the BSD-style license found in LICENSE.txt.
 *******************************************************************************
*/

// Generate EuchrePal screenshots

import 'package:euchrepal/main.dart';
import 'package:euchrepal/strings.dart';
import 'package:euchrepal/tutorial.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

Future<void> main() async {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
    ..framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  setUpAll(() async {
    // Initialize app
    await initApp();

    // Initialize Flutter bindings
    TestWidgetsFlutterBinding.ensureInitialized();
    WidgetsFlutterBinding.ensureInitialized();
    if (Platform.isAndroid) {
      await binding.convertFlutterSurfaceToImage();
    }
  });

  testWidgets('collect screenshots', ($) async {
    // Run app
    await $.pumpWidget(const EuchrePalApp());
    await $.pumpAndSettle();

    // Tap through tutorials
    final size = $.view.physicalSize / $.view.devicePixelRatio;
    final center = Offset(size.width / 2, size.height / 2);
    for (final _ in tutorialSteps.keys) {
      sleep(const Duration(seconds: 2));
      await $.tapAt(center);
      await $.pumpAndSettle();
    }

    // Screenshot 1: Initial home screen
    await $.tap(find.text(Str.suitHeader));
    await $.pumpAndSettle();
    sleep(const Duration(seconds: 2));
    await binding.takeScreenshot('1-initial');

    // Screenshot 2: Suit selected and card hierarchy visible
    await $.tap(find.byType(InkWell).first);
    await $.pumpAndSettle();
    await $.tap(find.byIcon(Icons.settings));
    await $.pumpAndSettle();
    await $.tap(find.text(Str.settingsHierarchy));
    await $.pumpAndSettle();
    await $.tap(find.text(Str.okButton));
    await $.pumpAndSettle();
    sleep(const Duration(seconds: 2));
    await binding.takeScreenshot('2-selected');

    // Screenshot 4: Settings page
    await $.tap(find.byIcon(Icons.settings));
    await $.pumpAndSettle();
    await $.tap(find.text(Str.settingsScoring));
    await $.pumpAndSettle();
    await $.tap(find.text(Str.settingsSanitize));
    await $.pumpAndSettle();
    sleep(const Duration(seconds: 2));
    await binding.takeScreenshot('4-settings');

    // Screenshot 3: Score tracker
    await $.tap(find.text(Str.okButton));
    await $.pumpAndSettle();
    await $.tap(find.text('+4').first);
    await $.pumpAndSettle();
    sleep(const Duration(seconds: 2));
    await binding.takeScreenshot('3-scores');
  });
}
