import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/scoreboard_controller.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/utils/app_logger.dart';

import '../widgets/scorecard/batting_card.dart';
import '../widgets/scorecard/bowling_card.dart';
import '../widgets/scorecard/current_over_card.dart';
import '../widgets/scorecard/event_handler.dart';
import '../widgets/scorecard/top_scorecard.dart';

class ScoreCardScreen extends GetView<ScoreBoardController> {
  const ScoreCardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return GradientBuilder(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Black panther vs CSK',
            style: Get.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            )),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'copy',
            onPressed: () async {
              try {
                logger.d("COPYING ${controller.scoreboard.value!.toJson()}}");
                await Clipboard.setData(ClipboardData(
                    text: jsonEncode(controller.scoreboard.value!.toJson())));
                logger.d("COPIED");
              } catch (e) {
                logger.e(e);
              }
            },
            backgroundColor: Colors.green,
            child: const Icon(
              Icons.copy,
            ),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            heroTag: 'restart',
            onPressed: () async {
              controller.createScoreBoard();
            },
            backgroundColor: Colors.red,
            child: const Icon(
              Icons.restart_alt_rounded,
            ),
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(18.0),
        child: Column(children: [
          ScoreCard(),
          SizedBox(height: 10),
          BattingStats(),
          SizedBox(height: 10),
          BowlingStats(),
          SizedBox(height: 10),
          CurrentOverStats(),
          SizedBox(height: 10),
          ScoreUpdater(),
          Spacer(),
        ]),
      ),
    ));
  }
}
