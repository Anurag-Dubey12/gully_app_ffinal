import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/controller/scoreboard_controller.dart';
import '../../../data/model/player_model.dart';

class ChangeBowlerWidget extends GetView<ScoreBoardController> {
  const ChangeBowlerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<PlayerModel> players = [];
    if (controller.scoreboard.value!.currentInnings == 1) {
      players.addAll(controller.scoreboard.value!.team2.players!);
    } else {
      players.addAll(controller.scoreboard.value!.team1.players!);
    }
    players.removeWhere(
        (element) => element.id == controller.scoreboard.value!.bowlerId);
    return SizedBox(
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Change Bowler', style: Get.textTheme.headlineMedium),
              SizedBox(
                height: Get.height * 0.5,
                child: ListView.builder(
                  itemCount: players.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(
                      players[index].name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () async {
                      controller.addEvent(EventType.changeBowler,
                          bowlerId: players[index].id);
                      Navigator.pop(context);
                    },
                    subtitle: Row(
                      children: [
                        BowlerStat(
                          title: 'O:',
                          value:
                              (players[index].bowling!.currentOver).toString(),
                        ),
                        BowlerStat(
                          title: 'R: ',
                          value: players[index].bowling!.runs.toString(),
                        ),
                        BowlerStat(
                          title: 'W: ',
                          value: players[index].bowling!.wickets.toString(),
                        ),
                        BowlerStat(
                          title: 'Eco: ',
                          value: players[index].bowling!.economy.toString(),
                        ),
                        BowlerStat(
                          title: 'Fours: ',
                          value: players[index].bowling!.fours.toString(),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BowlerStat extends StatelessWidget {
  final String title;
  final String value;
  const BowlerStat({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
