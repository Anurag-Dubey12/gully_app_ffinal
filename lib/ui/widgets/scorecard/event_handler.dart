import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/controller/scoreboard_controller.dart';
import '../primary_button.dart';
import 'event_cards.dart';
import 'scorecard_dialogs.dart';

class ScoreUpdater extends GetView<ScoreBoardController> {
  const ScoreUpdater({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Column(
        children: [
          const UpdateEvent(),
          const SizedBox(height: 10),
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 30,
                            child: PrimaryButton(
                              onTap: () {
                                controller.undoLastEvent();
                              },
                              title: 'Undo',
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            child: PrimaryButton(
                              onTap: () {
                                Get.bottomSheet(const PartnershipDialog());
                              },
                              title: 'Partnership',
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            child: PrimaryButton(
                              onTap: () {
                                Get.bottomSheet(const ExtrasDialog());
                              },
                              title: 'Extras',
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
                  child: Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        runAlignment: WrapAlignment.spaceEvenly,
                        children: [
                          NumberCard(
                            text: '0',
                            onTap: () {
                              controller.addEvent(EventType.dotBall);
                            },
                          ),
                          NumberCard(
                            text: '1',
                            onTap: () {
                              controller.addEvent(EventType.one);
                            },
                          ),
                          NumberCard(
                            text: '2',
                            onTap: () {
                              controller.addEvent(EventType.two);
                            },
                          ),
                          NumberCard(
                            text: '3',
                            onTap: () {
                              controller.addEvent(EventType.three);
                            },
                          ),
                          NumberCard(
                            text: '4',
                            onTap: () {
                              controller.addEvent(EventType.four);
                            },
                          ),
                          NumberCard(
                            text: '5',
                            onTap: () {},
                          ),
                          NumberCard(
                            text: '6',
                            onTap: () {
                              controller.addEvent(EventType.six);
                            },
                          ),
                          InkWell(
                            onTap: () {
                              Get.bottomSheet(
                                  // context: context,
                                  // elevation: 30,
                                  const EndOfIningsDialog());
                            },
                            child: NumberCard(
                              text: '•••',
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
