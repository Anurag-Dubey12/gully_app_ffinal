import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/data/model/matchup_model.dart';
import 'package:gully_app/utils/date_time_helpers.dart';

import '../../theme/theme.dart';
import 'no_tournament_card.dart';

class PastTournamentMatchCard extends GetView<TournamentController> {
  const PastTournamentMatchCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: Get.height * 0.54,
        child: Obx(() {
          if (controller.tournamentList.isEmpty) {
            return const NoTournamentCard();
          } else {
            return ListView.builder(
                itemCount: controller.matches.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 20, top: 10),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 28),
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
                              tournament.team2.toImageUrl(),
                              height: 50,
                              fit: BoxFit.cover,
                              width: 50,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Text(tournament.team1.name,
                              style: Get.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18,
                              ))
                        ],
                      ),
                      const Text('216/8')
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
                              tournament.team2.toImageUrl(),
                              height: 50,
                              fit: BoxFit.cover,
                              width: 50,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Text(tournament.team2.name,
                              style: Get.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18,
                              ))
                        ],
                      ),
                      const Text('216/8')
                    ],
                  ),
                ],
              ),
            ),
            Text(
              'Mi wons by 5 wickets',
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
