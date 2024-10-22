import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/scoreboard_controller.dart';
import 'package:gully_app/data/model/matchup_model.dart';
import 'package:gully_app/ui/screens/full_scorecard.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:gully_app/ui/widgets/scorecard/current_over_card.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../utils/app_logger.dart';
import '../../screens/home_screen.dart';

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
      controller.connectToSocket(hideDialog: true);
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
                  Get.close();
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
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Obx(() => Text(
                                'Current Innings: ${controller.scoreboard.value?.currentInnings}')),
                            SizedBox(
                              width: Get.width,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(100),
                                              child: widget.match.team1.logo != null && widget.match.team1.logo!.isNotEmpty
                                                  ? Image.network(
                                                widget.match.team1.toImageUrl(),
                                                height: 50,
                                                fit: BoxFit.cover,
                                                width: 50,
                                              )
                                                  : Image.asset(
                                                "assets/images/logo.png",
                                                height: 50,
                                                fit: BoxFit.cover,
                                                width: 50,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Obx((){
                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: AppTheme
                                                      .secondaryYellowColor,
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      '${controller.scoreboard.value?.firstInningHistory.entries.lastOrNull?.value.total ?? 0}/${controller.scoreboard.value?.firstInningHistory.entries.lastOrNull?.value.wickets ?? 0}',
                                                    style: Get.textTheme.headlineMedium?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      fontSize: 12
                                                    ),
                                                  ),
                                                ),
                                              );
                                              // if (controller.scoreboard.value?.currentInnings == 1)
                                              //   BlinkingText(
                                              //     text: 'Batting',
                                              //     style: TextStyle(
                                              //       color: Colors.green,
                                              //       fontWeight: FontWeight.bold,
                                              //       fontSize: 10,
                                              //     ),
                                              //   );
                                            })
                                          ],
                                        ),
                                        Text(
                                          widget.match.team1.name,
                                          overflow: TextOverflow.ellipsis,
                                          style: Get.textTheme.headlineMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            // color: controller.scoreboard.value?.currentInnings==2 ? Colors.grey :Colors.black,
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 30),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            controller.scoreboard.value?.secondInnings==null ? const Text("DNB",style: TextStyle(
                                              color: Colors.grey
                                            ),) :
                                            Obx((){
                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: AppTheme
                                                      .secondaryYellowColor,
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      '${controller.scoreboard.value?.secondInningHistory.entries.lastOrNull?.value.total ?? 0}/${controller.scoreboard.value?.secondInningHistory.entries.lastOrNull?.value.wickets ?? 0}',
                                                    style: Get.textTheme.headlineMedium?.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      fontSize: 12
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                            const SizedBox(width: 10),
                                            ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(100),
                                              child: SizedBox(
                                                height: 50,
                                                width: 50,
                                                child:widget.match.team2.logo != null && widget.match.team2.logo!.isNotEmpty
                                                    ? Image.network(
                                                  widget.match.team2.toImageUrl(),
                                                  height: 50,
                                                  fit: BoxFit.cover,
                                                  width: 50,
                                                )
                                                    : Image.asset(
                                                  "assets/images/logo.png",
                                                  height: 50,
                                                  fit: BoxFit.cover,
                                                  width: 50,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              widget.match.team2.name,
                                              style: Get.textTheme.headlineMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        // controller.scoreboard.value
                                        //     ?.currentInnings ==
                                        //     1
                                        //     ? const SizedBox()
                                        //     : Container(
                                        //   decoration: BoxDecoration(
                                        //     color: AppTheme
                                        //         .secondaryYellowColor,
                                        //     borderRadius:
                                        //     BorderRadius.circular(10),
                                        //   ),
                                        //   child: Padding(
                                        //     padding:
                                        //     const EdgeInsets.all(8.0),
                                        //     child: Text(
                                        //       '${controller.scoreboard.value?.firstInningHistory.entries.last.value.total}/${controller.scoreboard.value?.firstInningHistory.entries.last.value.wickets}',
                                        //       style: Get.textTheme
                                        //           .headlineMedium
                                        //           ?.copyWith(
                                        //         fontWeight:
                                        //         FontWeight.bold,
                                        //         color: Colors.white,
                                        //         fontSize: 14,
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: Column(children: [
                                Text(
                                    'Over: ${controller.scoreboard.value?.currentOver}.${controller.scoreboard.value?.currentBall}'),
                                // const Text('To win: '),
                              ]),
                            ),
                            Obx(() => Text(
                              controller.scoreboard.value
                                  ?.secondInningsText ??
                                  '',
                            )),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset('assets/images/bat.png', height: 12),
                                          const SizedBox(width: 3),
                                          const Text('Striker: ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                                          Expanded(
                                            child: Text(
                                              '${controller.scoreboard.value?.striker.name}',
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(fontSize: 13),
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(width: 15),
                                          const Text('Runs: ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                                          Text('${controller.scoreboard.value?.striker.batting?.runs}', style: const TextStyle(fontSize: 13))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(width: 15),
                                          const Text('SR: ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
                                          Text('${controller.scoreboard.value?.striker.batting?.strikeRate.toStringAsFixed(2)}', style: const TextStyle(fontSize: 13))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 1),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset('assets/images/bat.png', height: 12),
                                          const SizedBox(width: 3),
                                          const Text('Non Striker: ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                                          Expanded(
                                            child: Text(
                                              '${controller.scoreboard.value?.nonstriker.name}',
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(fontSize: 13),
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(width: 15),
                                          const Text('Runs: ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                                          Text('${controller.scoreboard.value?.nonstriker.batting?.runs}', style: const TextStyle(fontSize: 13))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(width: 15),
                                          const Text('SR: ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                                          Text('${controller.scoreboard.value?.nonstriker.batting?.strikeRate.toStringAsFixed(2)}', style: const TextStyle(fontSize: 13))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Image.asset('assets/images/ball.png',
                                    height: 14),
                                const SizedBox(width: 5),
                                const Text('Bowler :  ',
                                    style:
                                    TextStyle(fontWeight: FontWeight.w500)),
                                Text(
                                    '${controller.scoreboard.value?.bowler.name}'),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const CurrentOverStats(),
                            const SizedBox(
                              height: 10,
                            ),
                            PrimaryButton(
                              onTap: () {
                                Get.to(() => const FullScoreboardScreen());
                              },
                              title: 'View Scorecard ',
                            ),
                            //Temporary code for testing ads
                            // Padding(
                            //   padding: const EdgeInsets.all(16.0),
                            //   child: Image.asset(
                            //     images[currentImageIndex],
                            //     height: 100,
                            //     width: Get.width,
                            //     fit: BoxFit.fill,
                            //   ),
                            // ),
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