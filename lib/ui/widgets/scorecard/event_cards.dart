import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/extras_model.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:gully_app/ui/widgets/scorecard/change_bowler.dart';
import 'package:gully_app/utils/app_logger.dart';

import '../../../data/controller/scoreboard_controller.dart';
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
                  const Text('Partnership',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  ListView.builder(
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
                                        Text(partnerships.values
                                            .elementAt(index)
                                            .player1
                                            .name),
                                        const SizedBox(height: 10),
                                        Text(partnerships.values
                                            .elementAt(index)
                                            .player1
                                            .batting!
                                            .runs
                                            .toString())
                                      ],
                                    )),
                                const SizedBox(width: 10),
                                Expanded(
                                    child: Column(
                                  children: [
                                    Text(
                                        '(${partnerships.values.elementAt(index).runs})',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.green)),
                                    Text(
                                        '${partnerships.values.elementAt(index).balls} balls',
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
                                        Text(partnerships.values
                                            .elementAt(index)
                                            .player2
                                            .name),
                                        Text(partnerships.values
                                            .elementAt(index)
                                            .player2
                                            .batting!
                                            .runs
                                            .toString()),
                                        const SizedBox(height: 10),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        );
                      }),
                  const SizedBox(height: 30),
                  PrimaryButton(
                    onTap: () {},
                    title: 'Done',
                  )
                ],
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
                    onTap: () {},
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
  const NumberCard({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          focusColor: Colors.amber,
          hoverColor: Colors.amber,
          splashColor: Colors.amber,
          onTap: onTap,
          child: Ink(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    Border.all(color: AppTheme.secondaryYellowColor, width: 2)),
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
                    title: 'Leg bes',
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
                  SizedBox(
                      // width: 100,
                      height: 40,
                      child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                AppTheme.primaryColor),
                          ),
                          onPressed: () {
                            Get.bottomSheet(const RetirePlayerDialog());
                          },
                          child: const Text('Retire',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500)))),
                  const SizedBox(width: 10),
                  SizedBox(
                      // width: 100,
                      height: 40,
                      child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                AppTheme.primaryColor),
                          ),
                          onPressed: () {
                            controller.addEvent(EventType.changeStriker);
                          },
                          child: const Text('Swap Batsman',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500)))),
                  SizedBox(
                      // width: 120,
                      height: 40,
                      child: IconButton(
                          onPressed: () {
                            // if (!(controller.scoreboard.value?.overCompleted ??
                            //     false)) {
                            //   errorSnackBar('Please complete the over first');
                            //   return;
                            // }
                            showModalBottomSheet(
                                context: Get.context!,
                                builder: (c) => const ChangeBowlerWidget(),
                                enableDrag: true,
                                isDismissible: true);
                          },
                          icon: Image.asset('assets/images/change.png'))),
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
                      controller.addEventType(eventType);
                    } else {
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
                  fontSize: 12 * Get.textScaleFactor)),
        ],
      ),
    );
  }
}
