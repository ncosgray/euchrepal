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
  static String get suitHeader => 'What\'s Trump?';
  static String get suitHeaderSanitized => 'Current Suit';
  static String get settingsHeader => '${Str.appName} Settings';
  static String get settingsSanitize => 'Don\'t say "trump"';
  static String get settingsHierarchy => 'Show card hierarchy';
  static String get settingsWakelock => 'Keep screen on';
  static String get aboutText => '${Str.appName} is a free, open-source app'
      ' inspired by Alex Mysliwiec\'s Euchre Block.';
  static String get copyrightText => '\u00a9 Nathan Cosgray';
  static String get okButton => 'OK';
}
