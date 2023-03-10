/*
 *******************************************************************************
 Package:  euchrepal
 Class:    home_page.dart
 Author:   Nathan Cosgray | https://www.nathanatos.com
 -------------------------------------------------------------------------------
 Copyright (c) 2023 Nathan Cosgray. All rights reserved.

 This source code is licensed under the BSD-style license found in LICENSE.txt.
 *******************************************************************************
*/

// EuchrePal
// - Build app interface

import 'package:euchrepal/strings.dart';
import 'package:euchrepal/suit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';

// Shared preferences keys
const prefSuit = 'currentSuit';
const prefSanitize = 'sanitizeTrump';
const prefHierarchy = 'showHierarchy';
const prefWakelock = 'keepScreenOn';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // State variables
  Suit _currentSuit = Suit.none;
  bool _sanitizeTrump = false;
  bool _showHierarchy = false;
  bool _keepScreenOn = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
        appBar: AppBar(
          title: Text(Str.appName),
          actions: <Widget>[
            // Settings button
            IconButton(
              icon: SvgPicture.asset('icons/Ellipsis.svg',
                  color: Theme.of(context).primaryIconTheme.color),
              onPressed: () => _showSettingsDialog(),
            ),
          ],
        ),
        body: Center(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Header for suit selection
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _sanitizeTrump ? Str.suitHeaderSanitized : Str.suitHeader,
                  style: const TextStyle(fontSize: 32.0),
                ),
              ),
              // Grid of suit options
              GridView.count(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  // 2x2 or 1x4 layout based on orientation and app settings
                  crossAxisCount: isPortrait ? 2 : 4,
                  childAspectRatio: isPortrait
                      ? 1.0
                      : _showHierarchy
                          ? 1.5
                          : 1.1,
                  children: <Widget>[
                    _suitButton(Suit.hearts),
                    _suitButton(Suit.diamonds),
                    _suitButton(Suit.spades),
                    _suitButton(Suit.clubs),
                  ]),
              // Suit card hierarchy
              Container(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      // Hide if setting is turned off
                      height: _showHierarchy ? 88.0 : 0.0,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _currentSuit != Suit.none && _showHierarchy
                              ? _suitHierarchy(_currentSuit)
                              : []))),
            ],
          ),
        )));
  }

  // Load settings from shared preferences
  void _loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentSuit = Suit.values[prefs.getInt(prefSuit) ?? _currentSuit.value];
      _sanitizeTrump = prefs.getBool(prefSanitize) ?? _sanitizeTrump;
      _showHierarchy = prefs.getBool(prefHierarchy) ?? _showHierarchy;
      _keepScreenOn = prefs.getBool(prefWakelock) ?? _keepScreenOn;
    });
  }

  // Save settings to shared preferences
  void _saveSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt(prefSuit, _currentSuit.value);
      prefs.setBool(prefSanitize, _sanitizeTrump);
      prefs.setBool(prefHierarchy, _showHierarchy);
      prefs.setBool(prefWakelock, _keepScreenOn);
    });
  }

  // Button for a suit
  Card _suitButton(Suit suit) {
    return Card(
        margin: const EdgeInsets.all(8.0),
        // Background color indicates current trump
        color: _currentSuit == suit ? Colors.yellow[200] : null,
        // Tappable suit icon
        child: InkWell(
            child: Opacity(
                opacity: _currentSuit == suit || _currentSuit == Suit.none
                    ? 1.0
                    : 0.2,
                child: SizedBox.expand(child: FittedBox(child: suit.icon))),
            onTap: () => _setSuit(suit)));
  }

  // Set or clear the current trump suit
  void _setSuit(Suit newSuit) {
    setState(() {
      if (newSuit == _currentSuit) {
        // Clear trump and release wakelock
        _currentSuit = Suit.none;
        Wakelock.disable();
      } else {
        // Set trump and ensure the device screen does not turn off
        _currentSuit = newSuit;
        if (_keepScreenOn) {
          Wakelock.enable();
        }
      }
      _saveSettings();
    });
  }

  // Playing card widget
  Card _card({required Widget card, required Suit suit}) {
    return Card(
        margin: const EdgeInsets.all(4.0),
        color: Colors.white,
        shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(2.0)),
        child: Container(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // Card and suit
              children: [
                SizedBox(width: 36.0, height: 36.0, child: card),
                SizedBox(width: 28.0, height: 28.0, child: suit.icon),
              ],
            )));
  }

  // Euchre card hierarchy
  List<Widget> _suitHierarchy(Suit suit) {
    final Map<String, String> hierarchy = {
      'J': 'icons/Jack.svg', // Right bower
      'L': 'icons/Jack.svg', // Left bower
      'A': 'icons/Ace.svg',
      'K': 'icons/King.svg',
      'Q': 'icons/Queen.svg',
      '10': 'icons/Ten.svg',
      '9': 'icons/Nine.svg'
    };

    return hierarchy.keys
        .map((card) => _card(
            card: SvgPicture.asset(hierarchy[card]!, color: suit.color),
            suit: card == 'L' ? suit.companionSuit : suit))
        .toList();
  }

  // Settings switch
  SwitchListTile _settingsSwitch({
    required String title,
    required bool value,
    required void Function(bool) onChanged,
  }) {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(fontSize: 18.0),
      ),
      value: value,
      onChanged: onChanged,
    );
  }

  // Settings text item
  Text _settingsText(String title) {
    return Text(title,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14.0,
        ));
  }

  // Settings dialog
  Future<void> _showSettingsDialog() {
    return showDialog<void>(
      context: context,
      builder: (_) {
        return StatefulBuilder(builder: (_, setDialogState) {
          return AlertDialog(
            title: Text(Str.settingsHeader),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  // Sanitize Trump option
                  _settingsSwitch(
                      title: Str.settingsSanitize,
                      value: _sanitizeTrump,
                      onChanged: (bool newValue) {
                        setDialogState(() {
                          _sanitizeTrump = newValue;
                          _saveSettings();
                        });
                      }),
                  // Card hierarchy option
                  _settingsSwitch(
                      title: Str.settingsHierarchy,
                      value: _showHierarchy,
                      onChanged: (bool newValue) {
                        setDialogState(() {
                          _showHierarchy = newValue;
                          _saveSettings();
                        });
                      }),
                  // Wakelock option
                  _settingsSwitch(
                      title: Str.settingsWakelock,
                      value: _keepScreenOn,
                      onChanged: (bool newValue) {
                        setDialogState(() {
                          _keepScreenOn = newValue;
                          _saveSettings();
                        });
                      }),
                  // About text
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: _settingsText(Str.aboutText),
                    subtitle: _settingsText(Str.copyrightText),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              // OK button
              TextButton(
                child: Text(Str.okButton),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        });
      },
    );
  }
}
