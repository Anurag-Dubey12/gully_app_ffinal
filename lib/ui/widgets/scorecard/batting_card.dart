import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/scoreboard_controller.dart';
import 'package:gully_app/data/model/batting_model.dart';

import '../../../data/model/extras_model.dart';
import '../../../data/model/player_model.dart';
import '../../../data/model/team_model.dart';
import 'extras_and_total.dart';

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
                        child: Text('R', style: Get.textTheme.labelMedium))),
                Expanded(
                    child: Center(
                        child: Text('B', style: Get.textTheme.labelMedium))),
                Expanded(
                    child: Center(
                        child: Text('4s', style: Get.textTheme.labelMedium))),
                Expanded(
                    child: Center(
                        child: Text('6s', style: Get.textTheme.labelMedium))),
                Expanded(
                    child: Center(
                        child: Text('SR', style: Get.textTheme.labelMedium))),
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
  const BatterPlayerStat(this.player, this.isStriker ,{super.key});

  @override
  Widget build(BuildContext context) {
    bool hasBatted = player.batting != null && player.batting!.balls > 0  ;
    final ScoreBoardController controller = Get.find<ScoreBoardController>();
    double strikeRate = calculateStrikeRate(player.batting!.runs, player.batting!.balls);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.name + (isStriker == null ? '' : (isStriker! ? '*' : '')),
                      maxLines: 1,
                      style: TextStyle(
                        color: hasBatted ? Colors.black : Colors.grey,
                        fontWeight: hasBatted ? FontWeight.bold : null,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (!isStriker! && player.batting!.outType.isNotEmpty)
                      Text(
                        _getOutInfo(player.batting!),
                        style: Get.textTheme.labelMedium?.copyWith(fontSize: 12, color: Colors.grey[600]),
                      ),
                  ],
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              Expanded(
                  child: Center(
                      child: Text(
                          player.batting!.runs.toString(),
                          style: hasBatted ?
                          Get.textTheme.labelMedium?.copyWith(color: Colors.black)
                              : Get.textTheme.labelMedium)
                  )),
              Expanded(
                  child: Center(
                      child: Text(
                          player.batting!.balls.toString(),
                          style: hasBatted ?
                          Get.textTheme.labelMedium?.copyWith(color: Colors.black)
                              : Get.textTheme.labelMedium)
                  )
              ),
              Expanded(
                  child: Center(
                      child: Text(
                          player.batting!.fours.toString(),
                          style: hasBatted ?
                          Get.textTheme.labelMedium?.copyWith(color: Colors.black)
                              : Get.textTheme.labelMedium))),
              Expanded(
                  child: Center(
                      child: Text(
                          player.batting!.sixes.toString(),
                          style: hasBatted ?
                          Get.textTheme.labelMedium?.copyWith(color: Colors.black)
                              : Get.textTheme.labelMedium))),
              Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Center(
                        child: Text(
                            "${strikeRate.toStringAsFixed(1)}%",
                            // "${player.batting!.strikeRate.toStringAsFixed(1)}%",
                            style: hasBatted ?
                            Get.textTheme.labelMedium?.copyWith(fontSize: 11, color: Colors.black)
                                : Get.textTheme.labelMedium?.copyWith(fontSize: 11)
                        )),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  double calculateStrikeRate(int runs, int balls) {
    if (balls == 0) return 0.0;
    return (runs / balls) * 100;
  }
  String _getOutInfo(BattingModel batting) {
    if (batting.outType== 'Retired') {
      return 'Retired';
    } else if (batting.outType.isNotEmpty && batting.bowledBy.isNotEmpty) {
      return '${batting.outType} b ${batting.bowledBy}';
    } else {
      return '';
    }
  }
}
