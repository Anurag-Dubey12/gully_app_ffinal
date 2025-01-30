import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/matchup_model.dart';
import 'package:gully_app/data/model/team_model.dart';
import 'package:gully_app/data/model/tournament_model.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:intl/intl.dart';
import '../../data/controller/misc_controller.dart';
import '../../data/controller/tournament_controller.dart';
import '../widgets/dialogs/TeamEliminationBottomSheet.dart';
import 'current_tournament_list.dart';

class SelectOrganizeTeam extends StatefulWidget {
  final TournamentModel? tournament;
  final String? round;
  final String? title;
  final MatchupModel? match;
  final TournamentModel? tourId;
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
  List<TeamModel> totalteams = [];
  List<TeamModel> eliminatedTeams = [];
  List<String> eliminatedTeamIds = [];
  String selectedFilter = 'all';
  DateTime? selectedDate;
  String? selectedRound;
  String? selectedAuthority;
  List<DropdownMenuItem<String>> authorityItems = [];
  List<String> selectedTeamsForElimination = [];
  final bool iscompleted = false;
  @override
  void initState() {
    super.initState();
    getPlayers();
    if (widget.tournament != null) {
      selectedAuthority = widget.tournament?.user.id;
      addAuthorityItem(
          widget.tournament!.user.id, widget.tournament!.user.fullName);
      if (widget.tournament?.coHost1 != null || widget.tourId != null) {
        addAuthorityItem(widget.tournament!.coHost1!.id,
            widget.tournament!.coHost1!.fullName);
      }
      if (widget.tournament?.coHost2 != null || widget.tourId != null) {
        addAuthorityItem(widget.tournament!.coHost2!.id,
            widget.tournament!.coHost2!.fullName);
      }
    }
    if (widget.tourId != null) {
      selectedAuthority = widget.match?.matchAuthority;
      addAuthorityItem(widget.tourId!.user.id, widget.tourId!.user.fullName);
      if (widget.tourId?.coHost1 != null) {
        addAuthorityItem(
            widget.tourId!.coHost1!.id, widget.tourId!.coHost1!.fullName);
      }
      if (widget.tourId?.coHost1 != null) {
        addAuthorityItem(
            widget.tourId!.coHost2!.id, widget.tourId!.coHost2!.fullName);
      }
    }
  }

