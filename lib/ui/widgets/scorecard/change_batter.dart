import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/screens/select_opening_players.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/utils.dart';

import '../../../data/controller/scoreboard_controller.dart';
import '../../../data/model/player_model.dart';

class ChangeBatterWidget extends StatefulWidget {
  const ChangeBatterWidget({
    super.key,
  });

  @override
  State<ChangeBatterWidget> createState() => _ChangeBatterWidgetState();
}

class _ChangeBatterWidgetState extends State<ChangeBatterWidget> {
  String outType = 'RO';
  String? playerToOut;
  PlayerModel? selectedBatsman;
  @override
  void initState() {
    super.initState();
    playerToOut = Get.find<ScoreBoardController>().scoreboard.value!.striker.id;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScoreBoardController>();
    final List<PlayerModel> players = [];
    if (controller.scoreboard.value!.currentInnings == 1) {
      players.addAll(controller.scoreboard.value!.team1.players!);
    } else {
      players.addAll(controller.scoreboard.value!.team2.players!);
    }
    players.removeWhere(
        (element) => element.id == controller.scoreboard.value!.striker.id);
    players.removeWhere(
        (element) => element.id == controller.scoreboard.value!.nonstriker.id);

    players.removeWhere((element) => element.batting!.outType.isNotEmpty);
    return SizedBox(
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Wicket Type',
                style: Get.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 18 * Get.textScaleFactor,
                  color: Colors.black,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile.adaptive(
                      value: 'RO',
                      groupValue: outType,
                      onChanged: (e) {
                        setState(() {
                          logger.i(e);
                          outType = e!;
                        });
                      },
                      title: const Text(
                        'Run Out',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile.adaptive(
                      value: 'CA',
                      groupValue: outType,
                      onChanged: (e) {
                        if (controller.events.contains(EventType.noBall)) {
                          errorSnackBar(
                              'No Ball cannot be selected with  Caught');
                          return;
                        }
                        if (controller.events.contains(EventType.six)) {
                          errorSnackBar('Six cannot be selected with  Caught');
                          return;
                        }
                        if (controller.events.contains(EventType.four)) {
                          errorSnackBar('Four cannot be selected with  Caught');
                          return;
                        }
                        if (controller.events.contains(EventType.bye) &&
                            controller.events.contains(EventType.wicket)) {
                          errorSnackBar('Player can be only run out with byes');
                          return;
                        }
                        if (controller.events.contains(EventType.legByes) &&
                            controller.events.contains(EventType.wicket)) {
                          errorSnackBar(
                              'Player can be only run out with Leg Byes');
                          return;
                        }
                        setState(() {
                          outType = e.toString();
                        });
                      },
                      title: const Text(
                        'Caught',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile.adaptive(
                      value: 'bowled',
                      groupValue: outType,
                      onChanged: (e) {
                        if (controller.events.contains(EventType.noBall)) {
                          errorSnackBar(
                              'No Ball cannot be selected with Bowled');
                          return;
                        }
                        // wicket + byes + 1 can only be run through run out
                        if (controller.events.contains(EventType.bye) &&
                            controller.events.contains(EventType.wicket)) {
                          errorSnackBar('Player can be only run out with byes');
                          return;
                        }
                        if (controller.events.contains(EventType.legByes) &&
                            controller.events.contains(EventType.wicket)) {
                          errorSnackBar(
                              'Player can be only run out with Leg Byes');
                          return;
                        }

                        setState(() {
                          logger.i(e);
                          outType = e!;
                        });
                      },
                      title: const Text(
                        'Bowled',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile.adaptive(
                      value: 'ST',
                      groupValue: outType,
                      onChanged: (e) {
                        if (controller.events.contains(EventType.noBall)) {
                          errorSnackBar(
                              'No Ball cannot be selected with Stumped');
                          return;
                        }
                        if (controller.events.contains(EventType.bye) &&
                            controller.events.contains(EventType.wicket)) {
                          errorSnackBar('Player can be only run out with byes');
                          return;
                        }
                        if (controller.events.contains(EventType.legByes) &&
                            controller.events.contains(EventType.wicket)) {
                          errorSnackBar(
                              'Player can be only run out with Leg Byes');
                          return;
                        }
                        setState(() {
                          logger.i(e);
                          outType = e!;
                        });
                      },
                      title: const Text(
                        'Stumped',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile.adaptive(
                      value: 'LBW',
                      groupValue: outType,
                      onChanged: (e) {
                        setState(() {
                          if (controller.events.contains(EventType.noBall)) {
                            errorSnackBar(
                                'No Ball cannot be selected with Leg Before Wicket');
                            return;
                          }
                          if (controller.events.contains(EventType.bye) &&
                              controller.events.contains(EventType.wicket)) {
                            errorSnackBar(
                                'Player can be only run out with byes');
                            return;
                          }
                          if (controller.events.contains(EventType.legByes) &&
                              controller.events.contains(EventType.wicket)) {
                            errorSnackBar(
                                'Player can be only run out with Leg Byes');
                            return;
                          }
                          logger.i("The out type is $e");

                          outType = e!;
                        });
                      },
                      title: const Text(
                        'Leg Before Wicket',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile.adaptive(
                      value: 'HW',
                      groupValue: outType,
                      onChanged: (e) {
                        if (controller.events.contains(EventType.noBall)) {
                          errorSnackBar(
                              'No Ball cannot be selected with Hit Wicket');
                          return;
                        }
                        if (controller.events.contains(EventType.bye) &&
                            controller.events.contains(EventType.wicket)) {
                          errorSnackBar('Player can be only run out with byes');
                          return;
                        }
                        if (controller.events.contains(EventType.legByes) &&
                            controller.events.contains(EventType.wicket)) {
                          errorSnackBar(
                              'Player can be only run out with Leg Byes');
                          return;
                        }
                        setState(() {
                          logger.i(e);
                          outType = e!;
                        });
                      },
                      title: const Text(
                        'Hit Wicket',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              outType == "RO"
                  ? Text(
                      'Choose Player ',
                      style: Get.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 18 * Get.textScaleFactor,
                        color: Colors.black,
                      ),
                    )
                  : const SizedBox(),
              outType == "RO"
                  ? Row(
                      children: [
                        Expanded(
                          child: RadioListTile.adaptive(
                            value: controller.scoreboard.value!.striker.id,
                            groupValue: playerToOut,
                            onChanged: (e) {
                              setState(() {
                                logger.i(e);
                                playerToOut = e!;
                              });
                            },
                            title: Text(
                              controller.scoreboard.value!.striker.name,
                            ),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile.adaptive(
                            value: controller.scoreboard.value!.nonstriker.id,
                            groupValue: playerToOut,
                            onChanged: (e) {
                              setState(() {
                                logger.i(e);
                                playerToOut = e!;
                              });
                            },
                            title: Text(
                                controller.scoreboard.value!.nonstriker.name),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              if (controller.scoreboard.value!.lastBall.wickets < 9)
                PlayerDropDownWidget(
                  onSelect: (e) {
                    setState(() {
                      selectedBatsman = e;
                    });
                      Navigator.of(context).pop();
                  },
                  items: players,
                  selectedValue: selectedBatsman?.name ?? 'Select Batsman',
                  title: 'Select Batsman',

                ),
              PrimaryButton(
                onTap: () {
                  String? batsmanId;
                  if (controller.scoreboard.value!.lastBall.wickets < 9) {
                    if (selectedBatsman == null) {
                      errorSnackBar('Please select a batsman');
                      return;
                    }
                    batsmanId = selectedBatsman!.id;
                  } else {
                    batsmanId = outType == 'RO'
                        ? playerToOut
                        : controller.scoreboard.value!.striker.id;
                  }
                  Navigator.pop(context, {
                    'batsmanId': batsmanId,
                    'outType': outType,
                    'playerToOut': outType == 'RO' ? playerToOut : null,
                  });
                },
                title: 'Submit',
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BowlerStat extends StatelessWidget {
  final String title;
  final String value;
  const BowlerStat({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
