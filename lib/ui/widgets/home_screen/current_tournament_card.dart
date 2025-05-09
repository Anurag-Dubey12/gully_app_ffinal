import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/data/model/matchup_model.dart';
import 'package:gully_app/ui/screens/schedule_screen.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/home_screen/no_tournament_card.dart';
import '../../../data/model/scoreboard_model.dart';
import '../../../utils/BlinkingLiveText.dart';
import '../../../utils/FallbackImageProvider.dart';
import '../../../utils/image_picker_helper.dart';
import '../../../utils/utils.dart';
import '../dialogs/current_score_dialog.dart';
import 'i_button_dialog.dart';

class CurrentTournamentCard extends GetView<TournamentController> {
  final bool isLive;
  const CurrentTournamentCard({
    this.isLive = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: Get.height * 0.5,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Obx(() {
          if (controller.tournamentList.isEmpty) {
            return const NoTournamentCard();
          }
          if (controller.matches.isEmpty) {
            return const NoTournamentCard();
          } else {
            //For sorting the match if ended it will forward towards the end of the list
            // final sortedMatches = List<MatchupModel>.from(controller.matches)
            //   ..sort((a, b) {
            //     int getPriority(String? status) {
            //       switch (status?.toLowerCase()) {
            //         case 'current': return 0;
            //         case 'upcoming': return 1;
            //         case 'played': return 2;
            //         default: return 3;
            //       }
            //     }
            //
            //     int priorityA = getPriority(a.status);
            //     int priorityB = getPriority(b.status);
            //
            //     if (priorityA != priorityB) {
            //       return priorityA.compareTo(priorityB);
            //     }
            //
            //     return (a.tournamentId ?? '').compareTo(b.tournamentId ?? '');
            //   });

            final sortedMatches = List<MatchupModel>.from(controller.matches)
              ..sort((a, b) {
                int getPriority(String? status) {
                  switch (status?.toLowerCase()) {
                    case 'current':
                      return 0;
                    case 'upcoming':
                      return 1;
                    case 'played':
                      return 2;
                    default:
                      return 3;
                  }
                }

                int priorityA = getPriority(a.status);
                int priorityB = getPriority(b.status);
                if (priorityA != priorityB) {
                  return priorityA.compareTo(priorityB);
                }
                return (a.tournamentId ?? '').compareTo(b.tournamentId ?? '');
              });
            final matchMap =
                sortedMatches.fold<Map<String, List<MatchupModel>>>(
              {},
              (map, match) {
                if (match.tournamentName != null) {
                  map.putIfAbsent(match.tournamentName!, () => []).add(match);
                }
                return map;
              },
            );
            final latestMatches = matchMap.entries.map((entry) {
              return entry.value.reduce((latest, match) {
                int getPriority(String? status) {
                  switch (status?.toLowerCase()) {
                    case 'current':
                      return 0;
                    case 'upcoming':
                      return 1;
                    case 'played':
                      return 2;
                    default:
                      return 3;
                  }
                }

                int latestPriority = getPriority(latest.status);
                int matchPriority = getPriority(match.status);
                if (latestPriority != matchPriority) {
                  return latestPriority < matchPriority ? latest : match;
                }
                return match.matchDate.isAfter(latest.matchDate)
                    ? match
                    : latest;
              });
            }).toList();

            return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                // itemCount: controller.matches.length,
                // itemCount: sortedMatches.length,
                itemCount: latestMatches.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 10, top: 10),
                itemBuilder: (context, snapshot) {
                  return _Card(
                    // tournament: controller.matches[snapshot],
                    // tournament: sortedMatches[snapshot],
                    tournament: latestMatches[snapshot],
                  );
                });
          }
        }),
      ),
    );
  }
}

class _Card extends StatefulWidget {
  final MatchupModel tournament;

  const _Card({
    required this.tournament,
    Key? key,
  }) : super(key: key);

  @override
  State<_Card> createState() => _CardState();
}

