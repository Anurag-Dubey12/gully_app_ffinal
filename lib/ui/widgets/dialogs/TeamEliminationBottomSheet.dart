import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:gully_app/utils/FallbackImageProvider.dart';

import '../../../data/controller/tournament_controller.dart';
import '../../../data/model/team_model.dart';
import '../../../utils/CustomItemCheckbox.dart';
import '../../../utils/app_logger.dart';
import '../../../utils/utils.dart';
import '../../theme/theme.dart';
import '../primary_button.dart';


class TeamTransformation {
  final TeamModel team;
  final bool isCurrentlyEliminated;

  TeamTransformation({
    required this.team,
    required this.isCurrentlyEliminated,
  });
}
class TeamEliminationBottomSheet extends StatefulWidget {
  final String tournamentId;
  final Function onTeamsUpdated;
  final List<TeamModel> allTeams;
  final List<TeamModel> eliminatedTeams;
  final List<TeamModel> activeTeams;

  const TeamEliminationBottomSheet({
    Key? key,
    required this.tournamentId,
    required this.onTeamsUpdated,
    required this.allTeams,
    required this.eliminatedTeams,
    required this.activeTeams,
  }) : super(key: key);

  @override
  State<TeamEliminationBottomSheet> createState() => _TeamEliminationBottomSheetState();
}

class _TeamEliminationBottomSheetState extends State<TeamEliminationBottomSheet> {
  String selectedFilter = 'all';
  List<String> selectedTeamsForElimination = [];

