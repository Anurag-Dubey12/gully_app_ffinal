import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/matchup_model.dart';
import 'package:gully_app/data/model/team_model.dart';
import 'package:gully_app/ui/screens/select_opening_players.dart';
import 'package:gully_app/ui/widgets/custom_text_field.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/utils.dart';

class SelectOpeningTeam extends StatefulWidget {
  final MatchupModel match;
  const SelectOpeningTeam({super.key, required this.match});

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
    hostTeam = widget.match.team1;
    visitorTeam = widget.match.team2;
    tossWonBy = widget.match.team1.id;
    optedTo = 'Bat';
  }

  @override
  Widget build(BuildContext context) {
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
                });
              },
              items: [widget.match.team1, widget.match.team2]
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
                            value: widget.match.team1.id,
                            groupValue: tossWonBy,
                            onChanged: (value) {
                              setState(() {
                                tossWonBy = value;
                              });
                            },
                          ),
                          Text(widget.match.team1.name),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: widget.match.team2.id,
                            groupValue: tossWonBy,
                            onChanged: (value) {
                              setState(() {
                                tossWonBy = value;
                              });
                            },
                          ),
                          Text(widget.match.team2.name),
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
            textInputType: TextInputType.number,
            controller: totalOvers,
          ),
          const SizedBox(height: 20),
          PrimaryButton(onTap: () {
            if (hostTeam == null ||
                visitorTeam == null ||
                tossWonBy == null ||
                optedTo == null) {
              return;
            }
            late TeamModel battingTeam;
            late TeamModel bowlingTeam;

            if (tossWonBy == hostTeam!.id) {
              if (optedTo == 'Bat') {
                battingTeam = hostTeam!;
                bowlingTeam = visitorTeam!;
              } else {
                battingTeam = visitorTeam!;
                bowlingTeam = hostTeam!;
              }
            } else {
              if (optedTo == 'Bat') {
                battingTeam = visitorTeam!;
                bowlingTeam = hostTeam!;
              } else {
                battingTeam = visitorTeam!;
                bowlingTeam = hostTeam!;
              }
            }
            if (!totalOvers.text.isNum) {
              errorSnackBar('Please enter valid overs');
              return;
            }
            Get.off(() => SelectOpeningPlayer(
                match: widget.match,
                battingTeam: battingTeam,
                bowlingTeam: bowlingTeam,
                tossWonBy: tossWonBy!,
                electedTo: optedTo!,
                overs: 10));
          })
        ],
      ),
    ));
  }
}
