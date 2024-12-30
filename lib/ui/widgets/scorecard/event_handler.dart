import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/screens/full_scorecard.dart';
import 'package:gully_app/ui/widgets/custom_score_select_sheet.dart';
import 'package:gully_app/utils/utils.dart';
import '../../../data/controller/misc_controller.dart';
import '../../../data/controller/scoreboard_controller.dart';
import '../../theme/theme.dart';
import '../primary_button.dart';
import 'event_cards.dart';
import 'scorecard_dialogs.dart';

class ScoreUpdater extends GetView<ScoreBoardController> {
  const ScoreUpdater({super.key});

  @override
  Widget build(BuildContext context) {
    final MiscController connectionController = Get.find<MiscController>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const UpdateEvent(),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              crossAxisSpacing: 10,
                              childAspectRatio: 3,
                              mainAxisSpacing: 10),
                      children: [
                        SizedBox(
                          height: 10,
                          child: PrimaryButton(
                            onTap: () {
                              controller.undoLastEvent();
                            },
                            title: 'Undo',
                            fontSize: 12 * Get.textScaleFactor,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          child: PrimaryButton(
                            onTap: () {
                              Get.bottomSheet(
                                const PartnershipDialog(),
                              );
                            },
                            title: 'Partnership',
                            fontSize: 12 * Get.textScaleFactor,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                          child: PrimaryButton(
                            onTap: () {
                              Get.bottomSheet(const ExtrasDialog());
                            },
                            title: 'Extras',
                            fontSize: 12 * Get.textScaleFactor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Container(
                      // height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          runAlignment: WrapAlignment.spaceEvenly,
                          children: [
                            NumberCard(
                              text: '0',
                              disabled: controller
                                  .scoreboard.value!.isSecondInningsOver,
                              onTap: () {
                                if (!connectionController.isConnected.value) {
                                  errorSnackBar(
                                      'Please connect to the internet to update score');
                                  return;
                                } else {
                                  if (controller.events
                                          .contains(EventType.bye) ||
                                      controller.events
                                          .contains(EventType.legByes)) {
                                    errorSnackBar(
                                        'You can not add a dot ball and a bye or leg bye');
                                    return;
                                  }
                                  controller.addEvent(EventType.dotBall);
                                }
                              },
                            ),
                            NumberCard(
                                text: '1',
                                disabled: controller
                                    .scoreboard.value!.isSecondInningsOver,
                                onTap: () {
                                  if (!connectionController.isConnected.value) {
                                    errorSnackBar(
                                        'Please connect to the internet to update score');
                                    return;
                                  } else {
                                    if (controller.events
                                            .contains(EventType.bye) &&
                                        controller.events
                                            .contains(EventType.wide) &&
                                        controller.events
                                            .contains(EventType.wicket)) {
                                      errorSnackBar(
                                          'You can not add a one and a bye or wide or wicket');
                                      return;
                                    }

                                    if (controller.events
                                            .contains(EventType.legByes) &&
                                        controller.events
                                            .contains(EventType.wide) &&
                                        controller.events
                                            .contains(EventType.wicket)) {
                                      errorSnackBar(
                                          'You can not add a one and a leg bye or wide or wicket');
                                      return;
                                    }
                                    if (controller.events
                                            .contains(EventType.noBall) &&
                                        controller.events
                                            .contains(EventType.bye) &&
                                        controller.events
                                            .contains(EventType.wicket)) {
                                      errorSnackBar(
                                          'You can not add a one and a no ball or bye or wicket');
                                      return;
                                    }
                                    if (controller.events
                                            .contains(EventType.noBall) &&
                                        controller.events
                                            .contains(EventType.legByes) &&
                                        controller.events
                                            .contains(EventType.wicket)) {
                                      errorSnackBar(
                                          'You can not add a one and a no ball or leg bye or wicket');
                                      return;
                                    }
                                    controller.addEvent(EventType.one);
                                  }
                                }),
                            NumberCard(
                                text: '2',
                                disabled: controller
                                    .scoreboard.value!.isSecondInningsOver,
                                onTap: () {
                                  if (!connectionController.isConnected.value) {
                                    errorSnackBar(
                                        'Please connect to the internet to update score');
                                    return;
                                  } else {
                                    controller.addEvent(EventType.two);
                                  }
                                }),
                            NumberCard(
                                text: '3',
                                disabled: controller
                                    .scoreboard.value!.isSecondInningsOver,
                                onTap: () {
                                  if (!connectionController.isConnected.value) {
                                    errorSnackBar(
                                        'Please connect to the internet to update score');
                                    return;
                                  } else {
                                    controller.addEvent(EventType.three);
                                  }
                                }),
                            NumberCard(
                                text: '4',
                                disabled: controller
                                    .scoreboard.value!.isSecondInningsOver,
                                onTap: () {
                                  if (!connectionController.isConnected.value) {
                                    errorSnackBar(
                                        'Please connect to the internet to update score');
                                    return;
                                  } else {
                                    if (controller.events
                                            .contains(EventType.bye) ||
                                        controller.events
                                            .contains(EventType.legByes)) {
                                      errorSnackBar(
                                          'You can not add a four and a bye or leg bye');
                                      return;
                                    }
                                    // if (controller.events
                                    //     .contains(EventType.wide)) {
                                    //   errorSnackBar(
                                    //       'You can not add a four and a wide ball');
                                    //   return;
                                    // }

                                    if (controller.events
                                        .contains(EventType.wicket)) {
                                      errorSnackBar(
                                          'You can not add a four and a wicket');
                                      return;
                                    }
                                    controller.addEvent(EventType.four);
                                  }
                                }),
                            NumberCard(
                                text: '5',
                                disabled: controller
                                    .scoreboard.value!.isSecondInningsOver,
                                onTap: () {
                                  if (!connectionController.isConnected.value) {
                                    errorSnackBar(
                                        'Please connect to the internet to update score');
                                    return;
                                  } else {
                                    if (controller.events
                                            .contains(EventType.wide) &&
                                        controller.events
                                            .contains(EventType.wicket)) {
                                      errorSnackBar(
                                          'You can not add a five, wicket and a wide ball');
                                      return;
                                    }
                                    if (controller.events
                                            .contains(EventType.noBall) &&
                                        controller.events
                                            .contains(EventType.wicket)) {
                                      errorSnackBar(
                                          'You can not add a five , no ball and a wicket');
                                      return;
                                    }
                                    if (controller.events
                                            .contains(EventType.bye) ||
                                        controller.events
                                            .contains(EventType.legByes)) {
                                      errorSnackBar(
                                          'You can not add 5 runs and a bye or leg bye');
                                      return;
                                    }
                                    controller.addEvent(EventType.five);
                                  }
                                }),
                            NumberCard(
                                text: '6',
                                disabled: controller
                                    .scoreboard.value!.isSecondInningsOver,
                                onTap: () {
                                  if (!connectionController.isConnected.value) {
                                    errorSnackBar(
                                        'Please connect to the internet to update score');
                                    return;
                                  } else {
                                    if (controller.events
                                            .contains(EventType.bye) ||
                                        controller.events
                                            .contains(EventType.legByes)) {
                                      errorSnackBar(
                                          'You can not add a six and a bye or leg bye');
                                      return;
                                    }
                                    if (controller.events
                                        .contains(EventType.wide)) {
                                      errorSnackBar(
                                          'You can not add a six and a wide ball');
                                      return;
                                    }
                                    if (controller.events
                                            .contains(EventType.noBall) &&
                                        controller.events
                                            .contains(EventType.wicket)) {
                                      errorSnackBar(
                                          'You cannot add six runs, a no ball and a wicket');
                                      return;
                                    }
                                    if (controller.events
                                        .contains(EventType.wicket)) {
                                      errorSnackBar(
                                          'You can not add six runs and a wicket');
                                      return;
                                    }

                                    controller.addEvent(EventType.six);
                                  }
                                }),
                            NumberCard(
                                text: '+',
                                disabled: controller
                                    .scoreboard.value!.isSecondInningsOver,
                                onTap: () {
                                  if (!connectionController.isConnected.value) {
                                    errorSnackBar(
                                        'Please connect to the internet to update score');
                                    return;
                                  } else {
                                    showCustomScoreSheet(context, controller);
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Obx(() => controller.scoreboard.value?.currentInnings == 1
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                  width: Get.width,
                                  height: 40,
                                  child: TextButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                                  AppTheme.primaryColor),
                                          padding: WidgetStateProperty.all(
                                              const EdgeInsets.all(7))),
                                      onPressed: () {
                                        if (!connectionController
                                            .isConnected.value) {
                                          errorSnackBar(
                                              'Please connect to the internet to update score');
                                          return;
                                        } else {
                                          Get.bottomSheet(
                                              const EndOfIningsDialog(),
                                              isScrollControlled: true,
                                              ignoreSafeArea: true);
                                        }
                                      },
                                      child: const Text('Start 2nd Innings',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500)))),
                            ),
                          )
                        : PrimaryButton(
                            onTap: () {
                              Get.to(() => const FullScoreboardScreen());
                            },
                            title: 'View Full Scorecard',
                          ))
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void showCustomScoreSheet(
      BuildContext context, ScoreBoardController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return CustomScoreSheet(
          onScoreSubmit: (int runs) async {
            bool success =
                await controller.addEvent(EventType.custom, runs: runs);
            if (success) {
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }
}
