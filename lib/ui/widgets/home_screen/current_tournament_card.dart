import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/data/model/matchup_model.dart';
import 'package:gully_app/ui/widgets/home_screen/no_tournament_card.dart';

import '../../../data/model/scoreboard_model.dart';
import '../../../utils/FallbackImageProvider.dart';
import '../../../utils/utils.dart';
import '../dialogs/current_score_dialog.dart';
import 'i_button_dialog.dart';

class CurrentTournamentCard extends GetView<TournamentController> {
  const CurrentTournamentCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: Get.height * 0.5,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Obx(() {
          if (controller.matches.isEmpty) {
            return const NoTournamentCard();
          } else {
            return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.matches.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 10, top: 10),
                itemBuilder: (context, snapshot) {
                  return _Card(
                    tournament: controller.matches[snapshot],
                  );
                });
          }
        }),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final MatchupModel tournament;
  const _Card({
    required this.tournament,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TournamentController>();
    final tournamentdata = controller.tournamentList
        .firstWhere((t) => t.id == tournament.tournamentId);
    ScoreboardModel? scoreboard = tournament.scoreBoard == null
        ? null
        : ScoreboardModel.fromJson(tournament.scoreBoard!);

    return Padding(
      key: super.key,
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(0, 1)
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              margin: const EdgeInsets.only(left: 5),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: CircleAvatar(
                backgroundImage: tournamentdata.coverPhoto != null && tournamentdata.coverPhoto!.isNotEmpty
                    ? FallbackImageProvider(
                  toImageUrl(tournamentdata.coverPhoto!),
                    'assets/images/logo.png'
                ) as ImageProvider
                    : const AssetImage('assets/images/logo.png'),
                backgroundColor: Colors.transparent,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                tournament.tournamentName ?? 'Unknown Tournament',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        IconButton(
                          onPressed: () {
                            Get.bottomSheet(
                              IButtonDialog(
                                organizerName: tournamentdata.organizerName!,
                                location: tournamentdata.stadiumAddress,
                                tournamentName: tournamentdata.tournamentName,
                                tournamentPrice: tournamentdata.fees.toString(),
                                coverPhoto: tournamentdata.coverPhoto,
                              ),
                              backgroundColor: Colors.white,
                            );
                          },
                          icon: const Icon(Icons.info_outline_rounded, size: 18),
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    const SizedBox(height: 1),
                    _TeamScore(
                      color: Colors.red,
                      teamName: tournament.team1.name,
                      score: _getScore(scoreboard?.firstInnings),
                    ),
                    const SizedBox(height: 4),
                    _TeamScore(
                      teamName: tournament.team2.name,
                      score: _getScore(scoreboard?.secondInnings),
                      color: Colors.green.shade600,
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 34,
                          width: 100,
                          child: ElevatedButton(
                              onPressed: () {
                                Get.bottomSheet(
                                  BottomSheet(
                                    enableDrag: false,
                                    builder: (context) => ScoreBottomDialog(
                                      match: tournament,
                                    ),
                                    onClosing: () {},
                                  ),
                                  isScrollControlled: true,
                                );
                              },
                              style: ButtonStyle(
                                padding:
                                WidgetStateProperty.all(const EdgeInsets.all(6)),
                              ),
                              child: Text('View Score',
                                  style: Get.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.white))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 1,right: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Live",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getScore(dynamic innings) {
    if (innings == null) return 'yet to bat';
    int? totalScore = innings.totalScore;
    int? totalWickets = innings.totalWickets;
    if (totalScore == null || totalWickets == null) return 'N/A';
    return '$totalScore/$totalWickets';
  }
}

class _TeamScore extends StatelessWidget {
  final String teamName;
  final String score;
  final Color color;

  const _TeamScore({
    required this.teamName,
    required this.score,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            teamName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13
            ),
          ),
        ),
        const SizedBox(width: 1),
        Text(
          score,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}