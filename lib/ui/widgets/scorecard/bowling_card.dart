import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/scoreboard_controller.dart';

class BowlingStats extends StatelessWidget {
  const BowlingStats({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Expanded(
                flex: 3,
                child: Text('Bowler', style: Get.textTheme.labelMedium)),
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
              child: Center(child: Text('M', style: Get.textTheme.labelMedium)),
            ),
            Expanded(
                child:
                    Center(child: Text('R', style: Get.textTheme.labelMedium))),
            Expanded(
                child:
                    Center(child: Text('W', style: Get.textTheme.labelMedium))),
            Expanded(
                child:
                    Center(child: Text('ER', style: Get.textTheme.labelMedium)))
          ],
        ),
      ),
      const Divider(
        height: 10,
        color: Colors.grey,
      ),
      const SizedBox(height: 3),
      const _BowlerPlayerStat(),
      const SizedBox(height: 4),
    ]);
  }
}

class _BowlerPlayerStat extends GetView<ScoreBoardController> {
  const _BowlerPlayerStat();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Expanded(
                  flex: 5,
                  child: Text(
                    controller.scoreboard.value!.bowlerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )),
              Expanded(
                  child: Center(
                      child: Text(
                          ('${controller.scoreboard.value!.bowler.currentOver}.${controller.scoreboard.value!.bowler.currentBall}'),
                          style: Get.textTheme.labelMedium))),
              Expanded(
                child: Center(
                    child: Text(
                        (controller.scoreboard.value!.bowler.maidens)
                            .toString(),
                        style: Get.textTheme.labelMedium)),
              ),
              Expanded(
                  child: Center(
                      child: Text(
                          controller.scoreboard.value!.bowler.runs.toString(),
                          style: Get.textTheme.labelMedium))),
              Expanded(
                  child: Center(
                      child: Text(
                          controller.scoreboard.value!.bowler.wickets
                              .toString(),
                          style: Get.textTheme.labelMedium))),
              Expanded(
                  child: Center(
                      child: Text(
                          controller.scoreboard.value!.bowler.economy
                              .toStringAsFixed(1),
                          style: Get.textTheme.labelMedium)))
            ],
          ),
        ));
  }
}
