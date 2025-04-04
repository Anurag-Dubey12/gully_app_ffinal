import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/misc_controller.dart';
import 'package:gully_app/data/controller/team_controller.dart';
import 'package:gully_app/data/model/opponent_model.dart';
import 'package:gully_app/data/model/points_table_model.dart';
import 'package:gully_app/data/model/scoreboard_model.dart';
import 'package:gully_app/ui/screens/PointsTable.dart';
import 'package:gully_app/ui/screens/full_scorecard.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/utils/FallbackImageProvider.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/date_time_helpers.dart';
import 'package:gully_app/utils/utils.dart';

import '../../data/controller/tournament_controller.dart';
import '../../data/model/matchup_model.dart';

class OpponentTournamentsScreen extends StatefulWidget {
  final bool opponentView;
  const OpponentTournamentsScreen({super.key, this.opponentView = false});

  @override
  State<OpponentTournamentsScreen> createState() =>
      _OpponentTournamentsScreenState();
}

class _OpponentTournamentsScreenState extends State<OpponentTournamentsScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeamController>();
    return GradientBuilder(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              // toolbarHeight: 100,
              iconTheme: const IconThemeData(color: Colors.white),
              title: Text(
                widget.opponentView ? 'Select Tournament' : 'Your Tournaments',
                textAlign: TextAlign.center,
                style: Get.textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 24),
              ),
            ),
            body: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(children: [
                  Expanded(
                    child: FutureBuilder<List<OpponentModel>>(
                        future: controller.getOpponents(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text("Failed to Get Data",
                                    style: Get.textTheme.bodyLarge
                                        ?.copyWith(color: Colors.red)));
                          }
                          if (snapshot.data == null || snapshot.data!.isEmpty) {
                            return const EmptyTournamentWidget();
                          }
                          return ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 18),
                              shrinkWrap: true,
                              itemCount: snapshot.data?.length ?? 0,
                              itemBuilder: (context, index) {
                                return _TourCard(
                                    snapshot.data!.elementAt(index), () {
                                  setState(() {});
                                }
                                    // tournament: snapshot.data![index],
                                    // redirectType: redirectType,
                                    );
                              });
                        }),
                  )
                ]))));
  }
}

class EmptyTournamentWidget extends StatelessWidget {
  final String? message;
  const EmptyTournamentWidget({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        const Image(
          image: AssetImage('assets/images/cricketer.png'),
          height: 230,
        ),
        SizedBox(height: Get.height * 0.02),
        Text(message ?? 'You have no tournaments yet',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    ));
  }
}

class _TourCard extends GetView<TournamentController> {
  final OpponentModel opponentModel;
  final Function onCancel;
  const _TourCard(this.opponentModel, this.onCancel);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      style: ListTileStyle.drawer,
      onTap: () {
        // Get.to(() => TournamentTeams(tournament: opponentModel));
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      tileColor: Colors.white,
      contentPadding: const EdgeInsets.all(12),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(opponentModel.tournamentName,
              style: Get.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w700)),
          // Text(opponentModel.stadiumAddress,
          //     style: Get.textTheme.bodySmall
          //         ?.copyWith(color: Colors.grey.shade600)),
        ],
      ),
      trailing: GestureDetector(
        onTap: () async {
          Get.to(() => OpponentScheduleScreen(
                tournamentId: opponentModel.tournamentId,
                tournamentName: opponentModel.tournamentName,
              ));
        },
        child: const Chip(
            iconTheme: IconThemeData(color: Colors.white),
            padding: EdgeInsets.zero,
            label: Text('View Schedule',
                style: TextStyle(color: Colors.white, fontSize: 12)),
            backgroundColor: AppTheme.darkYellowColor,
            side: BorderSide.none),
      ),
    );
  }
}

class OpponentScheduleScreen extends StatefulWidget {
  final String tournamentId;
  final String tournamentName;
  const OpponentScheduleScreen(
      {super.key, required this.tournamentId, required this.tournamentName});

  @override
  _OpponentScheduleScreenState createState() => _OpponentScheduleScreenState();
}

