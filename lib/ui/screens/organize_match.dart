import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/matchup_model.dart';
import 'package:gully_app/data/model/team_model.dart';
import 'package:gully_app/data/model/tournament_model.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:gully_app/utils/FallbackImageProvider.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:intl/intl.dart';

import '../../data/controller/auth_controller.dart';
import '../../data/controller/tournament_controller.dart';
import '../../data/model/points_table_model.dart';
import '../../utils/CustomItemCheckbox.dart';
import 'current_tournament_list.dart';

class SelectOrganizeTeam extends StatefulWidget {
  final TournamentModel? tournament;
  final String? round;
  final String? title;
  final MatchupModel? match;
  final String? tourId;
  const SelectOrganizeTeam(
      {super.key,
      this.title,
      this.tournament,
      this.round,
      this.match,
      this.tourId});

  @override
  State<SelectOrganizeTeam> createState() => _SelectOrganizeTeamState();
}

class _SelectOrganizeTeamState extends State<SelectOrganizeTeam> {
  TeamModel? selectedTeam1;
  TeamModel? selectedTeam2;
  // List<TeamModel> leftSideteams = [];
  // List<TeamModel> rightSideteams = [];
  List<TeamModel> totalteams = [];
  DateTime? selectedDate;
  String? selectedRound;
  @override
  void initState() {
    super.initState();
    getPlayers();
  }

  Future<void> getPlayers() async {
    final controller = Get.find<TournamentController>();
    final teams = await (widget.tourId != null
        ? controller.getRegisteredTeams(widget.tourId!)
        : controller.getRegisteredTeams(widget.tournament!.id));

    if (teams.isEmpty) {
      errorSnackBar('Please register a team first').then((_) => Get.back());
      return;
    }
    setState(() {
      totalteams = teams;
    });

    if (widget.tourId != null) {
      logger.d("Match data is available: ${widget.match}");
      logger.d("Total teams: $totalteams");
      setState(() {
        selectedTeam1 = totalteams.firstWhereOrNull(
          (team) => team.id == widget.match!.team1.id,
        );
        selectedTeam2 = totalteams.firstWhereOrNull(
          (team) => team.id == widget.match!.team2.id,
        );
        if (widget.match!.matchDate != null) {
          selectedDate = widget.match!.matchDate;
        } else {
          selectedDate =
              widget.tournament?.tournamentStartDateTime ?? DateTime.now();
        }
        if (widget.match != null) {
          selectedRound = widget.match!.round;
        }
        logger.d("Selected Team 1: ${selectedTeam1?.name}");
        logger.d("Selected Team 2: ${selectedTeam2?.name}");
        logger.d("Selected Date: $selectedDate");
        logger.d("Selected Round: $selectedRound");
      });
    } else {
      selectedDate =
          widget.tournament?.tournamentStartDateTime ?? DateTime.now();
    }
    // logger.d("Selected Round: $selectedRound");
    // logger.d("The Total Teams Are:${totalteams.length}");
    // logger.d('TEAMS: $teams');
  }

