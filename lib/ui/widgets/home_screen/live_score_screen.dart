
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gully_app/ui/widgets/home_screen/current_tournament_card.dart';
import 'package:gully_app/ui/widgets/home_screen/tournament_list.dart';

import '../../../data/controller/tournament_controller.dart';
import '../../../data/model/matchup_model.dart';
import '../../../data/model/scoreboard_model.dart';
import '../../../utils/BlinkingLiveText.dart';
import '../../../utils/FallbackImageProvider.dart';
import '../../../utils/app_logger.dart';
import '../../../utils/image_picker_helper.dart';
import '../../../utils/utils.dart';
import '../../screens/view_matchups_screen.dart';
import '../dialogs/current_score_dialog.dart';
import 'i_button_dialog.dart';
import 'no_tournament_card.dart';

class LiveScore extends StatelessWidget {
  const LiveScore({super.key});

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
      body:  SizedBox(
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FutureBuilder(
            future: controller.getTournamentList(isLive: true),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              return Obx(() {
                if (controller.Current_tournamentList.isEmpty|| controller.Current_matches.isEmpty) {
                  return SizedBox(
                    width: Get.width,
                      height: 300,
                      child: const NoTournamentCard());
                }
                return ListView.separated(
                  itemCount: controller.Current_matches.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, snapshot) {
                      return _Card(
                        tournament: controller.Current_matches[snapshot],
                      );
                    });

              });
            },
          ),
        ),
      ),
    );
  }
}
class _Card extends StatelessWidget {
  final MatchupModel tournament;
  const _Card({
    required this.tournament,
  });


  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TournamentController>();
    final tournamentdata = controller.tournamentList
        .firstWhere((t) => t.id == tournament.tournamentId);
    ScoreboardModel? scoreboard = tournament.scoreBoard == null
        ? null
        : ScoreboardModel.fromJson(tournament.scoreBoard!);

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
                            tournament.tournamentName ?? 'Unknown Tournament',
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
                                ),
                                backgroundColor: Colors.white,
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
                    TeamScore(
                      color: Colors.red,
                      teamName: tournament.team1.name,
                      score: getScore(scoreboard?.firstInnings),
                    ),
                    const SizedBox(height: 4),
                    TeamScore(
                      teamName: tournament.team2.name,
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
                                Get.bottomSheet(
                                  BottomSheet(
                                    enableDrag: false,
                                    builder: (context) => ScoreBottomDialog(
                                      match: tournament,
                                    ),
                                    onClosing: () {},
                                  ),
                                  isScrollControlled: true,
                                );
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
                            Get.to(() => ViewMatchupsScreen(id:tournamentdata.id,isSchedule: true,));
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
          const Positioned(
            top: 8,
            right: 8,
            child: BlinkingLiveText(),
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