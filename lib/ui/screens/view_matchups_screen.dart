import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/data/model/matchup_model.dart';
import 'package:gully_app/data/model/scoreboard_model.dart';
import 'package:gully_app/ui/screens/view_tournaments_screen.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/utils/date_time_helpers.dart';

class ViewMatchupsScreen extends GetView<TournamentController> {
  const ViewMatchupsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return GradientBuilder(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          width: Get.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: const Text(
                    'Matchups',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: const BackButton(
                    color: Colors.white,
                  )),
              SizedBox(height: Get.height * 0.01),
              Expanded(
                child: FutureBuilder(
                    future: controller.getMatchup(controller.state!.id),
                    builder: (context, snapshot) {
                      if (snapshot.data?.isEmpty ?? true) {
                        return const Center(
                            child: EmptyTournamentWidget(
                                message: 'No Matchups Found'));
                      } else {
                        return ListView.separated(
                          itemCount: snapshot.data?.length ?? 0,
                          shrinkWrap: true,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: Get.height * 0.01),
                          itemBuilder: (context, index) => _MatchupCard(
                            matchup: snapshot.data![index],
                          ),
                        );
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _MatchupCard extends StatelessWidget {
  final MatchupModel matchup;
  const _MatchupCard({
    required this.matchup,
  });

  @override
  Widget build(BuildContext context) {
    final ScoreboardModel? scoreboard = matchup.scoreBoard == null
        ? null
        : ScoreboardModel.fromJson(matchup.scoreBoard!);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(formatDateTime('dd MMMM yyyy hh:mm a', matchup.matchDate),
                  style: Get.textTheme.labelMedium?.copyWith()),
              SizedBox(height: Get.height * 0.01),
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
              SizedBox(height: Get.height * 0.01),
              Center(
                child: Text(scoreboard?.secondInningsText ?? "",
                    style: Get.textTheme.labelMedium?.copyWith()),
              ),
              // Center(
              //   child: Text('20/1',
              //       style: Get.textTheme.headlineLarge?.copyWith(
              //           color: Colors.green, fontWeight: FontWeight.w800)),
              // ),
              // SizedBox(height: Get.height * 0.01),
              // Row(
              //   children: [
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         RichText(
              //             text: TextSpan(
              //                 text: 'Overs: ',
              //                 style: const TextStyle(
              //                     fontSize: 13, color: Colors.black),
              //                 children: [
              //               TextSpan(
              //                   text: '13.2',
              //                   style: Get.textTheme.bodyMedium?.copyWith(
              //                       color: Colors.black,
              //                       fontSize: 12,
              //                       fontWeight: FontWeight.bold))
              //             ])),
              //         RichText(
              //             text: TextSpan(
              //                 text: 'To Win: ',
              //                 style: const TextStyle(
              //                     fontSize: 12, color: Colors.black),
              //                 children: [
              //               TextSpan(
              //                 text: '311 OFF 21 Balls',
              //                 style: Get.textTheme.bodyMedium?.copyWith(
              //                     color: Colors.black,
              //                     fontSize: 12,
              //                     fontWeight: FontWeight.bold),
              //               ),
              //             ]))
              //       ],
              //     ),
              //     const Spacer(),
              //     Chip(
              //       label: Text(
              //         'View Full Screen',
              //         style: Get.textTheme.bodyMedium?.copyWith(
              //             color: Colors.white,
              //             fontWeight: FontWeight.bold,
              //             fontSize: 10),
              //       ),
              //       side: BorderSide.none,
              //       backgroundColor: AppTheme.secondaryYellowColor,
              //     )
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