  void addAuthorityItem(String id, String name) {
    authorityItems.add(
      DropdownMenuItem<String>(
        value: id,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            name,
            style: const TextStyle(color: Colors.black, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget buildAuthorityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Select Match Scoreboard Authority',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                // fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              'Scoreboard Authority Info',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const Divider(color: Colors.black,),
                          const SizedBox(height: 15),
                          const Text(
                            'This Option allows you to select the authority responsible for the match scoreboard. You can assign the appropriate individual to manage the scoreboard for each match.',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Got it!',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.info_outline,size: 16),
            ),
          ],
        ),
        // const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton<String>(
              value: selectedAuthority,
              items: authorityItems.isNotEmpty
                  ? authorityItems
                  : [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text(
                          "No authorities available",
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                      ),
                    ],
              onChanged: (value) {
                setState(() {
                  selectedAuthority = value;
                  logger.d("value: $selectedAuthority");
                });
              },
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
              dropdownColor: Colors.white,
              underline: Container(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 5),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> getPlayers() async {
    final controller = Get.find<TournamentController>();
    final teams = await (widget.tourId != null
        ? controller.getRegisteredTeams(widget.tourId!.id)
        : controller.getRegisteredTeams(widget.tournament!.id ?? ''));

    if (teams.isEmpty) {
      errorSnackBar('Please register a team first').then((_) => Get.close());
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
        selectedDate = widget.match!.matchDate;
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

  void showEliminationBottomSheet() async {
    final controller = Get.find<TournamentController>();
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: Navigator.of(context),
      ),
      builder: (context) => TeamEliminationBottomSheet(
        tournamentId: widget.tourId?.id ?? widget.tournament!.id ?? '',
        onTeamsUpdated: getPlayers,
        allTeams: controller.AllTeam,
        eliminatedTeams: controller.eliminatedTeam,
        activeTeams: totalteams,
      ),
    );

    // Reset selected teams if elimination data was updated
    if (result['selectedTeam'] != null) {
      setState(() {
        selectedTeam1 = null;
        selectedTeam2 = null;
        // if (selectedTeam1 != null &&
        //     controller.eliminatedTeam.any((team) => team.id == selectedTeam1!.id)) {
        //   selectedTeam1 = null;
        // }
        //
        // if (selectedTeam2 != null &&
        //     controller.eliminatedTeam.any((team) => team.id == selectedTeam2!.id)) {
        //   selectedTeam2 = null;
        // }
      });
      logger.d(
          "Selected Team 1 after elimination update: ${selectedTeam1?.name}");
      logger.d(
          "Selected Team 2 after elimination update: ${selectedTeam2?.name}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TournamentController>();
    final MiscController connectionController = Get.find<MiscController>();
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
                                          child: Obx(() {
                                            return DropdownButton<TeamModel?>(
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
                                              onChanged:
                                                  controller.isEditable.value
                                                      ? (TeamModel? newValue) {
                                                          setState(() {
                                                            selectedTeam1 = newValue!;
                                                          });
                                                        }
                                                      : null,
                                              items: totalteams.map<DropdownMenuItem<TeamModel?>>(
                                                  (TeamModel value) {
                                                return DropdownMenuItem<TeamModel?>(
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
                                              }).toList(),
                                            );
                                          }),
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
                                          child: Obx(() {
                                            return DropdownButton<TeamModel?>(
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
                                              onChanged:
                                                  controller.isEditable.value
                                                      ? (TeamModel? newValue) {
                                                          setState(() {
                                                            selectedTeam2 =
                                                                newValue!;
                                                          });
                                                        }
                                                      : null,
                                              items: totalteams.map<
                                                      DropdownMenuItem<
                                                          TeamModel?>>(
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
                                              }).toList(),
                                            );
                                          }),
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
                                    if (controller.isEditable.value) {
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
                                    } else {
                                      errorSnackBar(
                                          "You Cannot Edit Match Date");
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
                                const SizedBox(width: 60),
                                const Spacer(),
                                InkWell(
                                  onTap: () async {
                                    if (controller.isEditable.value) {
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
                                    } else {
                                      errorSnackBar(
                                          "You Cannot Edit Match Time");
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
                            // SizedBox(height: Get.height * 0.02),
                            buildAuthorityDropdown(),
                            SizedBox(height: Get.height * 0.03),
                            PrimaryButton(
                              onTap: () async {
                                if (connectionController.isConnected.value) {
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
                                  if (selectedRound == null) {
                                    errorSnackBar('Please select a round ');
                                    return;
                                  }
                                  if (widget.tourId != null) {
                                    final Map<String, dynamic> obj = {
                                      'tournamentId': widget.tourId?.id,
                                      'team1ID': selectedTeam1!.id,
                                      'team2ID': selectedTeam2!.id,
                                      'round': selectedRound,
                                      'matchNo': 1,
                                      'dateTime':
                                          selectedDate!.toIso8601String(),
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
                                  if (selectedAuthority == null) {
                                    errorSnackBar("Please Select an Match Scoreboard Authority");
                                  }
                                  final response =
                                      await controller.createMatchup(
                                          widget.tournament!.id ?? '',
                                          selectedTeam1!.id,
                                          selectedTeam2!.id,
                                          selectedDate!,
                                          1,
                                          selectedRound ?? '',
                                          selectedAuthority!);
                                  logger.d(response);
                                  if (response) {
                                    successSnackBar('Matchup created')
                                        .then((value) => Get.back());
                                  }
                                } else {
                                  errorSnackBar(
                                      'Please Connect to the internet to ${widget.tourId != null ? "Edit" : "Create"} matchup between the two teams');
                                }
                                // Get.to(() => const ViewMatchupsScreen());
                              },
                              title: 'Submit',
                            ),

                            SizedBox(height: Get.height * 0.02),
                            if (widget.match == null) PrimaryButton(
                                onTap: showEliminationBottomSheet,
                                title: 'Eliminate Teams',
                              ),
                            SizedBox(height: Get.height * 0.02),
                            !controller.isEditable.value
                                ? const Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.warning,
                                          color: Colors.red,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "Only the round and Authority can be \n edited for ongoing or ended matches.",
                                          textAlign: TextAlign.center,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink(),
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
