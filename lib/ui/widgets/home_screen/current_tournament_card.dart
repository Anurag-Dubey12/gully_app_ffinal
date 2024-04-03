import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/data/model/matchup_model.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/home_screen/no_tournament_card.dart';

import '../../../utils/date_time_helpers.dart';
import '../dialogs/current_score_dialog.dart';

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
    return Padding(
      key: super.key,
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
            color: Colors.white,
            image: const DecorationImage(
              image: AssetImage(
                'assets/images/cricket_bat.png',
              ),
              alignment: Alignment.bottomLeft,
              opacity: 0.4,
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: const Offset(0, 1))
            ],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300, width: 2)),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(tournament.tournamentName!,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkYellowColor)),

                    // Text(isDateTimeInFuture(dateTime)?'Ongoing',
                    //     style: TextStyle(
                    //         fontSize: 13, fontWeight: FontWeight.w500))
                  ],
                ),
              ),
            ),
            const SizedBox(height: 7),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          tournament.team1.toImageUrl(),
                          fit: BoxFit.cover,
                          height: 50,
                          width: 50,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        tournament.team1.name,
                        style: Get.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      Text(
                        formatDateTime('hh:mm a', tournament.matchDate),
                        style: Get.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        formatDateTime('dd-MMM-yyy', tournament.matchDate),
                        style: Get.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
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
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        child: Text(
                          tournament.team2.name,
                          style: Get.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: Get.textScaleFactor * 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 7),
            const SizedBox(height: 17),
            Padding(
              padding: const EdgeInsets.only(right: 28),
              child: Align(
                alignment: Alignment.centerRight,
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
                            MaterialStateProperty.all(const EdgeInsets.all(6)),
                      ),
                      child: Text('View Score',
                          style: Get.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.white))),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
