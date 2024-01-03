import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/date_time_helpers.dart';

import 'current_tournament_card.dart';
import 'future_tournament_card.dart';
import 'past_tournament_card.dart';

class TournamentList extends StatefulWidget {
  final int selectedDate;
  const TournamentList({super.key, required this.selectedDate});

  @override
  State<TournamentList> createState() => _TournamentListState();
}

class _TournamentListState extends State<TournamentList> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TournamentController>();
    return Container(
      width: Get.width,
      height: Get.height * 0.54,
      margin: const EdgeInsets.only(top: 10),
      color: Colors.black26,
      child: SingleChildScrollView(
        child: Obx(() {
          if (isDateTimeToday(controller.selectedDate.value)) {
            logger.i('isDateTimeToday ${controller.selectedDate.value}');
            return const CurrentTournamentCard();
          } else if (isDateTimeInPast(controller.selectedDate.value)) {
            logger.i('isDateTimeInPast ${controller.selectedDate.value}');
            return const PastTournamentMatchCard();
          } else {
            return const FutureTournamentCard();
          }
        }),
      ),
    );
  }
}
