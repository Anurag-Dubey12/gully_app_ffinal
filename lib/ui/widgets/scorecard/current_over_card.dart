import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/theme/theme.dart';

import '../../../data/controller/scoreboard_controller.dart';

class CurrentOverStats extends GetView<ScoreBoardController> {
  const CurrentOverStats({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Obx(() {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(children: [
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child:
                          Text('This Over:', style: Get.textTheme.labelMedium)),
                  Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: 50,
                        child: ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 14),
                            itemCount: controller.scoreboard.value
                                    ?.currentOverHistory.length ??
                                0,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      border: controller
                                                  .scoreboard
                                                  .value!
                                                  .currentOverHistory[index]
                                                  ?.run ==
                                              null
                                          ? null
                                          : Border.all(
                                              color:
                                                  AppTheme.secondaryYellowColor,
                                              width: 1),
                                      borderRadius: BorderRadius.circular(1000),
                                    ),
                                    child: Center(
                                      child: Obx(
                                        () {
                                          final baseRun = controller
                                              .scoreboard
                                              .value!
                                              .currentOverHistory[index]
                                              ?.run;
                                          final extraRun = (controller
                                                      .scoreboard
                                                      .value!
                                                      .currentOverHistory[index]
                                                      ?.events ??
                                                  [])
                                              .where((event) =>
                                                  event == EventType.noBall ||
                                                  event == EventType.wide)
                                              .length;
                                          final totalScore =
                                              (baseRun ?? 0) + extraRun;
                                          return Text(
                                              totalScore > 0
                                                  ? totalScore.toString()
                                                  : (baseRun == 0 ? '0' : ''),
                                              style: Get.textTheme.labelMedium
                                                  ?.copyWith(
                                                      color: controller
                                                                  .scoreboard
                                                                  .value!
                                                                  .currentOverHistory[
                                                                      index]
                                                                  ?.run ==
                                                              0
                                                          ? Colors.red
                                                          : Colors.black));
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Obx(() {
                                    final extraRun = controller
                                            .scoreboard
                                            .value!
                                            .currentOverHistory[index]
                                            ?.run ??
                                        0;
                                    final events = controller
                                            .scoreboard
                                            .value!
                                            .currentOverHistory[index]
                                            ?.events ??
                                        [];
                                    final hasExtra = events.any((event) =>
                                        event == EventType.wide ||
                                        event == EventType.noBall);

                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ...events.map((e) => Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: CircleAvatar(
                                                radius: 9,
                                                child: Text(
                                                  switch (e) {
                                                    EventType.wide => 'Wd',
                                                    EventType.noBall => 'Nb',
                                                    EventType.wicket => 'W',
                                                    EventType.changeBowler =>
                                                      'B',
                                                    EventType.changeStriker =>
                                                      'S',
                                                    EventType.legByes => 'Lb',
                                                    EventType.four => '4',
                                                    EventType.six => '6',
                                                    EventType.bye => 'B',
                                                    EventType.retire => 'RE',
                                                    _ => ''
                                                  },
                                                  style: const TextStyle(
                                                      fontSize: 8),
                                                ),
                                              ),
                                            )),
                                        if (hasExtra &&
                                            extraRun != 4 &&
                                            extraRun != 6)
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: CircleAvatar(
                                              radius: 9,
                                              child: Text(
                                                '$extraRun',
                                                style: const TextStyle(
                                                    fontSize: 8),
                                              ),
                                            ),
                                          ),
                                      ],
                                    );
                                  })
                                  // Obx(() {
                                  //   final extraRunScored=controller.scoreboard.value!.currentOverHistory[index]?.run;
                                  //   //logger.d"The extraRunScored is:$extraRunScored");
                                  //
                                  //   final hasExtraEvent = (controller.scoreboard.value!.currentOverHistory[index]?.events ?? [])
                                  //       .any((event) => event == EventType.wide || event == EventType.noBall);
                                  //   return Row(
                                  //     mainAxisAlignment:
                                  //     MainAxisAlignment.center,
                                  //     children: [
                                  //       ...(controller
                                  //           .scoreboard
                                  //           .value!
                                  //           .currentOverHistory[index]
                                  //           ?.events ??
                                  //           [])
                                  //           .map((e) => Padding(
                                  //         padding:
                                  //         const EdgeInsets.all(
                                  //             2.0),
                                  //         child: CircleAvatar(
                                  //           radius: 9,
                                  //           child: Text(
                                  //             convertEventTypeToText(e),
                                  //             style: const TextStyle(
                                  //                 fontSize: 8),
                                  //           ),
                                  //         ),
                                  //       )),
                                  //       // if(hasExtraEvent)
                                  //       //   Padding(
                                  //       //     padding: const EdgeInsets.all(2.0),
                                  //       //     child: CircleAvatar(
                                  //       //       radius: 9,
                                  //       //       child: Text(
                                  //       //         '+$extraRunScored',
                                  //       //         style: const TextStyle(fontSize: 8),
                                  //       //       ),
                                  //       //     ),
                                  //       //   ),
                                  //     ],
                                  //   );
                                  // }),
                                ],
                              );
                            }),
                      )),
                ],
              ),
            ]),
          ),
        );
      }),
    );
  }
}

convertEventTypeToText(EventType type) {
  switch (type) {
    case EventType.four:
      return '4';
    case EventType.six:
      return '6';
    case EventType.one:
      return '1';
    case EventType.two:
      return '2';
    case EventType.three:
      return '3';
    case EventType.wide:
      return 'Wd';
    case EventType.noBall:
      return 'Nb';
    case EventType.wicket:
      return 'W';
    case EventType.dotBall:
      return '0';
    case EventType.changeBowler:
      return 'Bowler';
    case EventType.changeStriker:
      return 'Striker';
    case EventType.legByes:
      return 'Lb';
    case EventType.bye:
      return 'Bye';
    case EventType.retire:
      return 'RE';
    default:
      {
        return '';
      }
  }
}
