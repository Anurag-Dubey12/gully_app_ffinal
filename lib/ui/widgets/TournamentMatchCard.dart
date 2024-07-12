import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../data/model/matchup_model.dart';
import '../../data/model/scoreboard_model.dart';
import '../../utils/date_time_helpers.dart';

class TournamentMatchCard extends StatelessWidget {
  final MatchupModel match;

  const TournamentMatchCard({Key? key, required this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScoreboardModel? scoreboard = match.scoreBoard == null
        ? null
        : ScoreboardModel.fromJson(match.scoreBoard!);
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${formatDateTime('dd/MM/yyyy', match.matchDate)}',
              style: Get.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(match.team1.name, style: Get.textTheme.titleMedium),
                const Text('vs', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(match.team2.name, style: Get.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 8),
            if (match.scoreBoard != null)
              Text(
                'Result: ${_getMatchResult(match.scoreBoard!)}',
                style: Get.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }

  String _getMatchResult(Map<String, dynamic> scoreBoard) {
    final scoreboard = ScoreboardModel.fromJson(scoreBoard);
    int team1Score = scoreboard.firstInningHistory.entries.last.value.total;
    int team2Score = scoreboard.currentInnings == 1 ? 0 : scoreboard.currentInningsScore;

    if (team1Score > team2Score) {
      return '${scoreboard.team1.name} won';
    } else if (team1Score < team2Score) {
      return '${scoreboard.team2.name} won';
    } else {
      return 'Match tied';
    }
  }
}