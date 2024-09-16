import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/data/model/matchup_model.dart';
import 'package:gully_app/data/model/scoreboard_model.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/utils/date_time_helpers.dart';
import '../../../utils/FallbackImageProvider.dart';
import '../../../utils/image_picker_helper.dart';
import '../../../utils/utils.dart';
import '../../screens/full_scorecard.dart';
import 'no_tournament_card.dart';

class PastTournamentMatchCard extends GetView<TournamentController> {
  const PastTournamentMatchCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: Get.height * 0.54,
        child: Obx(() {
          if (controller.tournamentList.isEmpty ||controller.matches.isEmpty) {
            return const NoTournamentCard();
          }else {
            return ListView.builder(
                itemCount: controller.matches.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 10, top: 10),
                itemBuilder: (context, snapshot) {
                  return _Card(
                    tournament: controller.matches[snapshot],
                  );
                });
          }
        }));
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

    int team1total=scoreboard?.firstInnings?.totalScore ?? 0;
    int team2total=scoreboard?.secondInnings?.totalScore ?? 0;
    int team2wickets=scoreboard?.secondInnings?.totalWickets?? 0;

    if (scoreboard != null) {
      if (scoreboard.firstInningHistory.isNotEmpty) {
        team1Score = scoreboard.firstInningHistory.entries.last.value.total;
      }
      team2Score =
      scoreboard.currentInnings == 1 ? 0 : scoreboard.currentInningsScore;

      if (team1Score > team2Score) {
        winnerText = '${scoreboard.team1.name} won by ${team1total-team2total} runs';
        // winnerText = '${scoreboard.team1.name} won the game';
      } else if (team2Score > team1Score) {
        winnerText = '${scoreboard.team2.name} won by ${10 - team2wickets} wickets';
        // winnerText = '${scoreboard.team2.name} won the game';
      }
      else if (scoreboard.isSecondInningsOver && team2total == team1total) {
        winnerText = 'Match Tied';
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
          // border: Border.all(
          //   color: Colors.black
          // ),
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
                      imageViewer(context,tournamentdata.coverPhoto,true);
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
                                  style: const TextStyle(
                                    fontSize: 15
                                  ),
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              formatDateTime('dd/MM/yyyy', tournament.matchDate),
                              style: const TextStyle(
                                  fontSize: 12,
                                color: Colors.grey
                              ),
                            ),
                          ],
                        ),
                        if (scoreboard != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _TeamScore(
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
                              _TeamScore(
                                color: AppTheme.secondaryYellowColor,
                                teamName: scoreboard.team2.name,
                                score: scoreboard.currentInnings == 1
                                    ? "Did Not Bat"
                                    : '${scoreboard.currentInningsScore}/${scoreboard.currentOverHistory.lastOrNull?.wickets ?? 0}',
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
              child: Text(
                winnerText,
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

}


class _TeamScore extends StatelessWidget {
  final Color color;
  final String teamName;
  final String score;

  const _TeamScore({
    required this.color,
    required this.teamName,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  teamName,
                  style: Get.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            score,
            style:
            Get.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

