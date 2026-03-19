/*
 *******************************************************************************
 Package:  euchrepal
 Class:    score_display.dart
 Author:   Nathan Cosgray | https://www.nathanatos.com
 -------------------------------------------------------------------------------
 Copyright (c) 2023 Nathan Cosgray. All rights reserved.

 This source code is licensed under the BSD-style license found in LICENSE.txt.
 *******************************************************************************
*/

// EuchrePal
// - Score tracking display widgets

import 'package:euchrepal/strings.dart';
import 'package:euchrepal/suit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A single scorecard showing suit-icon pips in a playing card layout.
/// [totalPips] is 4 or 6 (the card denomination).
/// [visiblePips] is how many pips are "exposed" (0..totalPips).
/// [pipSuit] determines which suit SVG to use for pips.
class PipCard extends StatelessWidget {
  final int totalPips;
  final int visiblePips;
  final Suit pipSuit;

  const PipCard({
    super.key,
    required this.totalPips,
    required this.visiblePips,
    required this.pipSuit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(4.0),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(6.0),
        width: 48.0,
        height: 72.0,
        child: _buildPipLayout(),
      ),
    );
  }

  Widget _buildPipLayout() {
    // 6-card: 3 rows x 2 columns
    // 4-card: 2 rows x 2 columns
    int rows = totalPips == 6 ? 3 : 2;
    int cols = 2;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(rows, (row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(cols, (col) {
            int pipIndex = row * cols + col;
            bool isVisible = pipIndex < visiblePips;
            return _pip(isVisible);
          }),
        );
      }),
    );
  }

  Widget _pip(bool visible) {
    String assetPath = pipSuit == Suit.hearts
        ? 'icons/Heart.svg'
        : 'icons/Spade.svg';
    return SizedBox(
      width: 14.0,
      height: 14.0,
      child: SvgPicture.asset(
        assetPath,
        colorFilter: ColorFilter.mode(
          visible ? pipSuit.color : Colors.grey.withValues(alpha: 0.25),
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

/// Score display for both teams, showing pip cards and scoring buttons.
class ScoreDisplay extends StatelessWidget {
  final int team1Score;
  final int team2Score;
  final void Function(int points) onTeam1Score;
  final void Function(int points) onTeam2Score;

  const ScoreDisplay({
    super.key,
    required this.team1Score,
    required this.team2Score,
    required this.onTeam1Score,
    required this.onTeam2Score,
  });

  // Split score into 6-card pips and 4-card pips
  static (int, int) splitScore(int score) {
    int fourCard = score.clamp(0, 4);
    int sixCard = (score - 4).clamp(0, 6);
    return (fourCard, sixCard);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _teamSection(
              context: context,
              label: Str.team1Label,
              score: team1Score,
              pipSuit: Suit.hearts,
              onScore: onTeam1Score,
            ),
            Container(
              width: 1.0,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            _teamSection(
              context: context,
              label: Str.team2Label,
              score: team2Score,
              pipSuit: Suit.spades,
              onScore: onTeam2Score,
            ),
          ],
        ),
      ),
    );
  }

  Color _labelColor(BuildContext context, Suit pipSuit) {
    if (pipSuit == Suit.spades &&
        MediaQuery.of(context).platformBrightness == Brightness.dark) {
      return Colors.white;
    }
    return pipSuit.color;
  }

  Widget _teamSection({
    required BuildContext context,
    required String label,
    required int score,
    required Suit pipSuit,
    required void Function(int) onScore,
  }) {
    var (fourPips, sixPips) = splitScore(score);
    Color textColor = _labelColor(context, pipSuit);
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    Widget scoreLabel = InkWell(
      onTap: score > 0
          ? () => _showCorrectionMenu(context, label, score, onScore)
          : null,
      borderRadius: BorderRadius.circular(4.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$label: ',
                style: TextStyle(fontSize: 16.0, color: textColor),
              ),
              TextSpan(
                text: '$score',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Widget pipCards = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PipCard(totalPips: 4, visiblePips: fourPips, pipSuit: pipSuit),
        PipCard(totalPips: 6, visiblePips: sixPips, pipSuit: pipSuit),
      ],
    );

    Widget scoreButtonsRow = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _scoreButton('+1', () => onScore(1)),
        _scoreButton('+2', () => onScore(2)),
        _scoreButton('+4', () => onScore(4)),
      ],
    );

    if (isLandscape) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            scoreLabel,
            const SizedBox(height: 4.0),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: pipSuit == Suit.hearts
                  ? [scoreButtonsRow, const SizedBox(width: 4.0), pipCards]
                  : [pipCards, const SizedBox(width: 4.0), scoreButtonsRow],
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        scoreLabel,
        const SizedBox(height: 4.0),
        pipCards,
        const SizedBox(height: 4.0),
        scoreButtonsRow,
      ],
    );
  }

  void _showCorrectionMenu(
    BuildContext context,
    String teamName,
    int score,
    void Function(int) onScore,
  ) {
    int adjustedScore = score;

    showDialog<void>(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (_, setDialogState) {
            return AlertDialog(
              title: Text(Str.correctScore.replaceAll('{{team}}', teamName)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$adjustedScore',
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (adjustedScore >= 1)
                        _scoreButton('-1', () {
                          setDialogState(() => adjustedScore -= 1);
                        }),
                      if (adjustedScore >= 2)
                        _scoreButton('-2', () {
                          setDialogState(() => adjustedScore -= 2);
                        }),
                      if (adjustedScore >= 4)
                        _scoreButton('-4', () {
                          setDialogState(() => adjustedScore -= 4);
                        }),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(Str.cancelButton),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text(Str.saveButton),
                  onPressed: () {
                    int difference = adjustedScore - score;
                    if (difference != 0) {
                      onScore(difference);
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _scoreButton(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: SizedBox(
        width: 40.0,
        height: 32.0,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            textStyle: const TextStyle(fontSize: 12.0),
          ),
          onPressed: onPressed,
          child: Text(label),
        ),
      ),
    );
  }
}
