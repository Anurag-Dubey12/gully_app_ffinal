import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/scoreboard_controller.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/utils/app_logger.dart';

import '../widgets/scorecard/batting_card.dart';
import '../widgets/scorecard/current_over_card.dart';
import '../widgets/scorecard/event_handler.dart';
import '../widgets/scorecard/top_scorecard.dart';

class ScoreCardScreen extends GetView<ScoreBoardController> {
  const ScoreCardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.socket.value == null) {
        // controller.connectToSocket();
        return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => controller.connectToSocket(),
              child: const Icon(Icons.add),
            ),
            body: const Center(child: CircularProgressIndicator()));
      }
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
                  logger.d("COPYING");
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
                // controller.disconnect();
                controller.createScoreBoard();
                controller.connectToSocket();
              },
              backgroundColor: Colors.red,
              child: const Icon(
                Icons.restart_alt_rounded,
              ),
            ),
          ],
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(height: 20),
            ScoreCard(),
            BattingStats(),
            CurrentOverStats(),
            Expanded(flex: 3, child: ScoreUpdater()),
          ]),
        ),
      ));
    });
  }
}
