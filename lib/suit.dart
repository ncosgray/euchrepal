/*
 *******************************************************************************
 Package:  euchrepal
 Class:    suit.dart
 Author:   Nathan Cosgray | https://www.nathanatos.com
 -------------------------------------------------------------------------------
 Copyright (c) 2023-2024 Nathan Cosgray. All rights reserved.

 This source code is licensed under the BSD-style license found in LICENSE.txt.
 *******************************************************************************
*/

// EuchrePal
// - Card suit definitions

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

final Widget heartIcon = SvgPicture.asset('icons/Heart.svg');
final Widget diamondIcon = SvgPicture.asset('icons/Diamond.svg');
final Widget spadeIcon = SvgPicture.asset('icons/Spade.svg');
final Widget clubIcon = SvgPicture.asset('icons/Club.svg');

enum Suit {
  none(0),
  hearts(1),
  diamonds(2),
  spades(3),
  clubs(4);

  final int value;

  const Suit(this.value);

  // Suit icons
  get icon {
    switch (value) {
      case 1:
        return heartIcon;
      case 2:
        return diamondIcon;
      case 3:
        return spadeIcon;
      case 4:
        return clubIcon;
    }
  }

  // Suit colors
  get color {
    switch (value) {
      case 1:
        return const Color(0xfff44336);
      case 2:
        return const Color(0xfff44336);
      case 3:
        return Colors.black;
      case 4:
        return Colors.black;
    }
  }

  // Companion suits
  get companionSuit {
    switch (value) {
      case 1:
        return Suit.diamonds;
      case 2:
        return Suit.hearts;
      case 3:
        return Suit.clubs;
      case 4:
        return Suit.spades;
    }
  }
}
