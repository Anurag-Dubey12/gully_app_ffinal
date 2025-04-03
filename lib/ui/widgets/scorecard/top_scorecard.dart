import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/controller/scoreboard_controller.dart';
import '../../theme/theme.dart';

class ScoreCard extends GetView<ScoreBoardController> {
  const ScoreCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Obx(() => Column(
            children: [
              Container(
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SizedBox(
                    width: Get.width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: Get.width / 1.7,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                            controller.scoreboard.value!
                                                        .currentInnings ==
                                                    1
                                                ? controller.scoreboard.value!
                                                    .team1.name.capitalize
                                                : controller.scoreboard.value!
                                                    .team2.name.capitalize,
                                            style: Get.textTheme.headlineMedium
                                                ?.copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18 *
                                                        Get.textScaleFactor,
                                                    color: Colors.black),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          )),
                                      const Spacer(),
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                            'Current Run Rate',
                                            style: TextStyle(
                                              fontSize:
                                                  12 * Get.textScaleFactor,
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Text(controller
                                //         .scoreboard.value?.secondInningsText ??
                                //     "NUll"),
                                SizedBox(
                                  width: Get.width / 2,
                                  height: 30,
                                  child: Row(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '${controller.scoreboard.value!.lastBall.total}-${controller.scoreboard.value!.lastBall.wickets}',
                                            style: Get.textTheme.headlineMedium
                                                ?.copyWith(
                                                    fontWeight: FontWeight.w900,
                                                    color: AppTheme
                                                        .secondaryYellowColor),
                                          ),
                                          Text(
                                              ' (${controller.scoreboard.value!.currentOver}.${controller.scoreboard.value!.currentBall})'),
                                        ],
                                      ),
                                      const Spacer(),
                                      Text(controller.scoreboard.value!
                                              .currentRunRate.isInfinite
                                          ? '0.0'
                                          : controller
                                              .scoreboard.value!.currentRunRate
                                              .toStringAsFixed(2)),
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                        controller.scoreboard.value?.currentInnings == 1
                            ? const SizedBox()
                            : Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const FittedBox(
                                              child: Text('Innings 1'),
                                            ),
                                            const SizedBox(height: 15),
                                            Text(
                                              "${controller.scoreboard.value!.firstInnings?.totalScore.toString() ?? ""}/${controller.scoreboard.value!.firstInnings?.ballRecord?.entries.last.value.wickets.toString() ?? ""}",
                                              style: Get
                                                  .textTheme.headlineMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: AppTheme
                                                          .secondaryYellowColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