class _OpponentScheduleScreenState extends State<OpponentScheduleScreen>
    with SingleTickerProviderStateMixin {
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
    final controller = Get.find<TournamentController>();
    final connectionController = Get.find<MiscController>();

    return GradientBuilder(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: SizedBox(
            width: 250,
            child: Text(
              "${widget.tournamentName.capitalize} Tournament",
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
                      )
                    : TabBarView(
                        controller: _tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          FutureBuilder(
                            future: controller
                                .getMatchup(widget.tournamentId ?? ''),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              }
                              if (controller.matchups.isEmpty) {
                                return const Center(
                                    child: EmptyTournamentWidget(
                                        message: 'No Matchups Found'));
                              }
                              return ListView.separated(
                                itemCount: controller.matchups.length,
                                shrinkWrap: true,
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: Get.height * 0.01),
                                itemBuilder: (context, index) {
                                  final matchup = controller.matchups.reversed
                                      .toList()[index];
                                  return OpponentMatchupCard(
                                      matchup: matchup,
                                      tourid: widget.tournamentId);
                                },
                              );
                            },
                          ),
                          FutureBuilder<List<PointTableModel>>(
                            future: controller
                                .tournamentPointsTable(widget.tournamentId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError) {
                                return const Center(
                                    child: Text("Something went wrong"));
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
                                                      vertical: 8,
                                                      horizontal: 5),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      teamTableData(
                                                          team.rank.toString(),
                                                          flex: 2),
                                                      const SizedBox(
                                                        width: 2,
                                                      ),
                                                      teamData(team, flex: 4),
                                                      teamTableData(
                                                          team.matchesPlayed
                                                              .toString(),
                                                          flex: 2),
                                                      teamTableData(
                                                          team.wins.toString(),
                                                          flex: 2),
                                                      teamTableData(
                                                          team.losses
                                                              .toString(),
                                                          flex: 2),
                                                      teamTableData(
                                                          team.ties.toString(),
                                                          flex: 2),
                                                      teamTableData(
                                                          team.points
                                                              .toString(),
                                                          flex: 2),
                                                      teamTableData(
                                                          team.netRunRate
                                                              .toString(),
                                                          flex: 3),
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

class OpponentMatchupCard extends StatelessWidget {
  final MatchupModel matchup;
  final String? tourid;
  const OpponentMatchupCard({super.key, required this.matchup, this.tourid});

  @override
  Widget build(BuildContext context) {
    final ScoreboardModel? scoreboard = matchup.scoreBoard == null
        ? null
        : ScoreboardModel.fromJson(matchup.scoreBoard!);
    final controller = Get.find<TournamentController>();
    //logger.d"The Winner id is:${matchup.getWinningTeamName()}");
    return GestureDetector(
        onTap: () {
          if (scoreboard == null) {
            errorSnackBar("Please Wait for Match to Begin");
          } else {
            Get.to(() => FullScoreboardScreen(scoreboard: scoreboard));
          }
        },
        child: scoreboard == null
            ? EmptyMatchScoreCard()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 23, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              matchup.round?.capitalize ?? '',
                              style: Get.textTheme.labelMedium?.copyWith(),
                            ),
                            const Spacer(),
                            Text(
                              formatDateTime(
                                  'dd MMM yyyy hh:mm a', matchup.matchDate),
                              style: Get.textTheme.labelMedium?.copyWith(),
                            ),
                          ],
                        ),
                        SizedBox(height: Get.height * 0.01),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            teamView(
                              matchup.team1.logo ?? '',
                              matchup.team1.name,
                              scoreboard.firstInningHistory == null
                                  ? "Did Not Bat"
                                  : '${scoreboard.firstInnings?.totalScore ?? 0}/${scoreboard.firstInnings?.totalWickets ?? 0}',
                            ),
                            const SizedBox(height: 10),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(
                            //       horizontal: 10, vertical: 8.0),
                            //   child: Align(
                            //     alignment: Alignment.centerLeft,
                            //     child: Text(
                            //       'VS',
                            //       style: Get.textTheme.bodyMedium?.copyWith(
                            //         color: Colors.black,
                            //         fontWeight: FontWeight.bold,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            teamView(
                              matchup.team2.logo ?? '',
                              matchup.team2.name,
                              scoreboard.currentInnings == 1
                                  ? "Did Not Bat"
                                  : '${scoreboard.secondInnings?.totalScore}/${scoreboard.secondInnings?.totalWickets ?? 0}',
                            ),
                          ],
                        ),
                        matchup.winningTeam != null
                            ? Align(
                                alignment: Alignment.center,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 8.0),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 12.0),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade600,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Text(
                                    scoreboard.secondInningsText == 'Match Tied'
                                        ? "${matchup.getWinningTeamName()} Won The Match"
                                        : scoreboard.secondInningsText ?? "",
                                    style: Get.textTheme.bodyMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            : (scoreboard.secondInningsText?.isNotEmpty ??
                                    false)
                                ? Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 8.0),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 12.0),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade600,
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Text(
                                        scoreboard.secondInningsText ?? "",
                                        style:
                                            Get.textTheme.bodyMedium?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
              ));
  }

  Widget EmptyMatchScoreCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    formatDateTime('dd MMMM yyyy hh:mm a', matchup.matchDate),
                    style: Get.textTheme.labelMedium?.copyWith(),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.01),
              Row(
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                          backgroundImage: matchup.team1.logo != null &&
                                  matchup.team1.logo!.isNotEmpty
                              ? NetworkImage(matchup.team1.toImageUrl())
                              : const AssetImage('assets/images/logo.png')
                                  as ImageProvider),
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
                          backgroundImage: matchup.team2.logo != null &&
                                  matchup.team2.logo!.isNotEmpty
                              ? NetworkImage(matchup.team2.toImageUrl())
                              : const AssetImage('assets/images/logo.png')
                                  as ImageProvider),
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
              // Center(
              //   child: Text(scoreboard?.secondInningsText ?? "",
              //       style: Get.textTheme.labelMedium?.copyWith()),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget teamView(String teamLogo, String teamName, String score) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              CircleAvatar(
                radius: 20.0,
                backgroundImage: FallbackImageProvider(
                  toImageUrl(teamLogo),
                  'assets/images/logo.png',
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  teamName.capitalize,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Text(
          score,
          style: Get.textTheme.bodyMedium?.copyWith(
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
