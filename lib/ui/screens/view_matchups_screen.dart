import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/data/model/matchup_model.dart';
import 'package:gully_app/data/model/scoreboard_model.dart';
import 'package:gully_app/ui/screens/view_tournaments_screen.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/utils/date_time_helpers.dart';
import 'package:gully_app/utils/utils.dart';

import '../../data/controller/misc_controller.dart';
import '../../data/model/points_table_model.dart';
import '../../data/model/tournament_model.dart';
import '../../utils/app_logger.dart';
import 'PointsTable.dart';
import 'organize_match.dart';
class ViewMatchupsScreen extends StatefulWidget{
  final TournamentModel? tournament;
  const ViewMatchupsScreen({super.key, this.tournament});

  @override
  State<StatefulWidget> createState()=>_MatchupsScreen();

}

class _MatchupsScreen extends State<ViewMatchupsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final MiscController connectionController = Get.find<MiscController>();
    final controller=Get.find<TournamentController>();
    return GradientBuilder(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: SizedBox(
            width: 250,
            child: Text(
              "${widget.tournament?.tournamentName} Tournament",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: AppTheme.darkYellowColor,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            // isScrollable: true,
            tabs: const [
              Tab(text: 'Matches'),
              Tab(text: 'Points Table'),
            ],
          ),
          leading: const BackButton(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        body: SizedBox(
          width: Get.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: Get.height * 0.01),
              Expanded(
                child: !connectionController.isConnected.value
                    ? Center(
                  child: SizedBox(
                    width: Get.width,
                    height: Get.height * 0.7,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.signal_wifi_off,
                          size: 48,
                          color: Colors.black54,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No internet connection',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ): TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    FutureBuilder(
                      future: widget.tournament?.id != null
                          ? controller.getMatchup(widget.tournament!.id)
                          : controller.getMatchup(controller.state!.id),
                      builder: (context, snapshot) {

                        if(snapshot.connectionState==ConnectionState.waiting){
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError && connectionController.isConnected.value) {
                          return const Center(child: Text('Something went wrong'));
                        }
                        if (controller.matchups.isEmpty) {
                          return const Center(
                            child: EmptyTournamentWidget(
                              message: 'No Matchups Found',
                            ),
                          );
                        }
                        return Obx(() {
                          if (!connectionController.isConnected.value) {
                            return Center(
                              child: SizedBox(
                                width: Get.width,
                                height: Get.height,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.signal_wifi_off,
                                      size: 48,
                                      color: Colors.black54,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'No internet connection',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return ListView.separated(
                            itemCount: controller.matchups.length,
                            shrinkWrap: true,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: Get.height * 0.01),
                            itemBuilder: (context, index) {
                              final matchup = controller.matchups[index];
                              // final matchup = controller.matchups.reversed.toList()[index];
                              return MatchupCard(
                                matchup: matchup,
                                tourId: widget.tournament,
                              );
                            },
                          );
                        });
                      },
                    ),
                    FutureBuilder<List<PointTableModel>>(
                      future: controller.tournamentPointsTable(widget.tournament?.id??'' ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text("Something went wrong"));
                        }
                        if (snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text("Points table will be available once your team is registered.",textAlign: TextAlign.center),
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      tableHeader('POS', flex: 2),
                                      tableHeader('Team', flex: 4),
                                      tableHeader('Played', flex: 2),
                                      tableHeader('Win', flex: 2),
                                      tableHeader('Loss', flex: 2),
                                      tableHeader('Ties', flex: 2),
                                      tableHeader('Points', flex: 2),
                                      tableHeader('NRR', flex: 3),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Obx(() => ListView.builder(
                                    itemCount: controller
                                        .points_table.length,
                                    itemBuilder: (context, index) {
                                      final team = controller
                                          .points_table[index];
                                      return Container(
                                        padding: const EdgeInsets
                                            .symmetric(
                                            vertical: 12,
                                            horizontal: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            teamTableData(team.rank.toString(), flex: 2),
                                            const SizedBox(width: 2,),
                                            teamData(team, flex: 4),
                                            teamTableData(team.matchesPlayed.toString(), flex: 2),
                                            teamTableData(team.wins.toString(), flex: 2),
                                            teamTableData(team.losses.toString(), flex: 2),
                                            teamTableData(team.ties.toString(), flex: 2),
                                            teamTableData(team.points.toString(), flex: 2),
                                            teamTableData(team.netRunRate.toString(), flex: 3),
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
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class MatchupCard extends StatelessWidget {
  final MatchupModel matchup;
  final bool isinfo;
  final TournamentModel? tourId;
  const MatchupCard({super.key,
    required this.matchup,
    this.isinfo=false,
    this.tourId,
  });

  @override
  Widget build(BuildContext context) {
    final ScoreboardModel? scoreboard = matchup.scoreBoard == null
        ? null
        : ScoreboardModel.fromJson(matchup.scoreBoard!);
    final controller=Get.find<TournamentController>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 23),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           SizedBox(height: Get.height * 0.005),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  formatDateTime('dd MMMM yyyy hh:mm a', matchup.matchDate),
                  style: Get.textTheme.labelMedium?.copyWith(),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                  onPressed: () {
                    switch(matchup.status){
                      case 'upcoming':{
                        controller.isEditable.value = true;
                        Get.off(() => SelectOrganizeTeam(
                          match: matchup,
                          round:matchup.round ??'',
                          tourId: tourId,
                        ));
                        logger.d("The Passing Data Is ${matchup.tournament} and team 1 is ${matchup.team1.name}");
                      }
                      case 'current':{
                        controller.isEditable.value = false;
                        Get.off(() => SelectOrganizeTeam(
                          match: matchup,
                          round:matchup.round ??'',
                          tourId:tourId,
                        ));
                        // errorSnackBar("Cannot Edit Match After Match has been Started");
                      }
                      case 'played':{
                        controller.isEditable.value = false;
                        Get.off(() => SelectOrganizeTeam(
                          match: matchup,
                          round:matchup.round ??'',
                          tourId:tourId,
                        ));
                        // errorSnackBar("Cannot Edit Match After Match has been Completed");
                      }
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                  onPressed: () async {
                    Get.dialog(
                      AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        title: const Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
                            SizedBox(width: 8),
                            Text(
                              "Confirm Deletion",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ],
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Are you sure you want to delete this match between ${matchup.team1.name} and ${matchup.team2.name}?",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "This action cannot be undone!",
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        actionsAlignment: MainAxisAlignment.spaceEvenly,
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade300,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () => Get.close(),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () async {
                              Get.close();
                              final isDeleted = await controller.deleteMatch(matchup.id);
                              if (isDeleted) {
                                successSnackBar("Your match has been deleted");
                                controller.tournamentPointsTable(tourId?.id??'');
                              } else {
                                errorSnackBar("Something went wrong");
                              }
                            },
                            child: const Text(
                              "Delete",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            // SizedBox(height: Get.height * 0.01),
            Row(
              children: [
                Column(
                  children: [
                    CircleAvatar(
                        backgroundImage:
                        matchup.team1.logo!=null && matchup.team1.logo!.isNotEmpty ?
                        NetworkImage(matchup.team1.toImageUrl()) : const AssetImage('assets/images/logo.png') as ImageProvider),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 100,
                      child: Text(
                        matchup.team1.name.capitalize,
                        style: Get.textTheme.headlineSmall?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: Get.textScaleFactor * 17,
                        ),
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Chip(
                        label: Text('VS',
                            style: Get.textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        backgroundColor: AppTheme.secondaryYellowColor,
                        side: BorderSide.none),
                    Text(
                      matchup.round!.capitalize ?? '',
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    CircleAvatar(
                        backgroundImage:
                        matchup.team2.logo!=null && matchup.team2.logo!.isNotEmpty ?
                        NetworkImage(matchup.team2.toImageUrl()) : const AssetImage('assets/images/logo.png') as ImageProvider),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 100,
                      child: Text(
                        matchup.team2.name.capitalize,
                        style: Get.textTheme.headlineSmall?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: Get.textScaleFactor * 17,
                        ),
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: Get.height * 0.02),
            // This section determines and displays the winning team or the match result (e.g., "Match Tied").
            // It prioritizes displaying the winning team if available, otherwise, it shows the second innings text (if present).
            matchup.winningTeam != null
                ? Center(
              child: Text(
                  scoreboard?.secondInningsText == 'Match Tied'
                      ? "${matchup.getWinningTeamName()} Won The Match"
                      : scoreboard?.secondInningsText ?? "",
                  style: Get.textTheme.labelMedium?.copyWith()),
            )
                : (scoreboard?.secondInningsText?.isNotEmpty ??
                false)
                ? Center(
              child: Text(
                  scoreboard?.secondInningsText ?? "",
                  style: Get.textTheme.labelMedium?.copyWith()),
            )
                : const SizedBox.shrink(),
            // Center(
            //   child: Text(scoreboard?.secondInningsText ?? "",
            //       style: Get.textTheme.labelMedium?.copyWith()),
            // ),
          ],
        ),
      ),
    );
  }
}
