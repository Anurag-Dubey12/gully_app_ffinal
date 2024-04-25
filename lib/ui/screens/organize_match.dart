import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/team_model.dart';
import 'package:gully_app/data/model/tournament_model.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:intl/intl.dart';

import '../../data/controller/tournament_controller.dart';

class SelectOrganizeTeam extends StatefulWidget {
  final TournamentModel tournament;
  final int round;
  final String? title;
  const SelectOrganizeTeam(
      {super.key, this.title, required this.tournament, required this.round});

  @override
  State<SelectOrganizeTeam> createState() => _SelectOrganizeTeamState();
}

class _SelectOrganizeTeamState extends State<SelectOrganizeTeam> {
  TeamModel? selectedTeam1;
  TeamModel? selectedTeam2;
  List<TeamModel> leftSideteams = [];
  List<TeamModel> rightSideteams = [];
  DateTime? selectedDate;
  @override
  void initState() {
    super.initState();
    getPlayers();
  }

  Future<void> getPlayers() async {
    final controller = Get.find<TournamentController>();
    final teams = await controller.getRegisteredTeams(widget.tournament.id);
    if (teams.isEmpty) {
      errorSnackBar('Please register a team first').then((value) => Get.back());
    }
    logger.d('TEAMS: $teams');
    // divide teams into two sides
    leftSideteams = teams.sublist(0, teams.length ~/ 2);
    rightSideteams = teams.sublist(teams.length ~/ 2, teams.length);

    setState(() {
      // selectedTeam1 = leftSideteams[0];
      // if (rightSideteams.length > 1) {
      //   selectedTeam2 = rightSideteams[1];
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TournamentController>();
    return GradientBuilder(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              child: SizedBox(
                width: Get.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10, top: 30),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: BackButton(
                            color: Colors.white,
                          )),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Get.width * 0.07,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text('Organize',
                                  style: Get.textTheme.headlineLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(height: Get.height * 0.04),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 43,
                                        backgroundImage: NetworkImage(
                                          selectedTeam1?.toImageUrl() ?? "",
                                        ),
                                        backgroundColor: Colors.grey.shade300,
                                      ),
                                      const SizedBox(height: 20),
                                      DecoratedBox(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: DropdownButton<TeamModel?>(
                                            value: selectedTeam1,
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            padding: EdgeInsets.zero,
                                            iconSize: 24,
                                            // menuMaxHeight: 8,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            alignment: Alignment.bottomCenter,
                                            // elevation: 16,
                                            iconEnabledColor: Colors.black,
                                            style: const TextStyle(
                                                color: Colors.black),
                                            underline: const SizedBox(),
                                            onChanged: (TeamModel? newValue) {
                                              setState(() {
                                                selectedTeam1 = newValue!;
                                              });
                                            },
                                            items: leftSideteams.map<
                                                    DropdownMenuItem<
                                                        TeamModel?>>(
                                                (TeamModel value) {
                                              return DropdownMenuItem<
                                                  TeamModel?>(
                                                value: value,
                                                child: Text(value.name,
                                                    style: Get
                                                        .textTheme.labelMedium),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // const Spacer(),
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Chip(
                                        label: Text('VS',
                                            style: Get.textTheme.labelLarge
                                                ?.copyWith(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                        backgroundColor:
                                            AppTheme.secondaryYellowColor,
                                        side: BorderSide.none),
                                  ],
                                ),

                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 43,
                                        backgroundColor: Colors.white,
                                        backgroundImage: NetworkImage(
                                            selectedTeam2?.toImageUrl() ?? ""),
                                      ),
                                      const SizedBox(height: 20),
                                      DecoratedBox(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          child: DropdownButton<TeamModel?>(
                                            value: selectedTeam2,
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            padding: EdgeInsets.zero,
                                            iconSize: 24,
                                            // menuMaxHeight: 8,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            alignment: Alignment.bottomCenter,
                                            // elevation: 16,
                                            iconEnabledColor: Colors.black,
                                            style: const TextStyle(
                                                color: Colors.black),
                                            underline: const SizedBox(),
                                            onChanged: (TeamModel? newValue) {
                                              setState(() {
                                                selectedTeam2 = newValue!;
                                              });
                                            },
                                            items: rightSideteams.map<
                                                    DropdownMenuItem<
                                                        TeamModel?>>(
                                                (TeamModel? value) {
                                              return DropdownMenuItem<
                                                  TeamModel?>(
                                                value: value,
                                                child: Text(value!.name,
                                                    style: Get
                                                        .textTheme.labelMedium),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: Get.height * 0.03),
                            Row(
                              children: [
                                const Spacer(),
                                InkWell(
                                  onTap: () async {
                                    try {
                                      logger.d(widget
                                          .tournament.tournamentStartDateTime);
                                      final date = await showDatePicker(
                                          context: context,
                                          initialDate: widget.tournament
                                              .tournamentStartDateTime,
                                          firstDate: widget.tournament
                                              .tournamentStartDateTime,
                                          lastDate: widget.tournament
                                              .tournamentEndDateTime);
                                      setState(() {
                                        if (selectedDate != null) {
                                          selectedDate = DateTime(
                                              date!.year,
                                              date.month,
                                              date.day,
                                              selectedDate!.hour,
                                              selectedDate!.minute);
                                        } else {
                                          selectedDate = date;
                                        }
                                      });
                                    } catch (e) {
                                      logger.d(e);
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                              selectedDate == null
                                                  ? 'Select Date'
                                                  : DateFormat('dd MMM yyyy')
                                                      .format(selectedDate!),
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500)),
                                          const SizedBox(width: 10),
                                          const Icon(
                                            Icons.calendar_month,
                                            size: 18,
                                            color:
                                                AppTheme.secondaryYellowColor,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                InkWell(
                                  onTap: () async {
                                    final time = await showTimePicker(
                                        context: context,
                                        initialEntryMode:
                                            TimePickerEntryMode.dialOnly,
                                        initialTime: TimeOfDay.now());
                                    if (time != null) {
                                      setState(() {
                                        selectedDate = DateTime(
                                            selectedDate!.year,
                                            selectedDate!.month,
                                            selectedDate!.day,
                                            time.hour,
                                            time.minute);
                                      });
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            selectedDate == null
                                                ? 'Select Time'
                                                : DateFormat('hh:mm a')
                                                    .format(selectedDate!),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(width: 10),
                                          const Icon(
                                            Icons.timer_sharp,
                                            size: 18,
                                            color:
                                                AppTheme.secondaryYellowColor,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                            SizedBox(height: Get.height * 0.03),
                            PrimaryButton(
                              onTap: () async {
                                if (selectedDate == null) {
                                  errorSnackBar('Please select a date');
                                  return;
                                }
                                if (selectedTeam1 == null ||
                                    selectedTeam2 == null) {
                                  errorSnackBar('Please select teams');
                                  return;
                                }
                                final response = await controller.createMatchup(
                                    widget.tournament.id,
                                    selectedTeam1!.id,
                                    selectedTeam2!.id,
                                    selectedDate!,
                                    1,
                                    widget.round);
                                logger.d(response);
                                if (response) {
                                  successSnackBar('Matchup created')
                                      .then((value) => Get.back());
                                }
                                // Get.to(() => const ViewMatchupsScreen());
                              },
                              title: 'Submit',
                            )
                          ],
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
