import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/scoreboard_controller.dart';

class BowlingStats extends StatelessWidget {
  const BowlingStats({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  child: Text('Bowler', style: Get.textTheme.labelMedium)),
              const Spacer(
                flex: 3,
              ),
              Expanded(
                  child: Center(
                      child: Text('O', style: Get.textTheme.labelMedium))),
              Expanded(
                child:
                    Center(child: Text('M', style: Get.textTheme.labelMedium)),
              ),
              Expanded(
                  child: Center(
                      child: Text('R', style: Get.textTheme.labelMedium))),
              Expanded(
                  child: Center(
                      child: Text('W', style: Get.textTheme.labelMedium))),
              Expanded(
                  child: Center(
                      child: Text('ER', style: Get.textTheme.labelMedium)))
            ],
          ),
          const Divider(
            height: 10,
            color: Colors.grey,
          ),
          const SizedBox(height: 10),
          const _BowlerPlayerStat(),
          const SizedBox(height: 10),
        ]),
      ),
    );
  }
}

class _BowlerPlayerStat extends GetView<ScoreBoardController> {
  const _BowlerPlayerStat();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          children: [
            Expanded(
                flex: 3, child: Text(controller.scoreboard.value!.bowler.name)),
            const Spacer(
              flex: 3,
            ),
            Expanded(
                child: Center(
                    child: Text(
                        (controller.scoreboard.value!.bowler.bowling.overs)
                            .toStringAsFixed(1),
                        style: Get.textTheme.labelMedium))),
            Expanded(
              child: Center(
                  child: Text(
                      (controller.scoreboard.value!.bowler.bowling.maidens)
                          .toString(),
                      style: Get.textTheme.labelMedium)),
            ),
            Expanded(
                child: Center(
                    child: Text(
                        controller.scoreboard.value!.bowler.bowling.runs
                            .toString(),
                        style: Get.textTheme.labelMedium))),
            Expanded(
                child: Center(
                    child: Text(
                        controller.scoreboard.value!.bowler.bowling.wickets
                            .toString(),
                        style: Get.textTheme.labelMedium))),
            Expanded(
                child: Center(
                    child: Text(
                        controller.scoreboard.value!.bowler.batting.strikeRate
                            .toStringAsFixed(1),
                        style: Get.textTheme.labelMedium)))
          ],
        ));
  }
}
