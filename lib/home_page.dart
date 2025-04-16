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

import 'package:euchrepal/main.dart';
import 'package:euchrepal/strings.dart';
import 'package:euchrepal/suit.dart';
import 'package:euchrepal/tutorial.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

// Shared preferences keys
const prefSuit = 'currentSuit';
const prefSanitize = 'sanitizeTrump';
const prefHierarchy = 'showHierarchy';
const prefWakelock = 'keepScreenOn';
const prefTutorial = 'showTutorial';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Start a tutorial for new users
      if (prefs.getBool(prefTutorial) ?? true) {
        ShowCaseWidget.of(context).startShowCase(tutorialSteps.keys.toList());
        prefs.setBool(prefTutorial, false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    // Ensure the device screen does not turn off
    if (_keepScreenOn) {
      WakelockPlus.enable();
    } else {
      WakelockPlus.disable();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(Str.appName),
        // Reset button
        leading: IconButton(
          icon: const Icon(Icons.replay_circle_filled),
          onPressed: () => _setSuit(),
        ),
        actions: <Widget>[
          // Settings button
          tutorialTooltip(
            context: context,
            key: tutorialKey3,
            showArrow: true,
            bottomPosition: true,
            child: IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () => _showSettingsDialog(),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Header for suit selection
                tutorialTooltip(
                  context: context,
                  key: tutorialKey1,
                  showArrow: false,
                  bottomPosition: true,
                  child: tutorialTooltip(
                    context: context,
                    key: tutorialKey2,
                    showArrow: false,
                    bottomPosition: true,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _sanitizeTrump
                            ? Str.suitHeaderSanitized
                            : Str.suitHeader,
                        style: const TextStyle(fontSize: 32.0),
                      ),
                    ),
                  ),
                ),
                // Grid of suit options
                GridView.count(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  // 2x2 or 1x4 layout based on orientation and app settings
                  crossAxisCount: isPortrait ? 2 : 4,
                  childAspectRatio:
                      isPortrait
                          ? 1.0
                          : _showHierarchy
                          ? 1.5
                          : 1.1,
                  children: <Widget>[
                    _suitButton(Suit.hearts),
                    _suitButton(Suit.diamonds),
                    _suitButton(Suit.spades),
                    _suitButton(Suit.clubs),
                  ],
                ),
                // Suit card hierarchy
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    // Hide if setting is turned off
                    height: _showHierarchy ? 88.0 : 0.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          _currentSuit != Suit.none && _showHierarchy
                              ? _suitHierarchy(_currentSuit)
                              : [],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    // Release wakelock
    WakelockPlus.disable();
  }

  // Load settings from shared preferences
  void _loadSettings() {
    setState(() {
      _currentSuit = Suit.values[prefs.getInt(prefSuit) ?? _currentSuit.value];
      _sanitizeTrump = prefs.getBool(prefSanitize) ?? _sanitizeTrump;
      _showHierarchy = prefs.getBool(prefHierarchy) ?? _showHierarchy;
      _keepScreenOn = prefs.getBool(prefWakelock) ?? _keepScreenOn;
    });
  }

  // Save settings to shared preferences
  void _saveSettings() {
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
      clipBehavior: Clip.antiAlias,
      // Background color indicates current trump
      color:
          _currentSuit == suit
              ? Colors.yellow[200]
              : MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Theme.of(context).cardTheme.color?.withValues(alpha: 0.2)
              : null,
      // Tappable suit icon
      child: InkWell(
        child: Opacity(
          opacity:
              _currentSuit == suit || _currentSuit == Suit.none ? 1.0 : 0.2,
          child: SizedBox.expand(child: FittedBox(child: suit.icon)),
        ),
        onTap: () => _setSuit(suit),
      ),
    );
  }

  // Set or clear the current trump suit
  void _setSuit([Suit? newSuit]) {
    setState(() {
      if (newSuit == null || newSuit == _currentSuit) {
        _currentSuit = Suit.none;
      } else {
        _currentSuit = newSuit;
      }
      _saveSettings();
    });
  }

  // Playing card widget
  Card _card({required Widget card, required Suit suit}) {
    return Card(
      margin: const EdgeInsets.all(4.0),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // Card and suit
          children: [
            SizedBox(width: 36.0, height: 36.0, child: card),
            SizedBox(width: 28.0, height: 28.0, child: suit.icon),
          ],
        ),
      ),
    );
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
      '9': 'icons/Nine.svg',
    };

    return hierarchy.keys
        .map(
          (card) => _card(
            card: SvgPicture.asset(
              hierarchy[card]!,
              colorFilter: ColorFilter.mode(suit.color!, BlendMode.srcIn),
            ),
            suit: card == 'L' ? suit.companionSuit : suit,
          ),
        )
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
      title: Text(title, style: const TextStyle(fontSize: 16.0)),
      value: value,
      onChanged: onChanged,
    );
  }

  // Settings text button
  InkWell _settingsButton({
    required String title,
    required IconData icon,
    required Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Row(
          children: [
            Text(title, style: const TextStyle(fontSize: 16.0)),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Icon(icon, size: 16.0),
            ),
          ],
        ),
      ),
    );
  }

  // Settings external link
  InkWell _settingsLink({required String title, required String url}) {
    return InkWell(
      onTap:
          () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        title: Row(
          children: [
            Text(title, style: const TextStyle(fontSize: 16.0)),
            const Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Icon(Icons.launch, size: 16.0),
            ),
          ],
        ),
        subtitle: Text(
          Uri.parse(url).host,
          style: const TextStyle(color: Colors.grey, fontSize: 10.0),
        ),
      ),
    );
  }

  // Settings text item
  Text _settingsText(String title) {
    return Text(title, style: const TextStyle(fontSize: 12.0));
  }

  // Settings dialog
  Future<void> _showSettingsDialog() {
    return showDialog<void>(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (_, setDialogState) {
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
                      },
                    ),
                    // Card hierarchy option
                    _settingsSwitch(
                      title: Str.settingsHierarchy,
                      value: _showHierarchy,
                      onChanged: (bool newValue) {
                        setDialogState(() {
                          _showHierarchy = newValue;
                          _saveSettings();
                        });
                      },
                    ),
                    // Wakelock option
                    _settingsSwitch(
                      title: Str.settingsWakelock,
                      value: _keepScreenOn,
                      onChanged: (bool newValue) {
                        setDialogState(() {
                          _keepScreenOn = newValue;
                          _saveSettings();
                        });
                      },
                    ),
                    // Replay tutorial
                    _settingsButton(
                      title: Str.replayTutorial,
                      icon: Icons.slideshow,
                      onTap: () {
                        Navigator.of(context).pop();
                        ShowCaseWidget.of(
                          context,
                        ).startShowCase(tutorialSteps.keys.toList());
                      },
                    ),
                    // Euchre rules link
                    _settingsLink(title: Str.rulesText, url: Str.rulesURL),
                    // GitHub link
                    _settingsLink(title: Str.gitHubText, url: Str.gitHubURL),
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
          },
        );
      },
    );
  }
}
