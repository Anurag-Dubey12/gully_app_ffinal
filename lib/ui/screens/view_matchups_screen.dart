import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/data/model/matchup_model.dart';
import 'package:gully_app/data/model/scoreboard_model.dart';
import 'package:gully_app/ui/screens/full_scorecard.dart';
import 'package:gully_app/ui/screens/view_tournaments_screen.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/utils/date_time_helpers.dart';
import 'package:gully_app/utils/utils.dart';

import '../../data/controller/misc_controller.dart';
import '../../utils/app_logger.dart';
import 'current_tournament_list.dart';
import 'organize_match.dart';

class ViewMatchupsScreen extends GetView<TournamentController> {
  final String? id;
  final bool isSchedule;

  const ViewMatchupsScreen({super.key, this.id, required this.isSchedule});

  @override
  Widget build(BuildContext context) {
    final MiscController connectionController = Get.find<MiscController>();

    return GradientBuilder(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          width: Get.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text(
                  'Matchups',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: const BackButton(
                  color: Colors.white,
                ),
              ),
              SizedBox(height: Get.height * 0.01),
              Expanded(
                child: FutureBuilder(
                  future: id != null
                      ? controller.getMatchup(id!)
                      : controller.getMatchup(controller.state!.id),
                  builder: (context, snapshot) {
                    // Error handling
                    if (snapshot.hasError && connectionController.isConnected.value) {
                      return const Center(child: Text('Something went wrong'));
                    }

                    // No matchups found state
                    if (controller.matchups.isEmpty) {
                      return const Center(
                        child: EmptyTournamentWidget(
                          message: 'No Matchups Found',
                        ),
                      );
                    }

                    // Handling when connection is lost
                    return Obx(() {
                      if (!connectionController.isConnected.value) {
                        return Center(
                          child: SizedBox(
                            width: Get.width,
                            height: Get.height,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.signal_wifi_off,
                                  size: 48,
                                  color: Colors.black54,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No internet connection',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // Display the list of matchups when data is fetched
                      return ListView.separated(
                        itemCount: controller.matchups.length,
                        shrinkWrap: true,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: Get.height * 0.01),
                        itemBuilder: (context, index) {
                          final matchup = controller.matchups[index];
                          return MatchupCard(
                            matchup: matchup,
                            isSchedule: isSchedule,
                            tourid: id ?? controller.state!.id,
                          );
                        },
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class MatchupCard extends StatelessWidget {
  final MatchupModel matchup;
  final bool isSchedule;
  final bool isinfo;
  final String? tourid;
  const MatchupCard({super.key,
    required this.matchup,
    this.isSchedule=false,
    this.isinfo=false,
    this.tourid,
  });

  @override
  Widget build(BuildContext context) {
    final ScoreboardModel? scoreboard = matchup.scoreBoard == null
        ? null
        : ScoreboardModel.fromJson(matchup.scoreBoard!);
    final controller=Get.find<TournamentController>();

    logger.d("The Winner id is:${matchup.getWinningTeamName()}");
    return GestureDetector(
      onTap:(){
        if(isSchedule){
          if(scoreboard==null){
            errorSnackBar("Please Wait for Match to Begin");
          }else{
            Get.to(()=>FullScoreboardScreen(scoreboard: scoreboard));
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding:  isinfo ?
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10) :
            const EdgeInsets.symmetric(horizontal: 23, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(isSchedule)SizedBox(height: Get.height * 0.005),
                Row(
                  children: [
                    Text(
                      formatDateTime('dd MMMM yyyy hh:mm a', matchup.matchDate),
                      style: Get.textTheme.labelMedium?.copyWith(),
                    ),
                    const Spacer(),
                    if(isSchedule==false)...[
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                        onPressed: () {
                         Get.off(() => SelectOrganizeTeam(
                            match: matchup,
                            round:matchup.round ??'',
                            tourId: matchup.tournament,
                          ));
                          logger.d("The Passing Data Is ${matchup.tournament} and team 1 is ${matchup.team1.name}");
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                        onPressed: () async {
                          Get.dialog(
                            AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              title: const Row(
                                children: [
                                  Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
                                  SizedBox(width: 8),
                                  Text(
                                    "Confirm Deletion",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                  ),
                                ],
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Are you sure you want to delete this match between ${matchup.team1.name} and ${matchup.team2.name}?",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "This action cannot be undone!",
                                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              actionsAlignment: MainAxisAlignment.spaceEvenly,
                              actions: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade300,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 0,
                                  ),
                                  onPressed: () => Get.close(),
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 0,
                                  ),
                                  onPressed: () async {
                                    Get.close();
                                    logger.d("The matchup id is ${matchup.id}");
                                    final isDeleted = await controller.deleteMatch(matchup.id);

                                    if (isDeleted) {
                                      successSnackBar("Your match has been deleted",isback: true);
                                    } else {
                                      errorSnackBar("Something went wrong");
                                    }
                                  },
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
                SizedBox(height: Get.height * 0.01),
                Row(
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                            backgroundImage:
                            matchup.team1.logo!=null && matchup.team1.logo!.isNotEmpty ?
                            NetworkImage(matchup.team1.toImageUrl()) : const AssetImage('assets/images/logo.png') as ImageProvider),
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
                        const SizedBox(
                          height: 20,
                        ),
                        Chip(
                            label: Text('VS',
                                style: Get.textTheme.labelLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            backgroundColor: AppTheme.secondaryYellowColor,
                            side: BorderSide.none),
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
                            backgroundImage:
                            matchup.team2.logo!=null && matchup.team2.logo!.isNotEmpty ?
                            NetworkImage(matchup.team2.toImageUrl()) : const AssetImage('assets/images/logo.png') as ImageProvider),
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
                // Center(
                //   child: Text("${matchup.getWinningTeamName()} Won the Match" ?? "",
                //       style: Get.textTheme.labelMedium?.copyWith()),
                // ),
                Center(
                  child: Text(scoreboard?.secondInningsText ?? "",
                      style: Get.textTheme.labelMedium?.copyWith()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
