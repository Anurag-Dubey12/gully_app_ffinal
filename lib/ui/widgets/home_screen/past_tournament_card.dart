import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/data/model/matchup_model.dart';
import 'package:gully_app/data/model/scoreboard_model.dart';
import 'package:gully_app/utils/date_time_helpers.dart';
import 'package:gully_app/utils/utils.dart';

import '../../theme/theme.dart';
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
  const _Card({
    required this.tournament,
  });

  @override
  Widget build(BuildContext context) {
    ScoreboardModel? scoreboard = tournament.scoreBoard == null
        ? null
        : ScoreboardModel?.fromJson(tournament.scoreBoard!);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(0, 1))
          ],
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            const SizedBox(height: 7),
            Text(
              tournament.tournamentName!,
              style: Get.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppTheme.darkYellowColor),
            ),
            const SizedBox(height: 7),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 28),
              child: Text(
                'Date: ${formatDateTime('dd MMM yyy', tournament.matchDate)}',
                style: Get.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            if (scoreboard == null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 28),
                child: Text(
                  'Scoreboard not available yet.',
                  style: Get.textTheme.headlineMedium?.copyWith(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
            if (scoreboard != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 28),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                toImageUrl(scoreboard.team1.logo!),
                                height: 50,
                                fit: BoxFit.cover,
                                width: 50,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Text(
                              scoreboard.team1.name,
                              style: Get.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            )
                          ],
                        ),
                        Text(
                            '${scoreboard.firstInningHistory.entries.last.value.total}/${scoreboard.firstInningHistory.entries.last.value.wickets}'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                toImageUrl(scoreboard.team2.logo!),
                                height: 50,
                                fit: BoxFit.cover,
                                width: 50,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Text(scoreboard.team2.name,
                                style: Get.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 18,
                                ))
                          ],
                        ),
                        Text(scoreboard.currentInnings == 1
                            ? "Not Played yet"
                            : '${scoreboard.currentInningsScore}/${scoreboard.currentOverHistory.last?.wickets ?? 0}')
                      ],
                    ),
                  ],
                ),
              ),
            Text(
              scoreboard?.secondInningsText ?? '',
              style: Get.textTheme.headlineMedium?.copyWith(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 17),
          ],
        ),
      ),
    );
  }
}
