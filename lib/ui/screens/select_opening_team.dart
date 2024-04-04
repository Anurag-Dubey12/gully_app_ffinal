import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/team_model.dart';
import 'package:gully_app/ui/screens/select_opening_players.dart';
import 'package:gully_app/ui/widgets/custom_text_field.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/utils.dart';

import '../../data/controller/scoreboard_controller.dart';

class SelectOpeningTeam extends StatefulWidget {
  final bool isTournament;
  const SelectOpeningTeam({super.key, required this.isTournament});

  @override
  State<SelectOpeningTeam> createState() => _SelectOpeningTeamState();
}

class _SelectOpeningTeamState extends State<SelectOpeningTeam> {
  TeamModel? hostTeam;
  TeamModel? visitorTeam;
  String? tossWonBy;
  String? optedTo;
  TextEditingController totalOvers = TextEditingController();
  @override
  void initState() {
    super.initState();
    logger.d('isTournament ${widget.isTournament}');

    optedTo = 'Bat';
  }

  @override
  void dispose() {
    super.dispose();
    totalOvers.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scoreBoardController = Get.find<ScoreBoardController>();
    final match = scoreBoardController.match!;
    return GradientBuilder(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Select Opening Team',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 24)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text('Host Team',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton<TeamModel?>(
              value: hostTeam,

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
              onChanged: (TeamModel? newValue) {
                setState(() {
                  hostTeam = newValue;
                  if (visitorTeam == hostTeam) {
                    visitorTeam = null;
                  }
                  if (hostTeam!.id == match.team1.id) {
                    visitorTeam = match.team2;
                  } else {
                    visitorTeam = match.team1;
                  }
                });
              },
              items: [match.team1, match.team2]
                  .map<DropdownMenuItem<TeamModel?>>((TeamModel value) {
                return DropdownMenuItem<TeamModel?>(
                  value: value,
                  child: Text(value.name, style: Get.textTheme.labelMedium),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Toss won by?',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Radio(
                            value: match.team1.id,
                            groupValue: tossWonBy,
                            onChanged: (value) {
                              setState(() {
                                tossWonBy = value;
                              });
                            },
                          ),
                          Text(match.team1.name),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: match.team2.id,
                            groupValue: tossWonBy,
                            onChanged: (value) {
                              setState(() {
                                tossWonBy = value;
                              });
                            },
                          ),
                          Text(match.team2.name),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Opted to?',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Radio(
                            groupValue: optedTo,
                            value: 'Bat',
                            onChanged: (value) {
                              setState(() {
                                optedTo = value;
                              });
                            },
                          ),
                          const Text('Bat'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: 'Bowl',
                            groupValue: optedTo,
                            onChanged: (value) {
                              setState(() {
                                logger.d(value);
                                optedTo = value;
                              });
                            },
                          ),
                          const Text('Bowl'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Total Overs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          CustomTextField(
            filled: true,
            hintText: 'Enter total overs',
            maxLen: 3,
            textInputType: TextInputType.number,
            controller: totalOvers,
          ),
          const SizedBox(height: 20),
          PrimaryButton(onTap: () {
            if (hostTeam == null || visitorTeam == null) {
              errorSnackBar('Please select Host team');
              return;
            }
            if (tossWonBy == null || optedTo == null) {
              errorSnackBar('Please select toss won by and opted to');
              return;
            }
            late TeamModel battingTeam;
            late TeamModel bowlingTeam;

            if (tossWonBy == match.team1.id && optedTo == 'Bat') {
              battingTeam = match.team1;
              bowlingTeam = match.team2;
            } else if (tossWonBy == match.team1.id && optedTo == 'Bowl') {
              battingTeam = match.team2;
              bowlingTeam = match.team1;
            } else if (tossWonBy == match.team2.id && optedTo == 'Bat') {
              battingTeam = match.team2;
              bowlingTeam = match.team1;
            } else {
              logger.d('visitor team won the toss');
              logger.d('visitor team ${visitorTeam?.name}');
              logger.d('Host team ${hostTeam?.name}');
              battingTeam = match.team1;
              bowlingTeam = match.team2;
            }
            setState(() {});
            if (totalOvers.text.isEmpty) {
              errorSnackBar('Please enter total overs');
              return;
            }
            if (!totalOvers.text.isNumericOnly) {
              errorSnackBar('Please enter valid overs!');
              return;
            }

            if ((int.tryParse(totalOvers.text) ?? 0) <= 0) {
              errorSnackBar('Please enter valid overs');
              return;
            }
            if (int.parse(totalOvers.text) % 1 != 0) {
              errorSnackBar('Please enter valid overs');
              return;
            }
            logger.i('is tournament${widget.isTournament}');

            Get.off(() => SelectOpeningPlayer(
                match: match,
                battingTeam: battingTeam,
                bowlingTeam: bowlingTeam,
                tossWonBy: tossWonBy!,
                electedTo: optedTo!,
                isTournament: widget.isTournament,
                overs: int.parse(totalOvers.text)));
          })
        ],
      ),
    ));
  }
}