class _CardState extends State<_Card> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TournamentController>();
    final tournamentdata = controller.tournamentList
        .firstWhere((t) => t.id == widget.tournament.tournamentId);

    ScoreboardModel? scoreboard = widget.tournament.scoreBoard == null
        ? null
        : ScoreboardModel.fromJson(widget.tournament.scoreBoard!);
    // //logger.d"The second inning is over:${widget.tournament.getWinningTeamName()}");
    //logger.d"The match Id of Tournament are :${widget.tournament.tournamentId}");
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(0, 1))
          ],
        ),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      imageViewer(context, tournamentdata.coverPhoto, true);
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: tournamentdata.coverPhoto != null &&
                              tournamentdata.coverPhoto!.isNotEmpty
                          ? FallbackImageProvider(
                              toImageUrl(tournamentdata.coverPhoto!),
                              'assets/images/logo.png') as ImageProvider
                          : const AssetImage('assets/images/logo.png'),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 120,
                            child: Text(
                              widget.tournament.tournamentName ??
                                  'Unknown Tournament',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Get.bottomSheet(
                                  IButtonDialog(
                                    organizerName:
                                        tournamentdata.organizerName!,
                                    location: tournamentdata.stadiumAddress,
                                    tournamentName:
                                        tournamentdata.tournamentName,
                                    tournamentPrice:
                                        tournamentdata.fees.toString(),
                                    coverPhoto: tournamentdata.coverPhoto,
                                    Rules: tournamentdata.rules,
                                  ),
                                  backgroundColor: Colors.white,
                                  isScrollControlled: true);
                            },
                            icon: const Icon(Icons.info_outline_rounded,
                                size: 18),
                            color: Colors.grey,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      TeamScore(
                        color: Colors.red,
                        teamName: widget.tournament.team1.name,
                        score: getScore(scoreboard?.firstInnings),
                      ),
                      const SizedBox(height: 4),
                      TeamScore(
                        teamName: widget.tournament.team2.name,
                        score: getScore(scoreboard?.secondInnings),
                        color: Colors.green.shade600,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 30,
                            width: 100,
                            child: ElevatedButton(
                                onPressed: () {
                                  //logger.d"The current match id:${widget.tournament.id}");
                                  Get.bottomSheet(
                                    BottomSheet(
                                      enableDrag: false,
                                      builder: (context) => ScoreBottomDialog(
                                        match: widget.tournament,
                                      ),
                                      onClosing: () {},
                                    ),
                                    isScrollControlled: true,
                                  );
                                },
                                style: ButtonStyle(
                                  padding: WidgetStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          horizontal: 8)),
                                ),
                                child: Text('View Score',
                                    style: Get.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white))),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              //logger.d"The TournamentId is:${tournamentdata.id} }");
                              controller.setScheduleStatus(true);
                              controller.tournamentname.value =
                                  tournamentdata.tournamentName;
                              Get.to(() =>
                                  ScheduleScreen(tournament: tournamentdata));
                            },
                            child: const Text(
                              "View Schedule",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 7,
              left: 10,
              child: BlinkingLiveText(
                status: widget.tournament.status == 'played'
                    ? 'Ended'
                    : widget.tournament.status == 'current'
                        ? 'Live'
                        : widget.tournament.status!.capitalize ?? '',
                color: widget.tournament.status == 'current'
                    ? Colors.green
                    : widget.tournament.status == 'upcoming'
                        ? AppTheme.primaryColor
                        : widget.tournament.status == 'played'
                            ? Colors.red
                            : Colors.grey,
              ),
            ),
            Positioned(
              top: 1,
              right: 10,
              child: Text(
                '${widget.tournament.round!.capitalize ?? ''} Match',
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getScore(dynamic innings) {
    if (innings == null) return 'DNB';
    int? totalScore = innings.totalScore;
    int? totalWickets = innings.totalWickets;
    if (totalScore == null || totalWickets == null) return 'N/A';
    return '$totalScore/$totalWickets';
  }
}

class TeamScore extends StatelessWidget {
  final String teamName;
  final String score;
  final Color color;

  const TeamScore({
    super.key,
    required this.teamName,
    required this.score,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 3),
          Expanded(
            child: Text(
              teamName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          Text(
            score,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
