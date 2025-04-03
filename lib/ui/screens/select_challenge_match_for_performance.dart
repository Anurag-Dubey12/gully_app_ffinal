import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/challenge_match.dart';
import 'package:gully_app/ui/screens/challenge_performance_stat_screen.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:intl/intl.dart';

import '../../data/controller/team_controller.dart';

class SelectChallengeMatchForPerformance extends StatefulWidget {
  const SelectChallengeMatchForPerformance({super.key});

  @override
  State<SelectChallengeMatchForPerformance> createState() =>
      _SelectChallengeMatchForPerformanceState();
}

class _SelectChallengeMatchForPerformanceState
    extends State<SelectChallengeMatchForPerformance> {
  @override
  Widget build(BuildContext context) {
    final TeamController teamController = Get.find<TeamController>();
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
                  // final acceptedChallenges = snapshot.data
                  //     ?.where((e) => e.status == 'played')
                  //     .toList();
                  //logger.d"Launched challenge");
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // if (snapshot.hasError) {
                  //   //logger.e(snapshot.error);
                  //   return const Center(
                  //     child: Text('Something went wrong'),
                  //   );
                  // }
                  final challenges = snapshot.data ?? [];
                  if (challenges.isEmpty) {
                    return const Center(
                      child: Text('No matches played yet'),
                    );
                  }
                  return ListView.separated(
                      itemBuilder: ((context, index) {
                        return ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            tileColor: Colors.white,
                            title: Text(
                                '${challenges[index].team1.name.capitalize} vs ${challenges[index].team2.name.capitalize}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                )),
                            minVerticalPadding: 4,
                            subtitle: Text(
                              DateFormat('dd-MMM-yyyy')
                                  .format(challenges[index].createdAt!),
                              style: const TextStyle(
                                color: AppTheme.darkYellowColor,
                                fontSize: 13,
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                //logger.d"Selected match ID: ${challenges[index].id}");
                                Get.to(() => ChallengePerformanceStatScreen(
                                      match: challenges[index],
                                    ));
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
                      itemCount: challenges.length);
                }),
          )),
    );
  }
}
