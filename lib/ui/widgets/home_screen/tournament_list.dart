import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/utils/date_time_helpers.dart';

import 'current_tournament_card.dart';
import 'future_tournament_card.dart';
import 'past_tournament_card.dart';

class TournamentList extends StatefulWidget {

  const TournamentList({
    Key? key,
  }) : super(key: key);

  @override
  State<TournamentList> createState() => _TournamentListState();
}

class _TournamentListState extends State<TournamentList> {
  @override
  void initState() {
    super.initState();
    final controller = Get.find<TournamentController>();
    controller.getTournamentList();
  }
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TournamentController>();
    return SizedBox(
        width: Get.width,
        // height: 270,
        // color: Colors.black26,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              heightFactor: 5,
              child: CircularProgressIndicator(),
            );
          }
          Widget tournamentWidget;
          if ((isDateTimeToday(controller.selectedDate.value) ||
              controller.filter.value == 'current') &&
              controller.filter.value != 'upcoming' &&
              controller.filter.value != 'past') {
            log('Show Current Tournament Card');
             tournamentWidget = const CurrentTournamentCard();
          } else if ((isDateTimeInPast(controller.selectedDate.value) ||
              controller.filter.value == 'past') &&
              controller.filter.value != 'upcoming') {
            log('Show Past Tournament Card');
            tournamentWidget = const PastTournamentMatchCard();
          } else {
            log('Show Future Tournament Card');
            tournamentWidget = const FutureTournamentCard();
          }
          return Column(
            children: [
              tournamentWidget,
            ],
          );
        }),
    );
  }
}