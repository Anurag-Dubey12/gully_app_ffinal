import 'dart:async';  // Import for Timer class
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/screens/schedule_screen.dart';
import 'package:gully_app/ui/widgets/home_screen/current_tournament_card.dart';
import 'package:gully_app/ui/widgets/home_screen/tournament_list.dart';

import '../../../data/controller/scoreboard_controller.dart';
import '../../../data/controller/tournament_controller.dart';
import '../../../data/model/matchup_model.dart';
import '../../../data/model/scoreboard_model.dart';
import '../../../utils/BlinkingLiveText.dart';
import '../../../utils/FallbackImageProvider.dart';
import '../../../utils/app_logger.dart';
import '../../../utils/image_picker_helper.dart';
import '../../../utils/utils.dart';
import '../../screens/view_matchups_screen.dart';
import '../../theme/theme.dart';
import '../dialogs/current_score_dialog.dart';
import 'i_button_dialog.dart';
import 'no_tournament_card.dart';

class LiveScore extends StatefulWidget {
  const LiveScore({super.key});

  @override
  LiveScoreState createState() => LiveScoreState();
}

class LiveScoreState extends State<LiveScore> {
  Future<void> refreshData() async {
    try {
      final tournamentController = Get.find<TournamentController>();
      tournamentController.filter.value = 'current';
      await tournamentController.getCurrentTournamentList(filterD: 'current');
      logger.d("Got live score");
    } catch (e) {
      logger.e('Error refreshing data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TournamentController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Score"),
        backgroundColor: const Color(0xff3F5BBF),
        elevation: 0,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder(
        future: controller.getCurrentTournamentList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Obx(() {
            if (controller.Current_tournamentList.isEmpty ||
                controller.Current_matches.isEmpty) {
              return RefreshIndicator(
                onRefresh: refreshData,
                child: ListView(
                  children: const [
                    SizedBox(
                      height: 300,
                      child: NoTournamentCard(),
                    ),
                  ],
                ),
              );
            }
            final sortedMatches = List<MatchupModel>.from(controller.matches)
              ..sort((a, b) {
                int getPriority(String? status) {
                  switch (status?.toLowerCase()) {
                    case 'current': return 0;
                    case 'upcoming': return 1;
                    case 'played': return 2;
                    default: return 3;
                  }
                }

                int priorityA = getPriority(a.status);
                int priorityB = getPriority(b.status);

                if (priorityA != priorityB) {
                  return priorityA.compareTo(priorityB);
                }

                return (a.tournamentId ?? '').compareTo(b.tournamentId ?? '');
              });
            return RefreshIndicator(
              displacement: 10,
              onRefresh: refreshData,
              child: ListView.separated(
                itemCount: sortedMatches.length,
                padding: const EdgeInsets.all(16),
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return Card(
                    tournament: sortedMatches[index],
                  );
                },
              ),
            );
          });
        },
      ),
    );
  }
}


class Card extends StatefulWidget{
  final MatchupModel tournament;
  const Card({
    required this.tournament,
  });
  @override
  State<StatefulWidget> createState() =>CardState();
  
}

class CardState extends State<Card> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TournamentController>();
    final tournamentdata = controller.tournamentList
        .firstWhere((t) => t.id == widget.tournament.tournamentId);
    ScoreboardModel? scoreboard = widget.tournament.scoreBoard == null
        ? null
        : ScoreboardModel.fromJson(widget.tournament.scoreBoard!);
    // ScoreboardModel? scoreboard = scoreBoardController.scoreboard.value;
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
              offset: const Offset(0, 1)
          )
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
                    imageViewer(context, tournamentdata.coverPhoto,true);
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: tournamentdata.coverPhoto != null && tournamentdata.coverPhoto!.isNotEmpty
                        ? FallbackImageProvider(
                        toImageUrl(tournamentdata.coverPhoto!),
                        'assets/images/logo.png'
                    ) as ImageProvider
                        : const AssetImage('assets/images/logo.png'),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.tournament.tournamentName ?? 'Unknown Tournament',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          IconButton(
                            onPressed: () {
                              Get.bottomSheet(
                                IButtonDialog(
                                  organizerName: tournamentdata.organizerName!,
                                  location: tournamentdata.stadiumAddress,
                                  tournamentName: tournamentdata.tournamentName,
                                  tournamentPrice: tournamentdata.fees.toString(),
                                  coverPhoto: tournamentdata.coverPhoto,
                                  Rules: tournamentdata.rules,
                                ),
                                backgroundColor: Colors.white,
                                isScrollControlled: true
                              );
                            },
                            icon: const Icon(Icons.info_outline_rounded, size: 18),
                            color: Colors.grey,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Obx((){
                    //   return Column(
                    //     children: [
                    //     TeamScore(
                    //     color: Colors.red,
                    //     teamName: widget.tournament.team1.name,
                    //     score: scoreboard?.firstInnings != null
                    //         ? '${scoreboard!.firstInnings!.totalScore}/${scoreboard.firstInnings!.totalWickets}'
                    //         : 'DNB',
                    //   ),
                    //   const SizedBox(height: 4),
                    //   TeamScore(
                    //     teamName: widget.tournament.team2.name,
                    //     score: scoreboard?.secondInnings != null
                    //         ? '${scoreboard!.secondInnings!.totalScore}/${scoreboard.secondInnings!.totalWickets}'
                    //         : 'DNB',
                    //     color: Colors.green.shade600,
                    //   ),
                    //     ],
                    //   );
                    // }),
                    TeamScore(
                      color: Colors.red,
                      teamName: widget.tournament.team1.name,
                      score: getScore(scoreboard?.firstInnings)
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
                                final res=Get.bottomSheet(
                                  BottomSheet(
                                    enableDrag: false,
                                    builder: (context) => ScoreBottomDialog(
                                      match: widget.tournament,
                                    ),
                                    onClosing: () {},
                                  ),
                                  isScrollControlled: true,
                                );
                                controller.getCurrentTournamentList();
                                logger.d("Called getCurrentTournamentList");
                              },
                              style: ButtonStyle(
                                padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 8)),
                              ),
                              child: Text('View Score',
                                  style: Get.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white
                                  )
                              )
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: (){
                            logger.d("The TournamentId is:${tournamentdata.id}");
                            Get.to(() => ScheduleScreen(tournament: tournamentdata,));
                          },
                          child: const Text("View Schedule",style: TextStyle(fontSize: 12,decoration: TextDecoration.underline),),
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
              status: widget.tournament.status== 'played'?'Ended':
              widget.tournament.status== 'current'?'Live':
              widget.tournament.status!.capitalize??'',
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
              '${widget.tournament.round!.capitalize ??''} Match',
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
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

  const TeamScore({super.key,
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
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13
              ),
            ),
          ),
          Text(
            score,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13
            ),
          ),
        ],
      ),
    );
  }
}