import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/extras_model.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/custom_text_field.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';

import '../../../data/controller/scoreboard_controller.dart';
import 'scorecard_dialogs.dart';

class PartnershipDialog extends StatelessWidget {
  const PartnershipDialog({super.key});

  @override
  Widget build(BuildContext context) {
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
                  SizedBox(
                    width: Get.width,
                    // height: 140,
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Rohit Sharma'),
                                SizedBox(height: 10),
                                CustomTextField()
                              ],
                            )),
                        SizedBox(width: 10),
                        Expanded(
                            child: Column(
                          children: [
                            Text('124',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.green)),
                            Text('(124)',
                                style: TextStyle(
                                  fontSize: 13,
                                )),
                          ],
                        )),
                        Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Rohit Sharma'),
                                SizedBox(height: 10),
                                CustomTextField()
                              ],
                            )),
                      ],
                    ),
                  ),
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
                    eventType: EventType.dotBall,
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
                      width: 100,
                      height: 40,
                      child: PrimaryButton(
                          onTap: () {
                            Get.bottomSheet(const RetirePlayerDialog());
                          },
                          title: 'Retire')),
                  const SizedBox(width: 10),
                  SizedBox(
                      width: 120,
                      height: 40,
                      child: PrimaryButton(
                          onTap: () {
                            controller.addEvent(EventType.changeStriker);
                          },
                          title: 'Swap Batsman')),
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
