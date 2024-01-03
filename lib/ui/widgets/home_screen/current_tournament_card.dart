import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/ui/widgets/home_screen/no_tournament_card.dart';

import '../../../data/model/tournament_model.dart';
import '../../../utils/date_time_helpers.dart';
import '../../theme/theme.dart';
import '../dialogs/current_score_dialog.dart';

class CurrentTournamentCard extends GetView<TournamentController> {
  const CurrentTournamentCard({
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
              itemCount: controller.tournamentList.length,
              shrinkWrap: true,
              itemBuilder: (context, snapshot) {
                return _Card(
                  tournament: controller.tournamentList[snapshot],
                );
              });
        }
      }),
    );
  }
}

class _Card extends StatelessWidget {
  final TournamentModel tournament;
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
              scale: 1),
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
              tournament.tournamentName,
              style: Get.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppTheme.darkYellowColor),
            ),
            const SizedBox(height: 7),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date: ${formatDateTime('dd MMM yyy', tournament.tournamentStartDateTime)}',
                    style: Get.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'Time Left: 5d:13h:5m:23s',
                    style: Get.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
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
                        Get.bottomSheet(const ScoreBottomDialog());
                      },
                      style: ButtonStyle(
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(6)),
                      ),
                      child: Text('View Score',
                          style: Get.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w300,
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
