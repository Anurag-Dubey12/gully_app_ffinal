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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Obx(() => Container(
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
                            child: Text('Batsman',
                                style: Get.textTheme.labelMedium))),
                    const Spacer(
                      flex: 1,
                    ),
                    Expanded(
                        child: Center(
                            child:
                                Text('R', style: Get.textTheme.labelMedium))),
                    Expanded(
                      child: Center(
                          child: Text('B', style: Get.textTheme.labelMedium)),
                    ),
                    Expanded(
                        child: Center(
                            child:
                                Text('4s', style: Get.textTheme.labelMedium))),
                    Expanded(
                        child: Center(
                            child:
                                Text('6s', style: Get.textTheme.labelMedium))),
                    Expanded(
                        child: Center(
                            child:
                                Text('SR', style: Get.textTheme.labelMedium)))
                  ],
                ),
              ),
              const Divider(
                height: 10,
                color: Colors.grey,
              ),
              const SizedBox(height: 4),
              BatterPlayerStat(controller.scoreboard.value!.striker, true),
              const SizedBox(height: 3),
              BatterPlayerStat(controller.scoreboard.value!.nonstriker, false),
              const SizedBox(height: 10),
            ]),
          )),
    );
  }
}

class BatterPlayerStat extends StatelessWidget {
  final PlayerModel player;
  final bool? isStriker;
  const BatterPlayerStat(this.player, this.isStriker, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              player.name + (isStriker ?? false ? "*" : ''),
              maxLines: 1,
              style: TextStyle(
                color: isStriker ?? false ? Colors.blue[900] : Colors.black,
                fontWeight: isStriker ?? false ? FontWeight.bold : null,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(
            flex: 1,
          ),
          Expanded(
              child: Center(
                  child: Text(player.batting!.runs.toString(),
                      style: Get.textTheme.labelMedium))),
          Expanded(
            child: Center(
                child: Text(player.batting!.balls.toString(),
                    style: Get.textTheme.labelMedium)),
          ),
          Expanded(
              child: Center(
                  child: Text(player.batting!.fours.toString(),
                      style: Get.textTheme.labelMedium))),
          Expanded(
              child: Center(
                  child: Text(player.batting!.sixes.toString(),
                      style: Get.textTheme.labelMedium))),
          Expanded(
              child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Center(
                child: Text('${player.batting!.strikeRate.toStringAsFixed(1)}%',
                    style: Get.textTheme.labelMedium?.copyWith(fontSize: 11))),
          ))
        ],
      ),
    );
  }
}
