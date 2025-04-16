/*
 *******************************************************************************
 Package:  euchrepal
 Class:    tutorial.dart
 Author:   Nathan Cosgray | https://www.nathanatos.com
 -------------------------------------------------------------------------------
 Copyright (c) 2023-2024 Nathan Cosgray. All rights reserved.

 This source code is licensed under the BSD-style license found in LICENSE.txt.
 *******************************************************************************
*/

// EuchrePal tutorial

import 'package:euchrepal/strings.dart';

import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

// Tutorial widget keys
final GlobalKey tutorialKey1 = GlobalKey();
final GlobalKey tutorialKey2 = GlobalKey();
final GlobalKey tutorialKey3 = GlobalKey();
Map<GlobalKey, String> tutorialSteps = {
  tutorialKey1: Str.tutorial1,
  tutorialKey2: Str.tutorial2,
  tutorialKey3: Str.tutorial3,
};

// Define a tutorial tooltip
Widget tutorialTooltip({
  required BuildContext context,
  required GlobalKey key,
  bool showArrow = true,
  bool bottomPosition = false,
  required Widget child,
}) {
  if (tutorialSteps.containsKey(key)) {
    return Showcase(
      key: key,
      title:
          '(${tutorialSteps.keys.toList().indexOf(key) + 1}/${tutorialSteps.length})',
      titleTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.inversePrimary,
      ),
      description: tutorialSteps[key],
      descTextStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      tooltipPosition:
          bottomPosition ? TooltipPosition.bottom : TooltipPosition.top,
      tooltipBackgroundColor: Theme.of(context).colorScheme.primary,
      showArrow: showArrow,
      overlayOpacity: 0.0,
      disableMovingAnimation: false,
      disableScaleAnimation: false,
      scaleAnimationAlignment: Alignment.center,
      onToolTipClick: () => ShowCaseWidget.of(context).next(),
      child: child,
    );
  } else {
    return Container(child: child);
  }
}
