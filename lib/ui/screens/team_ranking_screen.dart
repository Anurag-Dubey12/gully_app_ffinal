import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/team_ranking_model.dart';
import 'package:gully_app/utils/FallbackImageProvider.dart';
import 'package:gully_app/utils/date_time_helpers.dart';
import 'package:gully_app/utils/utils.dart';

import '../../data/controller/ranking_controller.dart';
import '../theme/theme.dart';
import '../widgets/arc_clipper.dart';

class TeamRankingScreen extends StatefulWidget {
  const TeamRankingScreen({super.key});

  @override
  State<TeamRankingScreen> createState() => _TeamRankingScreenState();
}

class _TeamRankingScreenState extends State<TeamRankingScreen> {
  int _selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    final controller = Get.putOrFind(() => RankingController(Get.find()));
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/images/sports_icon.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              ClipPath(
                clipper: ArcClipper(),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const RadialGradient(
                      colors: [
                        Color(0xff368EBF),
                        AppTheme.primaryColor,
                      ],
                      center: Alignment(-0.4, -0.8),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: AppTheme.secondaryYellowColor.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: const Offset(0, 70))
                    ],
                  ),
                  width: double.infinity,
                ),
              ),
              Positioned(
                  top: 0,
                  child: SizedBox(
                    height: Get.height,
                    width: Get.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          iconTheme: const IconThemeData(color: Colors.white),
                          title: const Text('Team Ranking',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 23)),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _SelectBallTypeCard(
                                tab: 0,
                                selectedTab: _selectedTab,
                                text: 'Leather ball',
                                onTap: (st) {
                                  setState(() {
                                    // ignore: unnecessary_statements
                                    _selectedTab = 0;
                                  });
                                },
                              ),
                              const SizedBox(width: 10),
                              _SelectBallTypeCard(
                                tab: 1,
                                selectedTab: _selectedTab,
                                text: 'Tennis ball',
                                onTap: (st) {
                                  setState(() {
                                    // ignore: unnecessary_statements
                                    _selectedTab = st;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        // Center(
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: Text('Most matches played in Mumbai',
                        //         style: Get.textTheme.bodyMedium?.copyWith(
                        //             fontWeight: FontWeight.w400,
                        //             color: Colors.black)),
                        //   ),
                        // ),
                        Expanded(
                          child: Container(
                            color: Colors.black26,
                            // height: Get.height * 0.6,
                            child: FutureBuilder<List<TeamRankingModel>>(
                                future: controller.getTeamRankingList(
                                    _selectedTab == 0 ? 'leather' : 'tennis'),
                                builder: (context, snapshot) {
                                  return ListView.separated(
                                      padding: const EdgeInsets.all(20),
                                      itemCount: snapshot.data?.length ?? 0,
                                      shrinkWrap: true,
                                      separatorBuilder: (c, i) =>
                                          const SizedBox(height: 10),
                                      itemBuilder: (c, i) =>
                                          _TeamCard(team: snapshot.data![i]));
                                }),
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          )),
    );
  }
}

class _TeamCard extends StatelessWidget {
  final TeamRankingModel team;
  const _TeamCard({
    required this.team,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                    radius: 18,
                    backgroundImage:FallbackImageProvider(
                      toImageUrl(team.teamLogo??""),"assets/images/logo.png"
                    )
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Get.width / 2.5,
                      child: Text(team.teamName.capitalize,
                          overflow: TextOverflow.clip,
                          style: Get.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black)),
                    ),
                    Text(
                      'Since ${formatDateTime('dd.MM.yyyy', team.registeredAt)}',
                      style: Get.textTheme.bodyMedium
                          ?.copyWith(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
            Column(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppTheme.secondaryYellowColor,
                  child: Text(
                    team.numberOfWins.toString(),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'WINS',
                  style: Get.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400, color: Colors.black),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _SelectBallTypeCard extends StatelessWidget {
  final int tab;
  final int selectedTab;
  final String text;
  final Function(int tab) onTap;

  const _SelectBallTypeCard({
    required this.onTap,
    required this.tab,
    required this.selectedTab,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
          onTap: () => onTap(tab),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: tab == selectedTab
                  ? AppTheme.secondaryYellowColor
                  : Colors.white,
              boxShadow: [
                BoxShadow(
                    color: const Color.fromARGB(57, 0, 0, 0).withOpacity(0.15),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 10))
              ],
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(text,
                    style: Get.textTheme.bodyLarge?.copyWith(
                        color: selectedTab == tab ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ),
    );
  }
}
