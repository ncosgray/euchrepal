/*
 *******************************************************************************
 Package:  euchrepal
 Class:    strings.dart
 Author:   Nathan Cosgray | https://www.nathanatos.com
 -------------------------------------------------------------------------------
 Copyright (c) 2023 Nathan Cosgray. All rights reserved.

 This source code is licensed under the BSD-style license found in LICENSE.txt.
 *******************************************************************************
*/

// EuchrePal
// - UI strings

class Str {
  static String get appName => 'EuchrePal';
  static String get suitHeader => 'What\u2019s Trump?';
  static String get suitHeaderSanitized => 'Current Suit';
  static String get settingsHeader => '${Str.appName} Settings';
  static String get settingsSanitize => 'Don\u2019t say \u201ctrump\u201d';
  static String get settingsHierarchy => 'Show card hierarchy';
  static String get settingsWakelock => 'Keep screen on';
  static String get replayTutorial => 'Replay app tutorial';
  static String get rulesText => 'Euchre rules';
  static String get rulesURL => 'https://bicyclecards.com/how-to-play/euchre';
  static String get gitHubText => '${Str.appName} source code';
  static String get gitHubURL => 'https://github.com/ncosgray/euchrepal';
  static String get aboutText =>
      '${Str.appName} is a free, open-source app inspired by Alex Mysliwiec\u2019s Euchre Block.';
  static String get copyrightText => '\u00a9 Nathan Cosgray';
  static String get okButton => 'OK';
  static String get tutorial1 =>
      'Welcome to ${Str.appName}, a simple companion app for your Euchre games.';
  static String get tutorial2 => '''Here\u2019s how to use this app:
1. Put your device where everyone can see the screen.
2. Keep track of trump by tapping a suit button whenever a player calls it.
3. As you play tricks, just glance at the screen for a reminder of what trump is!''';
  static String get tutorial3 =>
      'Tap the menu icon for some app settings you can change.';
}
