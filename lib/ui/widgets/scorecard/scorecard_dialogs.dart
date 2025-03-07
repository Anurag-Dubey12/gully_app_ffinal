import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/scoreboard_controller.dart';
import 'package:gully_app/data/model/player_model.dart';
import 'package:gully_app/ui/screens/select_opening_players.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/utils.dart';

import '../primary_button.dart';

class EndOfIningsDialog extends StatefulWidget {
  const EndOfIningsDialog({
    super.key,
  });

  @override
  State<EndOfIningsDialog> createState() => _EndOfIningsDialogState();
}

class _EndOfIningsDialogState extends State<EndOfIningsDialog> {
  PlayerModel? striker;
  PlayerModel? nonStriker;
  PlayerModel? openingBowler;
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScoreBoardController>();
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
                  const Center(
                    child: Text('End of first inning',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w900)),
                  ),
                  const SizedBox(height: 30),
                  const Text(' Select following for Innings 2',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 30),
                  const Text('Striker',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  PlayerDropDownWidget(
                    title: 'Select  Striker',
                    onSelect: (e) {
                      setState(() {
                        if (e.id == nonStriker?.id) {
                          errorSnackBar(
                              'Striker and Non Striker cannot be same');
                          return;
                        }
                        striker = e;
                      });
                      Navigator.of(context).pop();
                      // Get.close();
                    },
                    selectedValue: striker?.name.toUpperCase(),
                    items: controller.scoreboard.value!.team2.players!,
                  ),
                  const SizedBox(height: 20),
                  const Text('Non-Striker',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  PlayerDropDownWidget(
                      title: 'Select Non Striker',
                      onSelect: (e) {
                        setState(() {
                          if (e.id == striker?.id) {
                            errorSnackBar(
                                'Striker and Non Striker cannot be same');
                            return;
                          }
                          nonStriker = e;
                        });
                        Navigator.of(context).pop();
                        // Get.close();
                        // Get.back();
                      },
                      selectedValue: nonStriker?.name.toUpperCase(),
                      items: controller.scoreboard.value!.team2.players!),
                  const SizedBox(height: 20),
                  const Text('Opening Bowler',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  PlayerDropDownWidget(
                      title: 'Select Opening Bowler',
                      onSelect: (e) {
                        setState(() {
                          openingBowler = e;
                        });
                        Navigator.of(context).pop();
                        // Get.close();
                        // Get.back();
                      },
                      selectedValue: openingBowler?.name.toUpperCase(),
                      items: controller.scoreboard.value!.team1.players!),
                  const SizedBox(height: 30),
                  PrimaryButton(
                    onTap: () {
                      if (striker == null || nonStriker == null) {
                        errorSnackBar('Please select both the opening batsmen');
                        return;
                      }
                      if (openingBowler == null) {
                        errorSnackBar('Please select opening bowler');
                        return;
                      }
                      logger.i('Striker: ${striker!.name}');
                      controller.endOfInnings(
                        striker: striker!,
                        nonStriker: nonStriker!,
                        bowler: openingBowler!,
                      );
                      Get.close();
                    },
                    title: 'Start Innings 2',
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ));
  }
}

class RetirePlayerDialog extends StatefulWidget {
  const RetirePlayerDialog({
    super.key,
  });

  @override
  State<RetirePlayerDialog> createState() => _RetirePlayerDialogState();
}

class _RetirePlayerDialogState extends State<RetirePlayerDialog> {
  String? playerToRetire;
  PlayerModel? newPlayer;
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
                  Text(
                      "${controller.scoreboard.value!.team1.name} vs ${controller.scoreboard.value!.team2.name}",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Select Player to retire'),
                  ),
                  SizedBox(
                    width: Get.width,
                    height: 70,
                    child: Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            value: controller.scoreboard.value!.striker.id,
                            groupValue: playerToRetire,
                            title:
                                Text(controller.scoreboard.value!.striker.name),
                            onChanged: (e) {
                              setState(() {
                                playerToRetire = e.toString();
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            value: controller.scoreboard.value!.nonstriker.id,
                            groupValue: playerToRetire,
                            title: Text(
                                controller.scoreboard.value!.nonstriker.name),
                            onChanged: (e) {
                              setState(() {
                                playerToRetire = e.toString();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Replace By'),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<PlayerModel?>(
                      value: newPlayer,
                      icon: const Icon(Icons.arrow_drop_down),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      iconSize: 24,
                      // menuMaxHeight: 8,
                      borderRadius: BorderRadius.circular(10),
                      alignment: Alignment.bottomCenter,
                      // elevation: 16,
                      iconEnabledColor: Colors.black,
                      isExpanded: true,
                      style: const TextStyle(color: Colors.black),
                      underline: const SizedBox(),
                      onChanged: (PlayerModel? newValue) {
                        setState(() {
                          newPlayer = newValue!;
                        });
                      },
                      items: players.map<DropdownMenuItem<PlayerModel?>>(
                          (PlayerModel value) {
                        return DropdownMenuItem<PlayerModel?>(
                          value: value,
                          child: Text(value.name,
                              style: Get.textTheme.labelMedium),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  PrimaryButton(
                    onTap: () async {
                      if (playerToRetire == null || newPlayer == null) {
                        errorSnackBar(
                            'Please select player to retire and new player to replace');
                        return;
                      }

                      bool res = await controller.addEvent(EventType.retire,
                          playerToRetire: playerToRetire,
                          selectedBatsmanId: newPlayer!.id);
                      if (res) {
                        // Get.back();
                        Get.close();
                      }
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

