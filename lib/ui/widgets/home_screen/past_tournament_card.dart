import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/data/model/matchup_model.dart';
import 'package:gully_app/data/model/scoreboard_model.dart';
import 'package:gully_app/utils/date_time_helpers.dart';
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
          if (controller.tournamentList.isEmpty) {
            return const NoTournamentCard();
          } else {
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
    if (scoreboard != null) {
      int team1Score = scoreboard.firstInningHistory.entries.last.value.total;
      int team2Score = scoreboard.currentInnings == 1
          ? 0
          : scoreboard.currentInningsScore;

      if (team1Score > team2Score) {
        winnerText = '${scoreboard.team1.name} won the game';
      } else if (team1Score < team2Score) {
        winnerText = '${scoreboard.team2.name} won the game';
      } else {
        winnerText = 'The game was a tie';
      }
    }

    return GestureDetector(
      onTap: () {
        Get.to(() => FullScoreboardScreen(scoreboard: scoreboard));
      },
      child: Container(
        width: Get.width,
        height: 180,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
              offset: const Offset(0, 1),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 2),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: tournamentdata.coverPhoto != null&& tournamentdata.coverPhoto!.isNotEmpty
                    ? NetworkImage(toImageUrl(tournamentdata.coverPhoto!))as ImageProvider
                    :const AssetImage('assets/images/logo.png'),
                backgroundColor: Colors.transparent,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width:300,
                      height: 30,
                      child: Center(
                          child: Text(
                            tournament.tournamentName!,
                            style: Get.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            softWrap: true,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: Text(
                        'Date: ${formatDateTime('dd/MM/yyyy', tournament.matchDate)}',
                        style: Get.textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (scoreboard != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _TeamScore(
                            color: Colors.red,
                            teamName: scoreboard.team1.name,
                            score: '${scoreboard.firstInningHistory.entries.last.value.total}/${scoreboard.firstInningHistory.entries.last.value.wickets}',
                          ),
                          const SizedBox(width: 10),
                          _TeamScore(
                            color: Colors.green,
                            teamName: scoreboard.team2.name,
                            score: scoreboard.currentInnings == 1
                                ? "Not Played yet"
                                : '${scoreboard.currentInningsScore}/${scoreboard.currentOverHistory.last?.wickets ?? 0}',
                          ),
                        ],
                      ),
                    const Spacer(),
                    SizedBox(
                      height: 60,
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.red.shade400,
                                border: Border.all(
                                    color: const Color.fromARGB(255, 255, 215, 0),
                                    width: 2
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.red.shade400,
                                border: Border.all(
                                    color: const Color.fromARGB(255, 255, 215, 0),
                                  width: 2
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 20,
                            right: 20,
                            top: 0,
                            bottom: 20,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                border: Border.all(
                                    color: const Color.fromARGB(255, 255, 215, 0),
                                    width: 2
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  winnerText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
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
            style: Get.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}


