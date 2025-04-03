import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/controller/auth_controller.dart';
import '../../data/controller/scoreboard_controller.dart';
import '../../data/controller/tournament_controller.dart';
import '../../data/model/scoreboard_model.dart';
import 'score_card_screen.dart';
import 'select_opening_team.dart';
import '../../utils/date_time_helpers.dart';
import 'package:gully_app/utils/utils.dart';

import '../../data/controller/misc_controller.dart';
import '../../data/model/matchup_model.dart';
import '../../utils/app_logger.dart';
import '../theme/theme.dart';
import '../widgets/arc_clipper.dart';

class SelectMatchForScoreBoard extends GetView<TournamentController> {
  const SelectMatchForScoreBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final MiscController connectionController = Get.find<MiscController>();
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/images/sports_icon.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            ClipPath(
              clipper: ArcClipper(),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const RadialGradient(
                    colors: [
                      Color(0xff368EBF),
                      AppTheme.primaryColor,
                    ],
                    center: Alignment(-0.4, -0.8),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: AppTheme.secondaryYellowColor.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 70))
                  ],
                ),
                width: double.infinity,
              ),
            ),
            Positioned(
                child: SizedBox(
              width: Get.width,
              child: Column(
                children: [
                  AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: const Text(
                        'Select Team',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      leading: const BackButton(
                        color: Colors.white,
                      )),
                  Expanded(
                    child: !connectionController.isConnected.value
                        ? Center(
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
                          )
                        : FutureBuilder(
                            future: controller.getMatchup(controller.state!.id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return const Center(
                                  child: Text('Something went wrong'),
                                );
                              }
                              if (snapshot.data?.isEmpty ?? true) {
                                return const Center(
                                    child: Text(
                                        'No Matchup has been organized yet',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)));
                              }
                              return ListView.separated(
                                itemCount: snapshot.data?.length ?? 0,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: 10,
                                ),
                                shrinkWrap: true,
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: _MatchupCard(
                                    matchup: snapshot.data![index],
                                  ),
                                ),
                              );
                            }),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class _MatchupCard extends GetView<ScoreBoardController> {
  final MatchupModel matchup;

  const _MatchupCard({
    required this.matchup,
  });

  @override
  Widget build(BuildContext context) {
    final TournamentController tournamentController = Get.find();
    final AuthController authController = Get.find();
    final ScoreboardModel? scoreboard = matchup.scoreBoard == null
        ? null
        : ScoreboardModel.fromJson(matchup.scoreBoard!);

    return GestureDetector(
      onTap: () {
        // if (tournamentController.state?.authority != authController.state?.id) {
        //   errorSnackBar('You are not authorized to update the score board');
        //   return;
        // }
        // //logger.d"Match Authority id:${matchup.matchAuthority}");
        // //logger.d"auth  id:${authController.state?.id}");
        if (matchup.matchAuthority != authController.state?.id) {
          errorSnackBar('You are not authorized to update the score board');
          return;
        }

        // if (DateTime.now().isBefore(matchup.matchDate)) {
        //   errorSnackBar('The match has not started yet. Please wait until the scheduled date and time.');
        //   return;
        // }

        if (matchup.scoreBoard != null) {
          Get.off(() => const ScoreCardScreen());
          controller
              .setScoreBoard(ScoreboardModel.fromJson(matchup.scoreBoard!));
        } else {
          logger.i("Tournament Match: true");
          if (matchup.team1.players!.length < 11) {
            errorSnackBar(
                'Team ${matchup.team1.name} does not have enough players');
            return;
          }
          if (matchup.team2.players!.length < 11) {
            errorSnackBar(
                'Team ${matchup.team2.name} does not have enough players');
            return;
          }
          Get.off(() => const SelectOpeningTeam(
                isTournament: true,
              ));
          controller.match = MatchupModel.fromJson(matchup.toJson());

          //logger.d"The Matchup Data is ${matchup.toJson()}");
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 20,
                spreadRadius: 2,
                offset: Offset(0, 10))
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(formatDateTime('dd MMM, hh:mm a', matchup.matchDate),
                  style: Get.textTheme.labelMedium?.copyWith()),
              SizedBox(height: Get.height * 0.01),
              Row(
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                          backgroundImage: matchup.team1.logo != null &&
                                  matchup.team1.logo!.isNotEmpty
                              ? NetworkImage(matchup.team1.toImageUrl())
                              : const AssetImage('assets/images/logo.png')
                                  as ImageProvider),
                      // NetworkImage(matchup.team1.toImageUrl()),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 100,
                        child: Text(
                          matchup.team1.name,
                          style: Get.textTheme.headlineSmall?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: Get.textScaleFactor * 17,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      CircleAvatar(
                          backgroundImage: matchup.team2.logo != null &&
                                  matchup.team2.logo!.isNotEmpty
                              ? NetworkImage(matchup.team2.toImageUrl())
                              : const AssetImage('assets/images/logo.png')
                                  as ImageProvider),
                      // NetworkImage(matchup.team2.toImageUrl()),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 100,
                        child: Text(
                          matchup.team2.name,
                          style: Get.textTheme.headlineSmall?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: Get.textScaleFactor * 17,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: Get.height * 0.01),
              matchup.winningTeam != null
                  ? Center(
                      child: Text(
                          scoreboard?.secondInningsText == 'Match Tied'
                              ? "${matchup.getWinningTeamName()} Won The Match"
                              : scoreboard?.secondInningsText ?? "",
                          style: Get.textTheme.labelMedium?.copyWith()),
                    )
                  : (scoreboard?.secondInningsText?.isNotEmpty ?? false)
                      ? Center(
                          child: Text(scoreboard?.secondInningsText ?? "",
                              style: Get.textTheme.labelMedium?.copyWith()),
                        )
                      : const SizedBox.shrink(),
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
}
