import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/data/model/matchup_model.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';

class ViewMatchupsScreen extends GetView<TournamentController> {
  const ViewMatchupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Get.width * 0.03,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: Get.height * 0.01),
                          FutureBuilder(
                              future:
                                  controller.getMatchup(controller.state.id),
                              builder: (context, snapshot) => ListView.builder(
                                    itemCount: snapshot.data?.length ?? 0,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) =>
                                        _MatchupCard(
                                      matchup: snapshot.data![index],
                                    ),
                                  ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
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
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(matchup.matchDate.toString(),
                style: Get.textTheme.labelMedium?.copyWith()),
            SizedBox(height: Get.height * 0.01),
            Row(
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(matchup.team1.toImageUrl()),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      matchup.team1.name,
                      style: Get.textTheme.headlineSmall?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: Get.textScaleFactor * 17,
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
                      backgroundImage: NetworkImage(matchup.team2.toImageUrl()),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      matchup.team2.name,
                      style: Get.textTheme.headlineSmall?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: Get.textScaleFactor * 17,
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: Get.height * 0.01),
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
    );
  }
}
