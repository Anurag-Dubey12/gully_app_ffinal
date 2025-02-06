import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../data/controller/tournament_controller.dart';
import '../../../data/model/matchup_model.dart';
import '../../../data/model/scoreboard_model.dart';
import '../../../utils/FallbackImageProvider.dart';
import '../../../utils/app_logger.dart';
import '../../../utils/date_time_helpers.dart';
import '../../../utils/utils.dart';
import '../../screens/full_scorecard.dart';
import '../../theme/theme.dart';

class Performance_matchup extends StatelessWidget {
  final MatchupModel matchup;
  final String? tourid;
  const Performance_matchup({super.key, required this.matchup, this.tourid});

  @override
  Widget build(BuildContext context) {
    final ScoreboardModel? scoreboard = matchup.scoreBoard == null
        ? null
        : ScoreboardModel.fromJson(matchup.scoreBoard!);
    final controller = Get.find<TournamentController>();
    logger.d("The Winner id is:${matchup.getWinningTeamName()}");

    return GestureDetector(
      onTap: () {
        if (scoreboard == null) {
          errorSnackBar("Please Wait for Match to Begin");
        } else {
          Get.to(() => FullScoreboardScreen(scoreboard: scoreboard));
        }
      },
      child: scoreboard == null
          ? EmptyMatchScoreCard()
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      matchup.round?.capitalize ?? '',
                      style: Get.textTheme.labelMedium?.copyWith(),
                    ),
                    const Spacer(),
                    Text(
                      formatDateTime('dd MMM yyyy hh:mm a', matchup.matchDate),
                      style: Get.textTheme.labelMedium?.copyWith(),
                    ),
                  ],
                ),
                SizedBox(height: Get.height * 0.01),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    teamView(
                      matchup.team1.logo ?? '',
                      matchup.team1.name,
                      scoreboard.firstInningHistory == null
                          ? "Did Not Bat"
                          : '${scoreboard.firstInnings?.totalScore ?? 0}/${scoreboard.firstInnings?.totalWickets ?? 0}',
                    ),
                    const SizedBox(height: 5),
                    teamView(
                      matchup.team2.logo ?? '',
                      matchup.team2.name,
                      scoreboard.currentInnings == 1
                          ? "Did Not Bat"
                          : '${scoreboard.secondInnings?.totalScore}/${scoreboard.secondInnings?.totalWickets ?? 0}',
                    ),
                  ],
                ),
                matchup.winningTeam != null
                    ? Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: const EdgeInsets.only(top: 8.0),
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.green.shade600,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      scoreboard.secondInningsText == 'Match Tied'
                          ? "${matchup.getWinningTeamName()} Won The Match"
                          : scoreboard.secondInningsText ?? "",
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                    : (scoreboard.secondInningsText?.isNotEmpty ??
                    false)
                    ? Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: const EdgeInsets.only(top: 8.0),
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.green.shade600,
                      borderRadius:
                      BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      scoreboard.secondInningsText ?? "",
                      style:
                      Get.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                    : const SizedBox.shrink(),
                // "View Match Statistics" Button
                // GestureDetector(
                //   onTap: () {
                //     // Navigate to the match statistics screen
                //     // Get.to(() => MatchStatisticsScreen(matchup: matchup));
                //   },
                //   child: Container(
                //     margin: const EdgeInsets.only(top: 8.0),
                //     padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                //     decoration: BoxDecoration(
                //       color: Colors.blue.shade600,
                //       borderRadius: BorderRadius.circular(5.0),
                //     ),
                //     child: Text(
                //       "View Match Statistics",
                //       style: Get.textTheme.bodyMedium?.copyWith(
                //         color: Colors.white,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Empty Scorecard View when match not started yet
  Widget EmptyMatchScoreCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    formatDateTime('dd MMMM yyyy hh:mm a', matchup.matchDate),
                    style: Get.textTheme.labelMedium?.copyWith(),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.01),
              Row(
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: matchup.team1.logo != null &&
                            matchup.team1.logo!.isNotEmpty
                            ? NetworkImage(matchup.team1.toImageUrl())
                            : const AssetImage('assets/images/logo.png')
                        as ImageProvider,
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 100,
                        child: Text(
                          matchup.team1.name.capitalize,
                          style: Get.textTheme.headlineSmall?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: Get.textScaleFactor * 17,
                          ),
                          softWrap: true,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      Chip(
                        label: Text('VS',
                            style: Get.textTheme.labelLarge?.copyWith(
                                color: Colors.white, fontWeight: FontWeight.bold)),
                        backgroundColor: AppTheme.secondaryYellowColor,
                        side: BorderSide.none,
                      ),
                      Text(
                        matchup.round!.capitalize ?? '',
                        style: Get.textTheme.bodySmall?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: matchup.team2.logo != null &&
                            matchup.team2.logo!.isNotEmpty
                            ? NetworkImage(matchup.team2.toImageUrl())
                            : const AssetImage('assets/images/logo.png')
                        as ImageProvider,
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 100,
                        child: Text(
                          matchup.team2.name.capitalize,
                          style: Get.textTheme.headlineSmall?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: Get.textScaleFactor * 17,
                          ),
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: Get.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }
  Widget teamView(String teamLogo, String teamName, String score) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              CircleAvatar(
                radius: 15.0,
                backgroundImage: FallbackImageProvider(
                  toImageUrl(teamLogo),
                  'assets/images/logo.png',
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  teamName.capitalize,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Text(
          score,
          style: Get.textTheme.bodyMedium?.copyWith(
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
