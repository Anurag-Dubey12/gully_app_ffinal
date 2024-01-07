import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/scoreboard_controller.dart';

import '../../../data/model/player_model.dart';

class BattingStats extends GetView<ScoreBoardController> {
  const BattingStats({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
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
                      child: GestureDetector(
                          child: Text('Batsman',
                              style: Get.textTheme.labelMedium))),
                  const Spacer(
                    flex: 3,
                  ),
                  Expanded(
                      child: Center(
                          child: Text('R', style: Get.textTheme.labelMedium))),
                  Expanded(
                    child: Center(
                        child: Text('B', style: Get.textTheme.labelMedium)),
                  ),
                  Expanded(
                      child: Center(
                          child: Text('4s', style: Get.textTheme.labelMedium))),
                  Expanded(
                      child: Center(
                          child: Text('6s', style: Get.textTheme.labelMedium))),
                  Expanded(
                      child: Center(
                          child: Text('SR', style: Get.textTheme.labelMedium)))
                ],
              ),
              const Divider(
                height: 10,
                color: Colors.grey,
              ),
              const SizedBox(height: 10),
              _PlayerStat(
                controller.scoreboard.value!.striker,
              ),
              const SizedBox(height: 10),
              _PlayerStat(
                controller.scoreboard.value!.nonstriker,
              )
            ]),
          ),
        ));
  }
}

class _PlayerStat extends StatelessWidget {
  final PlayerModel player;
  const _PlayerStat(this.player);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 3, child: Text(player.name)),
        const Spacer(
          flex: 3,
        ),
        Expanded(
            child: Center(
                child: Text(player.batting.runs.toString(),
                    style: Get.textTheme.labelMedium))),
        Expanded(
          child: Center(
              child: Text(player.batting.balls.toString(),
                  style: Get.textTheme.labelMedium)),
        ),
        Expanded(
            child: Center(
                child: Text(player.batting.fours.toString(),
                    style: Get.textTheme.labelMedium))),
        Expanded(
            child: Center(
                child: Text(player.batting.sixes.toString(),
                    style: Get.textTheme.labelMedium))),
        Expanded(
            child: Center(
                child: Text(player.batting.strikeRate.toStringAsFixed(1),
                    style: Get.textTheme.labelMedium)))
      ],
    );
  }
}
