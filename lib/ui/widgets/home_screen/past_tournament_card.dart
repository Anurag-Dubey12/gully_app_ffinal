import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/data/model/matchup_model.dart';
import 'package:gully_app/data/model/scoreboard_model.dart';
import 'package:gully_app/ui/screens/schedule_screen.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/utils/date_time_helpers.dart';
import '../../../utils/FallbackImageProvider.dart';
import '../../../utils/app_logger.dart';
import '../../../utils/image_picker_helper.dart';
import '../../../utils/utils.dart';
import '../../screens/full_scorecard.dart';
import 'TeamScore.dart';
import 'no_tournament_card.dart';

class PastTournamentMatchCard extends GetView<TournamentController> {
  const PastTournamentMatchCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Obx(() {
        if (controller.tournamentList.isEmpty || controller.matches.isEmpty) {
          return const NoTournamentCard();
        } else {
          // Filter matches with non-null scoreboards
          final matchMap = controller.matches
              .fold<Map<String, List<MatchupModel>>>({}, (map, match) {
            if (match.tournamentName != null && match.scoreBoard != null) {
              map.putIfAbsent(match.tournamentName!, () => []).add(match);
            } else {
              if (match.tournamentName != null && match.scoreBoard == null) {
                //logger.d"Skipping match with null scoreboard for tournament: ${match.tournamentName} ${match.tournamentId}");
              }
            }
            return map;
          });

          // Remove entries with no matches (filtered by non-null scoreboards)
          final filteredMap = Map.fromEntries(
              matchMap.entries.where((entry) => entry.value.isNotEmpty));

          // Get the latest match for each tournament
          final latestMatch = filteredMap.entries.map((entry) {
            return entry.value.reduce((latest, match) =>
                match.matchDate.isAfter(latest.matchDate) ? match : latest);
          }).toList();

          // If no valid matches, show a NoTournamentCard
          if (latestMatch.isEmpty) {
            return const NoTournamentCard();
          }

          // Return the list of latest matches
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ListView.builder(
              itemCount: latestMatch.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 10, top: 10),
              itemBuilder: (context, snapshot) {
                final matches = latestMatch.reversed.toList();
                return _Card(
                  tournament: matches[snapshot],
                );
              },
            ),
          );
        }
      }),
    );
  }
}

class _Card extends StatelessWidget {
  final MatchupModel tournament;
  const _Card({required this.tournament});

  @override
  Widget build(BuildContext context) {
    ScoreboardModel? scoreboard = tournament.scoreBoard == null
        ? null
        : ScoreboardModel?.fromJson(tournament.scoreBoard!);
    final controller = Get.find<TournamentController>();
    final tournamentdata = controller.tournamentList
        .firstWhere((t) => t.id == tournament.tournamentId);

    String winnerText = '';
    int team1Score = 0;
    int team2Score = 0;

    int team1total = scoreboard?.firstInnings?.totalScore ?? 0;
    int team2total = scoreboard?.secondInnings?.totalScore ?? 0;
    int team2wickets = scoreboard?.secondInnings?.totalWickets ?? 0;

    if (scoreboard != null) {
      if (scoreboard.firstInningHistory.isNotEmpty) {
        team1Score = scoreboard.firstInningHistory.entries.last.value.total;
      }
      team2Score =
          scoreboard.currentInnings == 1 ? 0 : scoreboard.currentInningsScore;

      if (team1Score > team2Score) {
        winnerText =
            '${scoreboard.team1.name} won by ${team1total - team2total} runs';
        // winnerText = '${scoreboard.team1.name} won the game';
      } else if (team2Score > team1Score) {
        winnerText =
            '${scoreboard.team2.name} won by ${10 - team2wickets} wickets';
        // winnerText = '${scoreboard.team2.name} won the game';
      } else if (scoreboard.isSecondInningsOver && team2total == team1total) {
        if (tournament.getWinningTeamName() == null) {
          winnerText = 'Match Tied';
        } else {
          winnerText = "${tournament.getWinningTeamName()} won the match";
        }
      } else {
        winnerText = 'Match Tied';
      }
    }

    return GestureDetector(
      onTap: () {
        Get.to(() => FullScoreboardScreen(scoreboard: scoreboard));
      },
      child: Container(
        width: Get.width,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      imageViewer(context, tournamentdata.coverPhoto, true);
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: tournamentdata.coverPhoto != null &&
                              tournamentdata.coverPhoto!.isNotEmpty
                          ? FallbackImageProvider(
                              toImageUrl(tournamentdata.coverPhoto!),
                              'assets/images/logo.png')
                          : const AssetImage('assets/images/logo.png')
                              as ImageProvider,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  tournament.tournamentName!,
                                  style: const TextStyle(fontSize: 15),
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              formatDateTime(
                                  'dd/MM/yyyy', tournament.matchDate),
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        if (scoreboard != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TeamScore(
                                color: AppTheme.primaryColor,
                                teamName: scoreboard.team1.name,
                                score: scoreboard.firstInningHistory.isNotEmpty
                                    ? '${scoreboard.firstInningHistory.entries.last.value.total}/${scoreboard.firstInningHistory.entries.last.value.wickets}'
                                    : 'N/A',
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: Colors.grey[300],
                              ),
                              TeamScore(
                                color: AppTheme.secondaryYellowColor,
                                teamName: scoreboard.team2.name,
                                score: scoreboard.currentInnings == 1
                                    ? "Did Not Bat"
                                    : '${scoreboard.secondInnings?.totalScore ?? 0}/${scoreboard.secondInnings?.totalWickets ?? 0}',
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      winnerText,
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // const Spacer(),
                  GestureDetector(
                    onTap: () {
                      //logger.d"The TournamentId is:${tournamentdata.id} }");
                      controller.setScheduleStatus(true);
                      controller.tournamentname.value =
                          tournamentdata.tournamentName;
                      Get.to(() => ScheduleScreen(tournament: tournamentdata));
                    },
                    child: const Text(
                      "View Matches",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
