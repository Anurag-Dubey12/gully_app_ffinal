import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/scoreboard_controller.dart';
import 'package:gully_app/data/model/bowling_model.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/ui/widgets/scorecard/batting_card.dart';

import '../../data/model/player_model.dart';

class FullScoreboardScreen extends StatefulWidget {
  const FullScoreboardScreen({super.key});

  @override
  State<FullScoreboardScreen> createState() => _FullScoreboardScreenState();
}

class _FullScoreboardScreenState extends State<FullScoreboardScreen> {
  int currentInning = 1;
  List<PlayerModel> battingTeamPlayers = [];
  List<PlayerModel> bowlingTeam = [];
  @override
  initState() {
    super.initState();
    final controller = Get.find<ScoreBoardController>();
    battingTeamPlayers =
        controller.scoreboard.value?.firstInnings?.battingTeam.players ?? [];
    bowlingTeam =
        controller.scoreboard.value?.firstInnings?.bowlingTeam.players ?? [];
  }

  void changeInning(int selected) {
    final controller = Get.find<ScoreBoardController>();
    setState(() {
      currentInning = selected;
      battingTeamPlayers = currentInning == 1
          ? controller.scoreboard.value?.firstInnings?.battingTeam.players ?? []
          : controller.scoreboard.value?.secondInnings?.battingTeam.players ??
              [];
      bowlingTeam = currentInning == 1
          ? controller.scoreboard.value?.firstInnings?.bowlingTeam.players ?? []
          : controller.scoreboard.value?.secondInnings?.bowlingTeam.players ??
              [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final ScoreBoardController controller = Get.find<ScoreBoardController>();
    return GradientBuilder(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Full Scoreboard',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  // const Spacer(),
                  Expanded(
                    flex: 3,
                    child: GestureDetector(
                      onTap: () {
                        changeInning(1);
                      },
                      child: Container(
                        height: 43,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: currentInning == 1
                              ? AppTheme.darkYellowColor
                              : Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Text(
                                  controller.scoreboard.value!.team1.name,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: currentInning == 1
                                          ? Colors.white
                                          : Colors.black))),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    flex: 3,
                    child: GestureDetector(
                      onTap: () {
                        changeInning(2);
                      },
                      child: Container(
                        height: 43,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: currentInning == 2
                              ? AppTheme.darkYellowColor
                              : Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child:
                                  Text(controller.scoreboard.value!.team2.name,
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: currentInning == 2
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ))),
                        ),
                      ),
                    ),
                  ),

                  // const Spacer(),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 3,
                                        child: GestureDetector(
                                            child: Text('Batsmans',
                                                style: Get
                                                    .textTheme.labelMedium))),
                                    const Spacer(
                                      flex: 1,
                                    ),
                                    Expanded(
                                        child: Center(
                                            child: Text('R',
                                                style: Get
                                                    .textTheme.labelMedium))),
                                    Expanded(
                                      child: Center(
                                          child: Text('B',
                                              style:
                                                  Get.textTheme.labelMedium)),
                                    ),
                                    Expanded(
                                        child: Center(
                                            child: Text('4s',
                                                style: Get
                                                    .textTheme.labelMedium))),
                                    Expanded(
                                        child: Center(
                                            child: Text('6s',
                                                style: Get
                                                    .textTheme.labelMedium))),
                                    Expanded(
                                        child: Center(
                                            child: Text('SR',
                                                style:
                                                    Get.textTheme.labelMedium)))
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 10,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 4),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                separatorBuilder: (c, i) => const SizedBox(
                                  height: 10,
                                ),
                                itemCount: battingTeamPlayers.length,
                                itemBuilder: ((context, index) {
                                  return BatterPlayerStat(
                                      battingTeamPlayers[index], false);
                                }),
                              ),
                              const Divider(
                                height: 20,
                              ),
                              Column(children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 3,
                                          child: Text('Bowler',
                                              style:
                                                  Get.textTheme.labelMedium)),
                                      const Spacer(
                                        flex: 2,
                                      ),
                                      Expanded(
                                          child: Center(
                                        child: Text(
                                          'O',
                                          style: Get.textTheme.labelMedium,
                                        ),
                                      )),
                                      Expanded(
                                        child: Center(
                                            child: Text('M',
                                                style:
                                                    Get.textTheme.labelMedium)),
                                      ),
                                      Expanded(
                                          child: Center(
                                              child: Text('R',
                                                  style: Get
                                                      .textTheme.labelMedium))),
                                      Expanded(
                                          child: Center(
                                              child: Text('W',
                                                  style: Get
                                                      .textTheme.labelMedium))),
                                      Expanded(
                                          child: Center(
                                              child: Text('ER',
                                                  style: Get
                                                      .textTheme.labelMedium)))
                                    ],
                                  ),
                                ),
                                const Divider(
                                  height: 10,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 3),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  separatorBuilder: (c, i) => const SizedBox(
                                    height: 10,
                                  ),
                                  itemCount: bowlingTeam.length,
                                  itemBuilder: ((context, index) {
                                    return ScoreboardBowlerPlayerStat(
                                      bowlingTeam[index],
                                    );
                                  }),
                                ),
                                const SizedBox(height: 4),
                              ])
                            ]),
                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ScoreboardBowlerPlayerStat extends GetView<ScoreBoardController> {
  final PlayerModel bowler;
  const ScoreboardBowlerPlayerStat(this.bowler, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
              flex: 5,
              child: Text(
                bowler.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
          Expanded(
              child: Center(
                  child: Text((getCurrentBowl(bowler.bowling!)),
                      style: Get.textTheme.labelMedium))),
          Expanded(
            child: Center(
                child: Text((bowler.bowling?.maidens ?? "").toString(),
                    style: Get.textTheme.labelMedium)),
          ),
          Expanded(
              child: Center(
                  child: Text(bowler.bowling?.runs.toString() ?? "",
                      style: Get.textTheme.labelMedium))),
          Expanded(
              child: Center(
                  child: Text(bowler.bowling?.wickets.toString() ?? "0",
                      style: Get.textTheme.labelMedium))),
          Expanded(
              child: Center(
                  child: Text(
                      bowler.bowling?.economy.toStringAsFixed(1) ?? "N/A",
                      style: Get.textTheme.labelMedium)))
        ],
      ),
    );
  }
}

String getCurrentBowl(BowlingModel bowling) {
  if (bowling.overs.length == 1) {
    return '0.0';
  }

  if (bowling.currentBall == 0 && bowling.overs.entries.last.value.ball != 6) {
    return '${bowling.currentOver}.${bowling.overs.entries.last.value.ball}';
  }
  return '${bowling.currentOver}.${bowling.currentBall}';
}