  void RoundSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InputRoundNumber(
          existingRound: selectedRound,
          onItemSelected: (value) {
            setState(() {
              selectedRound = value;
              logger.d("Selected Round: $selectedRound");
            });
          },
        );
      },
    );
  }

  List<TeamModel> selectedTeamsForElimination = [];

  Widget _buildCustomCheckbox({
    required bool isSelected,
    required TeamModel team,
    required Function(bool?) onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!isSelected),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isSelected ? AppTheme.secondaryYellowColor : Colors.grey[300]!,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.white : Colors.grey[50],
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected
                      ? AppTheme.secondaryYellowColor
                      : Colors.grey[400]!,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4),
                color:
                    isSelected ? AppTheme.secondaryYellowColor : Colors.white,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(team.toImageUrl()),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                team.name,
                style: Get.textTheme.titleMedium?.copyWith(
                  color: Colors.black87,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showEliminationBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          height: Get.height * 0.95,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.primaryColor),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Eliminate Teams',
                            style: Get.textTheme.titleLarge
                                ?.copyWith(color: Colors.black, fontSize: 20),
                          ),
                        ),
                      ),
                      if (selectedTeamsForElimination.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${selectedTeamsForElimination.length} selected',
                            style: Get.textTheme.bodyMedium?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: totalteams.length,
                    itemBuilder: (context, index) {
                      final team = totalteams[index];
                      return CustomItemCheckbox(
                        isSelected: selectedTeamsForElimination.contains(team),
                        title: team.name,
                        imageUrl: team.toImageUrl(),
                        selectedColor: AppTheme.primaryColor,
                        titleStyle: Get.textTheme.titleMedium,
                        onTap: () {
                          setState(() {
                            if (selectedTeamsForElimination.contains(team)) {
                              selectedTeamsForElimination.remove(team);
                            } else {
                              selectedTeamsForElimination.add(team);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: PrimaryButton(
                    onTap: () async {
                      if (selectedTeamsForElimination.isEmpty) {
                        errorSnackBar('Please select teams to eliminate');
                        return;
                      }
                    },
                    title: 'Eliminate Teams',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
                              child: Text(
                                  widget.match != null
                                      ? 'Edit Matchup'
                                      : 'Organize',
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
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: DropdownButton<TeamModel?>(
                                            value: selectedTeam1,
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            padding: EdgeInsets.zero,
                                            iconSize: 24,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            alignment: Alignment.bottomCenter,
                                            iconEnabledColor: Colors.black,
                                            style: const TextStyle(
                                                color: Colors.black),
                                            underline: const SizedBox(),
                                            onChanged: (TeamModel? newValue) {
                                              setState(() {
                                                selectedTeam1 = newValue!;
                                              });
                                            },
                                            items: totalteams.map<
                                                DropdownMenuItem<TeamModel?>>(
                                              (TeamModel value) {
                                                return DropdownMenuItem<
                                                    TeamModel?>(
                                                  value: value,
                                                  child: SizedBox(
                                                    width: 80,
                                                    child: Text(
                                                      value.name,
                                                      style: Get
                                                          .textTheme.labelMedium
                                                          ?.copyWith(
                                                              fontSize: 12),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ).toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    Chip(
                                      label: Text('VS',
                                          style: Get.textTheme.labelLarge
                                              ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                      backgroundColor:
                                          AppTheme.secondaryYellowColor,
                                      side: BorderSide.none,
                                    ),
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
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: DropdownButton<TeamModel?>(
                                            value: selectedTeam2,
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            padding: EdgeInsets.zero,
                                            iconSize: 24,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            alignment: Alignment.bottomCenter,
                                            iconEnabledColor: Colors.black,
                                            style: const TextStyle(
                                                color: Colors.black),
                                            underline: const SizedBox(),
                                            onChanged: (TeamModel? newValue) {
                                              setState(() {
                                                selectedTeam2 = newValue!;
                                              });
                                            },
                                            items: totalteams.map<
                                                DropdownMenuItem<TeamModel?>>(
                                              (TeamModel? value) {
                                                return DropdownMenuItem<
                                                    TeamModel?>(
                                                  value: value,
                                                  child: SizedBox(
                                                    width: 80,
                                                    child: Text(
                                                      value!.name,
                                                      style: Get
                                                          .textTheme.labelMedium
                                                          ?.copyWith(
                                                              fontSize: 12),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ).toList(),
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
                                    final date = await showDatePicker(
                                        context: context,
                                        initialDate: widget.tourId != null
                                            ? controller.startDateForPicker
                                            : widget.tournament!
                                                .tournamentStartDateTime,
                                        firstDate: widget.tourId != null
                                            ? controller.startDateForPicker ??
                                                DateTime.now()
                                            : widget.tournament!
                                                .tournamentStartDateTime,
                                        lastDate: widget.tourId != null
                                            ? controller.endDateForPicker ??
                                                DateTime.now()
                                            : widget.tournament!
                                                .tournamentEndDateTime);
                                    setState(() {
                                      if (date != null) {
                                        if (selectedDate != null) {
                                          selectedDate = DateTime(
                                              date.year,
                                              date.month,
                                              date.day,
                                              selectedDate!.hour,
                                              selectedDate!.minute);
                                        } else {
                                          selectedDate = date;
                                        }
                                      }
                                    });
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
                                const SizedBox(width: 60),
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
                            InkWell(
                              onTap: RoundSelectionDialog,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      selectedRound ?? 'Select Round',
                                      style: Get.textTheme.bodyMedium,
                                    ),
                                    const Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: Get.height * 0.02),
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
                                if (selectedTeam1 == selectedTeam2) {
                                  errorSnackBar(
                                      'Please select different teams on Both the side');
                                  return;
                                }
                                if (widget.tourId != null) {
                                  final Map<String, dynamic> obj = {
                                    'tournamentId': widget.tourId,
                                    'team1ID': selectedTeam1!.id,
                                    'team2ID': selectedTeam2!.id,
                                    'round': selectedRound,
                                    'matchNo': 1,
                                    'dateTime': selectedDate!.toIso8601String(),
                                  };
                                  logger.d("Selected Date is:$selectedDate");
                                  bool response = await controller.editMatch(
                                      obj, widget.match!.id);
                                  logger.d(response);
                                  if (response) {
                                    successSnackBar('Matchup Edited')
                                        .then((value) => Get.back());
                                  }
                                }

                                final response = await controller.createMatchup(
                                    widget.tournament!.id,
                                    selectedTeam1!.id,
                                    selectedTeam2!.id,
                                    selectedDate!,
                                    1,
                                    selectedRound ?? '');
                                logger.d(response);
                                if (response) {
                                  successSnackBar('Matchup created')
                                      .then((value) => Get.back());
                                }
                                // Get.to(() => const ViewMatchupsScreen());
                              },
                              title: 'Submit',
                            ),

                            SizedBox(height: Get.height * 0.02),
                            PrimaryButton(
                              onTap: showEliminationBottomSheet,
                              title: 'Eliminate Teams',
                            ),
                            SizedBox(height: Get.height * 0.02),
                            PrimaryButton(
                              // onTap: showEliminationBottomSheet,
                              onTap: () {
                                logger.d("The Tournament id is:${widget.tournament!.id}");
                                Get.to(() => PointsTable(
                                  tournamentId: widget.tournament!.id,
                                  tournamentName:
                                  widget.tournament!.tournamentName,
                                ));
                              },
                              title: 'Points Table',
                            ),
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

class PointsTable extends StatelessWidget {
  final String tournamentId;
  final String tournamentName;
  const PointsTable({super.key, required this.tournamentId, required this.tournamentName});

  @override
  Widget build(BuildContext context) {
    final TournamentController controller = Get.find<TournamentController>();
    return Scaffold(
      appBar: AppBar(
        title: Text("${tournamentName.capitalize} Points Table",
            style: const TextStyle(fontSize: 18, color: Colors.black),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<PointTableModel>>(
        future: controller.tournamentPointsTable(tournamentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child:Text("Something went wrong")
            );
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: Get.width,
              child: Column(
                children: [
                  Container(
                    color: Colors.black,
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        tableHeader('POS', flex: 2),
                        tableHeader('Team', flex: 4),
                        tableHeader('Played', flex: 2),
                        tableHeader('Win', flex: 2),
                        tableHeader('Loss', flex: 2),
                        tableHeader('Ties', flex: 2),
                        tableHeader('Points', flex: 2),
                        tableHeader('NRR', flex: 2),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(() => ListView.builder(
                          itemCount: controller.points_table.length,
                          itemBuilder: (context, index) {
                            final team = controller.points_table[index];
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  teamTableData(team.rank.toString(), flex: 2),
                                  const SizedBox(width: 2,),
                                  teamData(team, flex: 4),
                                  teamTableData(team.matchesPlayed.toString(),
                                      flex: 2),
                                  teamTableData(team.wins.toString(), flex: 2),
                                  teamTableData(team.losses.toString(), flex: 2),
                                  teamTableData(team.ties.toString(), flex: 2),
                                  teamTableData(team.points.toString(), flex: 2),
                                  teamTableData(
                                      team.netRunRate?.toStringAsFixed(3) ??'0',
                                      flex: 2),
                                ],
                              ),
                            );
                          },
                        )),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget tableHeader(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 10,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget teamTableData(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget teamData(PointTableModel team, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Flexible(
        child: Text(
          team.teamName.capitalize,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}
