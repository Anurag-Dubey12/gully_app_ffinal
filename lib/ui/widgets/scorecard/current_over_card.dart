import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/controller/scoreboard_controller.dart';

class CurrentOverStats extends GetView<ScoreBoardController> {
  const CurrentOverStats({
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
            padding: const EdgeInsets.all(17.0),
            child: Column(children: [
              Row(
                children: [
                  Expanded(
                      flex: 3,
                      child:
                          Text('This Over:', style: Get.textTheme.labelMedium)),
                  const Spacer(
                    flex: 3,
                  ),
                  ...controller.scoreboard.value!.currentOverHistory.map((e) =>
                      e == null
                          ? const SizedBox()
                          : Expanded(
                              child: Center(
                                  child: Text(e.run.toString(),
                                      style: Get.textTheme.labelMedium)))),
                ],
              ),
            ]),
          ),
        ));
  }
}
