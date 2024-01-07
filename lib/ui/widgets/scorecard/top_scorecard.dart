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
    return Obx(() => Column(
          children: [
            Container(
              // height: 20,
              width: 140,
              decoration: const BoxDecoration(
                color: Color(0xff0FC335),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text('Inning 1',
                    textAlign: TextAlign.center,
                    style: Get.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w900, color: Colors.white)),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(children: [
                  Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Text(controller.scoreboard.value!.team1.name,
                              style: Get.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black))),
                      const Spacer(),
                      const Expanded(flex: 2, child: Text('Current Run Rate'))
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Row(
                        children: [
                          Text(
                              '${controller.scoreboard.value!.lastBall.total}-${controller.scoreboard.value!.lastBall.wicket}',
                              style: Get.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.secondaryYellowColor)),
                          Text(
                              ' (${controller.scoreboard.value!.currentOver}.${controller.scoreboard.value!.currentBall})'),
                        ],
                      ),
                      const Spacer(),
                      Text(controller.scoreboard.value!.currentRunRate
                          .toStringAsFixed(2)),
                    ],
                  )
                ]),
              ),
            ),
          ],
        ));
  }
}
