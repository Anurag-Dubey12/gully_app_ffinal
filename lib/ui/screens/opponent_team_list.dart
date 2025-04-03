import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/team_controller.dart';
import 'package:gully_app/data/model/opponent_model.dart';
import 'package:gully_app/data/model/scoreboard_model.dart';
import 'package:gully_app/data/model/team_model.dart';
import 'package:gully_app/ui/screens/full_scorecard.dart';
import 'package:gully_app/ui/screens/view_opponent_team.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:gully_app/utils/date_time_helpers.dart';
import 'package:gully_app/utils/utils.dart';

class ViewOpponentTeamList extends StatefulWidget {
  final OpponentModel opponent;
  const ViewOpponentTeamList({
    super.key,
    required this.opponent,
  });

  @override
  State<ViewOpponentTeamList> createState() => _ViewOpponentTeamListState();
}

class _ViewOpponentTeamListState extends State<ViewOpponentTeamList> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeamController>();
    // controller.getTeams();
    return DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage('assets/images/sports_icon.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: GradientBuilder(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text(
                  'Opponent Teams',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: const BackButton(
                  color: Colors.white,
                )),
            body: Container(
              width: Get.width,
              // height: Get.height * 0.54,
              margin: const EdgeInsets.only(top: 10),
              color: Colors.black26,
              child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: FutureBuilder<List<TeamModel>>(
                      future: controller.getOpponentTeamList(
                          widget.opponent.tournamentId, widget.opponent.teamId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error ${snapshot.error}}'),
                          );
                        }
                        if (snapshot.data?.isEmpty ?? true) {
                          return const Center(
                            child: Text('No Teams found',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold)),
                          );
                        }
                        return ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 10,
                                ),
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              return _TeamCard(
                                team: snapshot.data![index],
                              );
                            });
                      })),
            ),
          ),
        ));
  }
}

class _TeamCard extends StatelessWidget {
  final TeamModel team;
  const _TeamCard({
    required this.team,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeamController>();
    String matchDate = " ";
    bool isPlayed = false;
    String? winningTeamName;
    ScoreboardModel? scoreboard;
    for (var match in controller.TeamMatchDetails.value) {
      if (match.team1.id == team.id || match.team2.id == team.id) {
        matchDate = formatDateTime('dd MMMM yyyy hh:mm a', match.matchDate);
        winningTeamName = match.getWinningTeamName();
        isPlayed = match.scoreBoard == null ? false : true;
        scoreboard = match.scoreBoard == null
            ? null
            : ScoreboardModel.fromJson(match.scoreBoard!);
        break;
      }
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Match Date and View Opponent button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  matchDate,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              GestureDetector(
                onTap: () => Get.to(() => ViewOpponentTeam(
                      team: team,
                    )),
                child: const Text(
                  "View Opponent Team",
                  style: TextStyle(color: AppTheme.primaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Chip(
                label: Text('VS',
                    style: Get.textTheme.labelSmall?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                backgroundColor: AppTheme.secondaryYellowColor,
                side: BorderSide.none,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  team.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          scoreboard != null
              ? Row(
                  children: [
                    if (winningTeamName != null ||
                        scoreboard?.secondInningsText?.isNotEmpty == true)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.green.shade600,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Text(
                            winningTeamName != null
                                ? scoreboard?.secondInningsText == 'Match Tied'
                                    ? "$winningTeamName Won The Match"
                                    : scoreboard?.secondInningsText ?? ""
                                : "",
                            style: Get.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    scoreboard != null
                        ? GestureDetector(
                            onTap: () => Get.to(() =>
                                FullScoreboardScreen(scoreboard: scoreboard)),
                            child: const Text(
                              "View Full Scoreboard",
                              style: TextStyle(color: AppTheme.primaryColor),
                            ),
                          )
                        : const SizedBox.shrink()
                  ],
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
