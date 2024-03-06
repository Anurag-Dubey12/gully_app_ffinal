import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/scoreboard_controller.dart';
import 'package:gully_app/data/model/matchup_model.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../scorecard/batting_card.dart';

class ScoreBottomDialog extends StatefulWidget {
  final MatchupModel match;
  const ScoreBottomDialog({
    super.key,
    required this.match,
  });

  @override
  State<ScoreBottomDialog> createState() => _ScoreBottomDialogState();
}

class _ScoreBottomDialogState extends State<ScoreBottomDialog> {
  late io.Socket socket;

  bool isLoading = true;
  Future getMatchScoreboard() async {
    final sb = await Get.find<ScoreBoardController>()
        .getMatchScoreboard(widget.match.id);
    setState(() {
      isLoading = false;
    });
    final controller = Get.find<ScoreBoardController>();
    if (sb != null) {
      controller.setScoreBoard(sb);
      controller.connectToSocket();
    }
  }

  @override
  void initState() {
    getMatchScoreboard();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    final controller = Get.find<ScoreBoardController>();
    controller.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScoreBoardController>();

    if (isLoading) {
      return SizedBox(
          height: Get.height * 0.4,
          child: const Center(child: CircularProgressIndicator()));
    } else if (controller.scoreboard.value == null) {
      return SizedBox(
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.match.tournamentName ?? '',
                style: Get.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 225, 222, 236),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Text('Match not started yet',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16,
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              PrimaryButton(
                onTap: () {
                  Get.back();
                },
                title: 'Go back',
              )
            ],
          ),
        ),
      );
    } else {
      return Container(
        width: Get.width,
        // height: Get.height * 0.8,
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 7,
                  width: 120,
                  decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Obx(
                () => Column(
                  children: [
                    Text(
                      widget.match.tournamentName ?? '',
                      style: Get.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 23,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 225, 222, 236),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            Obx(() => Text(
                                'Current Innings: ${controller.scoreboard.value?.currentInnings}')),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.network(
                                        widget.match.team1.toImageUrl(),
                                        height: 50,
                                        fit: BoxFit.cover,
                                        width: 50,
                                      ),
                                    ),
                                    Text(
                                      widget.match.team1.name,
                                      style: Get.textTheme.headlineMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                Obx(() => Text(
                                    '${controller.scoreboard.value!.lastBall.total.toString()}/${controller.scoreboard.value?.lastBall.wickets.toString()}',
                                    style:
                                        Get.textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                      fontSize: 28,
                                    ))),
                                Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.network(
                                        widget.match.team2.toImageUrl(),
                                        height: 50,
                                        fit: BoxFit.cover,
                                        width: 50,
                                      ),
                                    ),
                                    Text(
                                      widget.match.team2.name,
                                      style: Get.textTheme.headlineMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Center(
                              child: Column(children: [
                                Text(
                                    'Over: ${controller.scoreboard.value?.currentOver}.${controller.scoreboard.value?.currentBall}'),
                                // const Text('To win: '),
                              ]),
                            ),
                            const BattingStats()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }
  }
}
