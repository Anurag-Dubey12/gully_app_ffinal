import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/data/model/matchup_model.dart';
import 'package:gully_app/data/model/scoreboard_model.dart';
import 'package:gully_app/ui/screens/full_scorecard.dart';
import 'package:gully_app/ui/screens/view_tournaments_screen.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/utils/date_time_helpers.dart';
import 'package:gully_app/utils/utils.dart';

import '../../data/controller/misc_controller.dart';
import '../../utils/FallbackImageProvider.dart';
import '../../utils/app_logger.dart';
import '../theme/theme.dart';

class ScheduleScreen extends GetView<TournamentController> {
  final String? id;
  const ScheduleScreen({super.key, this.id});
  @override
  Widget build(BuildContext context) {
    final MiscController connectionController=Get.find<MiscController>();
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
                  title: Text(
                    "${controller.tournamentname.value.capitalize} Matches",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                  leading: const BackButton(
                    color: Colors.white,
                  )),
              SizedBox(height: Get.height * 0.01),
              Expanded(
                child: !connectionController.isConnected.value ? Center(
                  child: SizedBox(
                    width: Get.width,
                    height: Get.height * 0.7,
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
                ):FutureBuilder(
                  future: id != null
                      ? controller.getMatchup(id!)
                      : controller.getMatchup(controller.state!.id),
                  builder: (context, snapshot) {
                    // final sortedMatches = List<MatchupModel>.from(controller.matchups)
                    //   ..sort((a, b) {
                    //     if (a.status == "live" && b.status != "live") return -1;
                    //     if (a.status != "live" && b.status == "live") return 1;
                    //     if (a.status == "upcoming" && b.status == "ended") return -1;
                    //     if (a.status == "ended" && b.status == "upcoming") return 1;
                    //     return 0;
                    //   });
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (controller.matchups.isEmpty) {
                      return const Center(
                          child: EmptyTournamentWidget(
                              message: 'No Matchups Found'));
                    }
                    return ListView.separated(
                      itemCount: controller.matchups.length,
                      shrinkWrap: true,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: Get.height * 0.01),
                      itemBuilder: (context, index) {
                        final matchup = controller.matchups[index];
                        return MatchupCard(
                          matchup: matchup,
                          tourid: id ?? controller.state!.id,
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MatchupCard extends StatelessWidget {
  final MatchupModel matchup;
  final String? tourid;
  const MatchupCard({super.key, required this.matchup, this.tourid});

  @override
  Widget build(BuildContext context) {
    final ScoreboardModel? scoreboard = matchup.scoreBoard == null
        ? null
        : ScoreboardModel.fromJson(matchup.scoreBoard!);
    final controller = Get.find<TournamentController>();
    logger.d("The Winner id is:${matchup.getWinningTeamName()}");
    return GestureDetector(
        onTap: () {
          if (scoreboard == null) {
            errorSnackBar("Please Wait for Match to Begin");
          } else {
            Get.to(() => FullScoreboardScreen(scoreboard: scoreboard));
          }
        },
        child: scoreboard==null ? EmptyMatchScoreCard():Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        matchup.round?.capitalize ?? '',
                        style: Get.textTheme.labelMedium?.copyWith(),
                      ),
                      const Spacer(),
                      Text(
                        formatDateTime('dd MMM yyyy hh:mm a', matchup.matchDate),
                        style: Get.textTheme.labelMedium?.copyWith(),
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height * 0.01),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      teamView(
                        matchup.team1.logo ?? '',
                        matchup.team1.name,
                        scoreboard?.firstInningHistory==null
                            ? "Did Not Bat"
                            : '${scoreboard?.firstInnings?.totalScore??0}/${scoreboard?.firstInnings?.totalWickets ?? 0}',
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'VS',
                            style: Get.textTheme.bodyMedium?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      teamView(
                        matchup.team2.logo ?? '',
                        matchup.team2.name,
                        scoreboard?.currentInnings == 1
                            ? "Did Not Bat"
                            : '${scoreboard?.secondInnings?.totalScore}/${scoreboard?.secondInnings?.totalWickets ?? 0}',
                      ),
                    ],
                  ),
                  if(matchup.winningTeam!=null)
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.only(top: 8.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        scoreboard?.secondInningsText=='Match Tied' ?
                        "${matchup.getWinningTeamName()} Won The Match"??'':
                        scoreboard?.secondInningsText ?? "",
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget EmptyMatchScoreCard(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 23, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    formatDateTime('dd MMMM yyyy hh:mm a', matchup.matchDate),
                    style: Get.textTheme.labelMedium?.copyWith(),
                  ),
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
              //   child: Text(scoreboard?.secondInningsText ?? "",
              //       style: Get.textTheme.labelMedium?.copyWith()),
              // ),
            ],
          ),
        ),
      ),
    );
  }
  Widget teamView(String teamLogo, String teamName, String score) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              CircleAvatar(
                radius: 20.0,
                backgroundImage: FallbackImageProvider(
                  toImageUrl(teamLogo),
                  'assets/images/logo.png',
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  teamName.capitalize,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Text(
          score,
          style: Get.textTheme.bodyMedium?.copyWith(
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
