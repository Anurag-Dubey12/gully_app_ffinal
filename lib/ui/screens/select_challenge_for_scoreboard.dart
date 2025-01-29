import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/scoreboard_controller.dart';
import 'package:gully_app/data/model/challenge_match.dart';
import 'package:gully_app/data/model/matchup_model.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:intl/intl.dart';

import '../../data/controller/team_controller.dart';
import '../../data/model/scoreboard_model.dart';
import '../../utils/utils.dart';
import 'score_card_screen.dart';
import 'select_opening_team.dart';

class SelectChallengeForScoreboard extends StatefulWidget {
  const SelectChallengeForScoreboard({super.key});

  @override
  State<SelectChallengeForScoreboard> createState() =>
      _SelectChallengeForScoreboardState();
}

class _SelectChallengeForScoreboardState
    extends State<SelectChallengeForScoreboard> {
  @override
  Widget build(BuildContext context) {
    final ScoreBoardController controller = Get.find<ScoreBoardController>();
    final TeamController teamController = Get.find<TeamController>();

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/images/sports_icon.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: GradientBuilder(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              // flexibleSpace: ClipRect(
              //   child: BackdropFilter(
              //     filter: ImageFilter.blur(sigmaX: 30,sigmaY: 10),
              //     child: Container(color: Colors.transparent,),
              //   ),
              // ),
              backgroundColor: const Color(0xff3F5BBF),
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              title: const Text('Challenged Teams',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            body: Padding(
              padding: const EdgeInsets.all(18.0),
              child: FutureBuilder<List<ChallengeMatchModel>>(
                  future: teamController.getChallengeMatch(),
                  builder: (context, snapshot) {
                    final acceptedChallenges = snapshot.data
                        ?.where((e) => e.status == 'Accepted')
                        .toList();
                    logger.f('Accepted Challenges: $acceptedChallenges');
                    return ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: ((context, index) {
                          return ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              tileColor: Colors.white,
                              title: Text(
                                  '${acceptedChallenges![index].team1.name.capitalize}  vs ${acceptedChallenges[index].team2.name.capitalize}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                              minVerticalPadding: 4,
                              subtitle: Text(
                                DateFormat('dd-MMM-yyyy')
                                    .format(acceptedChallenges[index].createdAt!),
                                style: const TextStyle(
                                  color: AppTheme.darkYellowColor,
                                  fontSize: 13,
                                ),
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  if (acceptedChallenges[index].scoreBoard !=
                                      null) {
                                    controller.setScoreBoard(
                                        ScoreboardModel.fromJson(
                                            acceptedChallenges[index]
                                                .scoreBoard!));
                                    Get.off(() => const ScoreCardScreen());
                                  } else {
                                    logger.i(acceptedChallenges[index].id);
                                    controller.match = MatchupModel.fromJson({
                                      'dateTime': acceptedChallenges[index]
                                          .createdAt!
                                          .toIso8601String(),
                                      'team1': acceptedChallenges[index]
                                          .team1
                                          .toJson(),
                                      'team2': acceptedChallenges[index]
                                          .team2
                                          .toJson(),
                                      'tournamentName': null,
                                      'tournamentId': null,
                                      'scoreBoard': null,
                                      '_id': acceptedChallenges[index].id,
                                    });
                                    if (acceptedChallenges[index]
                                        .team1
                                        .players!
                                        .length <
                                        11) {
                                      errorSnackBar(
                                          'Team ${acceptedChallenges[index].team1.name} does not have enough players');

                                      return;
                                    }

                                    if (acceptedChallenges[index]
                                        .team2
                                        .players!
                                        .length <
                                        11) {
                                      errorSnackBar(
                                          'Team ${acceptedChallenges[index].team2.name} does not have enough players');
                                      return;
                                    }
                                    Get.off(
                                            () => const SelectOpeningTeam(
                                          isTournament: false,
                                        ),
                                        preventDuplicates: false);
                                  }
                                },
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: AppTheme.darkYellowColor,
                                ),
                              ));
                        }),
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 20,
                        ),
                        itemCount: acceptedChallenges?.length ?? 0);
                  }),
            )),
      ),
    );
  }

}
