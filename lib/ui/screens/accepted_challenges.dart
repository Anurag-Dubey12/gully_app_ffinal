import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/challenge_match.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:intl/intl.dart';

import '../../data/controller/auth_controller.dart';
import '../../data/controller/team_controller.dart';
import 'view_opponent_team.dart';

class AcceptedChallenges extends StatefulWidget {
  const AcceptedChallenges({super.key});

  @override
  State<AcceptedChallenges> createState() => _AcceptedChallengesState();
}

class _AcceptedChallengesState extends State<AcceptedChallenges> {
  @override
  Widget build(BuildContext context) {
    final TeamController teamController = Get.find<TeamController>();
    final authController = Get.find<AuthController>();
    return GradientBuilder(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
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
                      itemBuilder: ((context, index) {
                        return ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            tileColor: Colors.white,
                            title: Text(
                                '${acceptedChallenges![index].team1.name.capitalize} vs ${acceptedChallenges[index].team2.name.capitalize}',
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
                                Get.to(() => ViewOpponentTeam(
                                    team: authController.state?.id ==
                                            acceptedChallenges[index]
                                                .challengedBy
                                        ? acceptedChallenges[index].team2
                                        : acceptedChallenges[index].team1));
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
    );
  }
}