  Widget buildFilterChip({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    final isSelected = selectedFilter == value;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: Get.textTheme.bodyMedium?.copyWith(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  List<TeamModel> _getFilteredTeams(String filter) {
    switch (filter) {
      case 'eliminated':
        return widget.eliminatedTeams;
      case 'active':
        return widget.activeTeams;
      default:
        return widget.allTeams;
    }
  }

  void showTransformationDialog(BuildContext context, List<String> selectedIds) {
    final controller = Get.find<TournamentController>();
    List<TeamTransformation> transformations = selectedIds.map((id) {
      TeamModel team = controller.AllTeam.firstWhere((team) => team.id == id);
      bool isCurrentlyEliminated = controller.eliminatedTeam.any((eliminated) => eliminated.id == id);
      return TeamTransformation(
        team: team,
        isCurrentlyEliminated: isCurrentlyEliminated,
      );
    }).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: Navigator.of(context),
      ),
      builder: (BuildContext context) {
        return TeamTransformationDialog(
          transformations: transformations,
          onConfirm: () async {
            Navigator.of(context).pop(true);
          },
        );
      },
    ).then((confirmed) async {
      if (confirmed == true) {
        //Code to show error if team has not played any matches
      //   final controller = Get.find<TournamentController>();
      //   controller.getMatchup(widget.tournamentId);
      //   List<String> teamsWithoutMatches = [];
      //   for (String teamId in selectedTeamsForElimination) {
      //     logger.d("Selected Team id :${teamId}");
      //     bool teamHasMatch = controller.matchups.value.any((match) =>
      //     match.team1.id == teamId || match.team2.id == teamId
      //     );
      //     if (!teamHasMatch) {
      //       String teamName = controller.AllTeam
      //           .firstWhere((team) => team.id == teamId)
      //           .name;
      //       logger.d("Team Name: " + teamName);
      //       teamsWithoutMatches.add(teamName);
      //     }
      //   }
      //   if (teamsWithoutMatches.isNotEmpty) {
      //     String teamNames = teamsWithoutMatches.join(", ");
      //     logger.e("Match not found for teams: $teamNames");
      //     errorSnackBar("Match not found for teams: $teamNames");
      // }else{
      //     final response = await controller.teamElimination(
      //       widget.tournamentId,
      //       selectedTeamsForElimination,
      //     );
      //     if (response) {
      //       await widget.onTeamsUpdated();
      //       Navigator.pop(context, {
      //         'selectedTeam':selectedTeamsForElimination
      //       }); //return the selected eliminated teams
      //       successSnackBar('Teams updated successfully');
      //
      //     }
      //   }
        final response = await controller.teamElimination(
          widget.tournamentId,
          selectedTeamsForElimination,
        );
        if (response) {
          await widget.onTeamsUpdated();
          Navigator.pop(context, {
            'selectedTeam':selectedTeamsForElimination
          }); //return the selected eliminated teams
          successSnackBar('Teams updated successfully');

        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.95,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primaryColor
                      ),
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
                        'Manage Teams',
                        style: Get.textTheme.titleLarge?.copyWith(
                            color: Colors.black,
                            fontSize: 20
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  buildFilterChip(
                    label: 'All (${widget.allTeams.length})',
                    value: 'all',
                    onTap: () => setState(() => selectedFilter = 'all'),
                  ),
                  const SizedBox(width: 8),
                  buildFilterChip(
                    label: 'Active (${widget.activeTeams.length})',
                    value: 'active',
                    onTap: () => setState(() => selectedFilter = 'active'),
                  ),
                  const SizedBox(width: 8),
                  buildFilterChip(
                    label: 'Eliminated (${widget.eliminatedTeams.length})',
                    value: 'eliminated',
                    onTap: () => setState(() => selectedFilter = 'eliminated'),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _getFilteredTeams(selectedFilter).length,
                itemBuilder: (context, index) {
                  final team = _getFilteredTeams(selectedFilter)[index];
                  final isEliminated = widget.eliminatedTeams.any((eliminated) => eliminated.id == team.id);
                  return Stack(
                    children: [
                      CustomItemCheckbox(
                        isSelected: selectedTeamsForElimination.contains(team.id),
                        title: team.name,
                        imageUrl: team.toImageUrl(),
                        borderColor: isEliminated ? Colors.red : Colors.black45,
                        selectedColor: AppTheme.primaryColor,
                        titleStyle: Get.textTheme.titleMedium?.copyWith(
                          color: isEliminated ? Colors.red : Colors.black,
                        ),
                        onTap: () {
                          setState(() {
                            if (selectedTeamsForElimination.contains(team.id)) {
                              selectedTeamsForElimination.remove(team.id);
                            } else {
                              selectedTeamsForElimination.add(team.id);
                            }
                          });
                        },
                      ),
                      if (isEliminated)
                        Positioned(
                          right: 30,
                          top: 25,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.explicit),
                          ),
                        ),
                    ],
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
              child: Column(
                children: [
                  Text(
                    'Selected teams: ${selectedTeamsForElimination.length}',
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  PrimaryButton(
                    onTap: () {
                      if (selectedTeamsForElimination.isEmpty) {
                        errorSnackBar('Please select teams to update modify Elimination');
                        return;
                      }
                      showTransformationDialog(context, selectedTeamsForElimination);
                    },
                    title: 'Update Teams',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class TeamTransformationDialog extends StatelessWidget {
  final List<TeamTransformation> transformations;
  final VoidCallback onConfirm;

  const TeamTransformationDialog({
    Key? key,
    required this.transformations,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      constraints: BoxConstraints(
        maxHeight: Get.height * 0.85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Text(
                  'Team Elimination Status Changes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...transformations.map((transformation) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: transformation.isCurrentlyEliminated ? Colors.green.shade200 : Colors.red.shade200,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundImage: FallbackImageProvider(
                                    transformation.team.toImageUrl(),
                                  'assets/images/logo.png'
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  transformation.team.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: transformation.isCurrentlyEliminated ? Colors.red.shade100 : Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    transformation.isCurrentlyEliminated ? 'Eliminated' : 'Active',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: transformation.isCurrentlyEliminated ? Colors.red : Colors.green,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.grey[600],
                                  size: 24,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: transformation.isCurrentlyEliminated ? Colors.green.shade100 : Colors.red.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    transformation.isCurrentlyEliminated ? 'Active' : 'Eliminated',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: transformation.isCurrentlyEliminated ? Colors.green : Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}