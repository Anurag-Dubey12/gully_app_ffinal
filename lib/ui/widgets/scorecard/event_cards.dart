import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/extras_model.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:gully_app/ui/widgets/scorecard/change_bowler.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/utils.dart';

import '../../../data/controller/scoreboard_controller.dart';
import 'TieBreakerSheet.dart';
import 'change_batter.dart';
import 'scorecard_dialogs.dart';

class PartnershipDialog extends GetView<ScoreBoardController> {
  const PartnershipDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final partnerships = controller.scoreboard.value?.partnerships;
    logger.d(partnerships!.values.toList());
    return Container(
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 233, 229, 229),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        width: Get.width,
        height: Get.height * 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 7,
                  width: 120,
                  decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            SizedBox(
              height: Get.height * 0.5,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text('Partnership',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w900)),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: partnerships.values.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: Get.width,
                                // height: 140,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                partnerships.values
                                                    .elementAt(index)
                                                    .player1
                                                    .name,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            const SizedBox(height: 10),
                                            Text(
                                                partnerships.values
                                                    .elementAt(index)
                                                    .player1
                                                    .batting!
                                                    .runs
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16))
                                          ],
                                        )),
                                    const SizedBox(width: 10),
                                    Expanded(
                                        child: Column(
                                      children: [
                                        Text(
                                            '${partnerships.values.elementAt(index).runs}',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.green)),
                                        Text(
                                            '(${partnerships.values.elementAt(index).balls} balls)',
                                            style: const TextStyle(
                                              fontSize: 13,
                                            )),
                                      ],
                                    )),
                                    Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                                partnerships.values
                                                    .elementAt(index)
                                                    .player2
                                                    .name,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            const SizedBox(height: 10),
                                            Text(
                                                partnerships.values
                                                    .elementAt(index)
                                                    .player2
                                                    .batting!
                                                    .runs
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16)),
                                            const SizedBox(height: 10),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    const SizedBox(height: 30),
                    PrimaryButton(
                      onTap: () {
                        // Get.back();
                        Get.close();
                      },
                      title: 'Done',
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class ExtrasDialog extends GetView<ScoreBoardController> {
  const ExtrasDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final ExtraModel extraModel = controller.scoreboard.value!.currentExtras;
    return Container(
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 233, 229, 229),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        width: Get.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 7,
                  width: 120,
                  decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text('Extras',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  Text(
                      '${extraModel.byes}B, ${extraModel.legByes}L, ${extraModel.noBalls}N, ${extraModel.penalty}P, ${extraModel.wides}WD, '),
                  const SizedBox(height: 30),
                  PrimaryButton(
                    onTap: () {
                      // Get.back();
                      Get.close();
                    },
                    title: 'Done',
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

class NumberCard extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final bool disabled;
  const NumberCard({
    super.key,
    required this.text,
    required this.onTap,
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          focusColor: const Color.fromARGB(255, 253, 247, 228),
          hoverColor: const Color.fromARGB(255, 255, 244, 209),
          splashColor: Colors.amber,
          onTap: disabled ? null : onTap,
          child: Ink(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: disabled
                        ? Colors.grey.shade300
                        : AppTheme.secondaryYellowColor,
                    width: 2)),
            child: Center(
                child: Text(text,
                    style: Get.textTheme.headlineMedium
                        ?.copyWith(fontSize: 15 * Get.textScaleFactor))),
          ),
        ),
      ),
    );
  }
}

class UpdateEvent extends GetView<ScoreBoardController> {
  const UpdateEvent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Column(children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _EventWidget(
                    title: 'Wide',
                    eventType: EventType.wide,
                  ),
                  _EventWidget(
                    title: 'No ball',
                    eventType: EventType.noBall,
                  ),
                  _EventWidget(
                    title: 'Byes',
                    eventType: EventType.bye,
                  ),
                  _EventWidget(
                    title: 'Leg byes',
                    eventType: EventType.legByes,
                  ),

                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const _EventWidget(
                    title: 'Wicket',
                    eventType: EventType.wicket,
                  ),
                  // SizedBox(
                  //   height: 30,
                  //   child: TextButton(
                  //     style: ButtonStyle(
                  //       backgroundColor: MaterialStateProperty.all(
                  //         AppTheme.primaryColor,
                  //       ),
                  //       padding: MaterialStateProperty.all(
                  //         const EdgeInsets.all(3),
                  //       ),
                  //     ),
                  //     onPressed: () {
                  //       if ((controller.scoreboard.value?.isSecondInningsOver ?? false)) {
                  //         errorSnackBar('Match Over');
                  //         return;
                  //       }
                  //       if ((controller.scoreboard.value?.inningsCompleted ?? false)) {
                  //         errorSnackBar('Innings Completed');
                  //         return;
                  //       }
                  //       logger.d("Wicket is Clicked");
                  //       controller.scoreboard.value!.addRuns(0,events: [EventType.wicket]);
                  //     },
                  //     child: const Text(
                  //       'Wicket',
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 10,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                      // width: 100,
                      height: 30,
                      child: TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppTheme.primaryColor),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(4))),
                          onPressed: () {
                            if ((controller
                                    .scoreboard.value?.isSecondInningsOver ??
                                false)) {
                              errorSnackBar('Match Over');
                              return;
                            }
                            if ((controller
                                    .scoreboard.value?.inningsCompleted ??
                                false)) {
                              errorSnackBar('Innings Completed');
                              return;
                            }
                            Get.bottomSheet(const RetirePlayerDialog());
                          },
                          child: const Text('Retire',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500)))),

                  SizedBox(
                      // width: 100,
                      height: 30,
                      child: TextButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  AppTheme.primaryColor),
                              padding: WidgetStateProperty.all(
                                  const EdgeInsets.all(7))),
                          onPressed: () {
                            controller.addEvent(EventType.changeStriker);
                          },
                          child: const Text('Swap Batsman',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500)))),
                  SizedBox(
                      // width: 100,
                      height: 30,
                      child: TextButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  AppTheme.primaryColor),
                              padding: WidgetStateProperty.all(
                                  const EdgeInsets.all(7))),
                          onPressed: () {
                            if ((controller
                                    .scoreboard.value?.isSecondInningsOver ??
                                false)) {
                              errorSnackBar('Match Over');
                              return;
                            }
                            if ((controller
                                    .scoreboard.value?.inningsCompleted ??
                                false)) {
                              errorSnackBar('Innings Completed');
                              return;
                            }

                            showModalBottomSheet(
                                context: Get.context!,
                                builder: (c) => const ChangeBowlerWidget(),
                                enableDrag: true,
                                isDismissible: true);
                          },
                          child: const Text('Change Bowler',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500)))),
                ],
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class _EventWidget extends GetView<ScoreBoardController> {
  final String title;
  final EventType eventType;
  const _EventWidget({
    required this.title,
    required this.eventType,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Row(
        children: [
          SizedBox(
            width: 20,
            child: Obx(() => Checkbox(
                  value: controller.events.value.contains(eventType),
                  // groupValue: controller.eventType.value,
                  onChanged: (e) {
                    if (e == null) return;
                    if (e) {
                      logger.d("found event $eventType");
                      if(eventType==EventType.wicket){
                        controller.isWicketSelected.value=true;
                      }
                      controller.addEventType(eventType);
                    } else {
                      if(eventType==EventType.wicket){
                        controller.isWicketSelected.value=false;
                      }
                      controller.removeEventType(eventType);
                    }
                  },
                )),
          ),
          const SizedBox(width: 4),
          Text(title,
              style: Get.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 10 * Get.textScaleFactor)),
        ],
      ),
    );
  }
}
