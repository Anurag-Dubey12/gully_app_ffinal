import 'dart:convert';
import 'package:flutter/foundation.dart';
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

class ScoreCardScreen extends StatefulWidget {
  const ScoreCardScreen({super.key});

  @override
  State<ScoreCardScreen> createState() => _ScoreCardScreenState();
}

class _ScoreCardScreenState extends State<ScoreCardScreen> {
  @override
  void initState() {
    super.initState();
    final controller = Get.find<ScoreBoardController>();
    controller.connectToSocket();
  }

  @override
  void dispose() {
    final controller = Get.find<ScoreBoardController>();
    controller.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScoreBoardController>();

    return Obx(() {
      if (controller.socket.value == null) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      logger.d(controller.scoreboard.value?.matchId);
      return GradientBuilder(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButton: kDebugMode
                ? FloatingActionButton(
              onPressed: () {
                // copy to clipboard
                Clipboard.setData(ClipboardData(
                    text: jsonEncode(controller.scoreboard.value!.toJson())));
              },
              child: const Icon(Icons.copy),
            )
                : null,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: Colors.white),
              title: Text(
                  '${controller.scoreboard.value?.team1.name} vs ${controller.scoreboard.value?.team2.name}',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: Get.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                  )),
            ),
            body: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                ScoreCard(),
                BattingStats(),
                BowlingStats(),
                CurrentOverStats(),
                Expanded(flex: 3, child: ScoreUpdater()),
              ]),
            ),
          ));
    });
  }
}
