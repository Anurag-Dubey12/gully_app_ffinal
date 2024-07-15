import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/scoreboard_model.dart';
import '../../../data/controller/scoreboard_controller.dart';
import '../../../data/model/bowling_model.dart';
import '../../../data/model/extras_model.dart';
import '../../../data/model/innings_model.dart';

class ExtrasAndTotal extends StatelessWidget {
  final int currentInning;
  final ScoreboardModel? scoreboard;

  const ExtrasAndTotal({Key? key, required this.currentInning, this.scoreboard}) : super(key: key);

  String formatOvers(int overs, int balls) {
    if(balls==6){
      overs+=1;
    }
    return '$overs.${balls % 6}';
  }

  @override
  Widget build(BuildContext context) {
    if (scoreboard != null) {
      return _buildContent(
          currentInning == 1 ? scoreboard!.firstInnings : scoreboard!.secondInnings
      );
    } else {
      return GetX<ScoreBoardController>(
        builder: (controller) {
          final InningsModel? currentInningsModel = currentInning == 1
              ? controller.scoreboard.value?.firstInnings
              : controller.scoreboard.value?.secondInnings;
          return _buildContent(currentInningsModel);
        },
      );
    }
  }

  Widget _buildContent(InningsModel? inningsModel) {
    final ExtraModel currentExtras = inningsModel?.extras ??
        ExtraModel(wides: 0, noBalls: 0, byes: 0, legByes: 0, penalty: 0);
    final int currentTotalRuns = inningsModel?.totalScore ?? 0;
    final int currentTotalWickets = inningsModel?.totalWickets ?? 0;
    final int currentOvers = inningsModel?.overs ?? 0;
    final int currentBalls = inningsModel?.balls ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Extras',
                  style: Get.textTheme.labelMedium?.copyWith(fontSize: 14, color: Colors.blue.shade900,fontWeight: FontWeight.bold,),
                ),
              ),
              const SizedBox(width: 80),
              Expanded(
                flex: 7,
                child: Text(
                  '${currentExtras.byes}B, ${currentExtras.legByes}L, ${currentExtras.noBalls}N, ${currentExtras.penalty}P, ${currentExtras.wides}WD ',
                  style: Get.textTheme.labelMedium?.copyWith(fontSize: 13, color: Colors.blue.shade600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Total runs',
                  style: Get.textTheme.labelMedium?.copyWith(fontSize: 14, color: Colors.blue.shade900,fontWeight: FontWeight.bold),
                ),
              ),
              // const SizedBox(width: 15),
              Expanded(
                flex: 7,
                child: Center(
                  child: Text(
                    '$currentTotalRuns($currentTotalWickets wkts, ${formatOvers(currentOvers, currentBalls)} ov)',
                    style: Get.textTheme.labelMedium?.copyWith( fontSize: 13, color: Colors.blue.shade600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}