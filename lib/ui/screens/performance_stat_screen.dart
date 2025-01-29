import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/data/controller/team_controller.dart';
import 'package:gully_app/ui/screens/schedule_screen.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:intl/intl.dart';

import '../../data/controller/tournament_controller.dart';
import '../../data/model/matchup_model.dart';
import '../../data/model/scoreboard_model.dart';
import '../../utils/FallbackImageProvider.dart';
import '../../utils/app_logger.dart';
import '../../utils/date_time_helpers.dart';
import '../../utils/utils.dart';
import 'full_scorecard.dart';

class PerformanceStatScreen extends StatefulWidget {
  final String category;
  const PerformanceStatScreen({super.key, required this.category});

  @override
  State<PerformanceStatScreen> createState() => _PerformanceStatScreenState();
}

class _PerformanceStatScreenState extends State<PerformanceStatScreen>
    with SingleTickerProviderStateMixin {
  String innings = 'batting';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TeamController controller = Get.find<TeamController>();
    final authcontroller = Get.find<AuthController>();
    return GradientBuilder(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('My Performance',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppTheme.darkYellowColor,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              isScrollable: true,
              tabs: const [
                Tab(text: 'Statistics'),
                Tab(text: 'Tournaments'),
                Tab(text: 'Matches'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          setState(() {
                            innings = 'batting';
                          });
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: innings == 'batting'
                                ? AppTheme.darkYellowColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'Batting',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: innings == 'batting'
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          setState(() {
                            innings = 'bowling';
                          });
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: innings == 'bowling'
                                ? AppTheme.darkYellowColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'Bowling',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: innings == 'bowling'
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('STATS',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12)),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                              child: VerticalDivider(
                                color: Colors.grey.shade300,
                                thickness: 1,
                                indent: 1,
                                endIndent: 2,
                              ),
                            ),
                            const Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child:
                                    Text('Tennis', textAlign: TextAlign.center),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                              child: VerticalDivider(
                                color: Colors.grey.shade300,
                                thickness: 1,
                                indent: 1,
                                endIndent: 2,
                              ),
                            ),
                            const Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Text(
                                  'Leather',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            // SizedBox(
                            //   height: 40,
                            //   child: VerticalDivider(
                            //     color: Colors.grey.shade300,
                            //     thickness: 1,
                            //     indent: 1,
                            //     endIndent: 2,
                            //   ),
                            // ),
                            // const Expanded(
                            //   child: Padding(
                            //     padding: EdgeInsets.all(8.0),
                            //     child: Text('Fielding'),
                            //   ),
                            // ),
                          ],
                        ),
                        Divider(
                          height: 0,
                          color: Colors.grey.shade300,
                          thickness: 1,
                          indent: 1,
                          endIndent: 2,
                        ),
                        FutureBuilder<Map<String, dynamic>>(
                          future: controller.getMyPerformance(
                            userId: authcontroller.state!.id,
                            category: innings,
                          ),
                          builder: (context, snapshot) {
                            // if (snapshot.connectionState == ConnectionState.waiting) {
                            //   return const Center(child: CircularProgressIndicator());
                            // }

                            if (snapshot.hasError) {
                              return const Center(
                                child: Text(
                                  "Something went wrong",
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(
                                child: Text(
                                  "No data available",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              );
                            }
                            final performanceData = snapshot.data!;
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: performanceData.length,
                              itemBuilder: (context, index) {
                                final statKey =
                                    performanceData.keys.elementAt(index);
                                final statValues = performanceData[statKey];
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          statKey.capitalize ?? '',
                                          textAlign: TextAlign.center,
                                          style: _valueStyle(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      child: VerticalDivider(
                                        color: Colors.grey.shade300,
                                        thickness: 1,
                                        indent: 1,
                                        endIndent: 2,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          statValues['tennis'].toString(),
                                          textAlign: TextAlign.center,
                                          style: _valueStyle(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      child: VerticalDivider(
                                        color: Colors.grey.shade300,
                                        thickness: 1,
                                        indent: 1,
                                        endIndent: 2,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          statValues['leather'].toString(),
                                          textAlign: TextAlign.center,
                                          style: _valueStyle(),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text("Recent Forms",style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2
                  ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Obx(() {
                    if (controller.performance.value == null) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final battingData = controller.performance.value?.latestMatchesData
                        ?.map((match) {
                      final runs = match.playerData?.batting['runs']?.toString() ?? '0';
                      final balls = match.playerData?.batting['balls']?.toString() ?? '0';
                      return (balls == '0') ? '-' : runs;
                    }).toList() ?? [];
                    if(battingData.isEmpty){
                      battingData.addAll(['-', '-', '-', '-', '-']);
                    }
                    final bowlingData = controller.performance.value?.latestMatchesData
                        ?.map((match) {
                      final wickets = match.playerData?.bowling['wickets']?.toString() ?? '0';
                      final runs = match.playerData?.bowling['runs']?.toString() ?? '0';
                      final overs = match.playerData?.bowling['overs']?.toString() ?? '0.0';
                      return (overs == '0.0') ? '-' : '$wickets-$runs';
                    }).toList() ?? [];

                    if(bowlingData.isEmpty){
                      bowlingData.addAll(['-', '-', '-', '-', '-']);
                    }
                    return Column(
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.black,
                              child: Text(
                                'Bat',
                                style: TextStyle(color: Colors.white,fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: SizedBox(
                                height: 40,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: battingData.length,
                                  itemBuilder: (context, index) {
                                    return CircleAvatar(
                                      backgroundColor: Colors.grey.shade200,
                                      child: Text(battingData[index].isEmpty ? '-':battingData[index],style: const TextStyle(fontSize: 14,color: Colors.black)),
                                    );
                                  },
                                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.black,
                              child: Text(
                                'Bowl',
                                style: TextStyle(color: Colors.white,fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: SizedBox(
                                height: 40,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: bowlingData.length,
                                  itemBuilder: (context, index) {
                                    return CircleAvatar(
                                      backgroundColor: Colors.grey.shade200,
                                      child: Text(bowlingData[index].isEmpty ? '-':bowlingData[index],style: const TextStyle(fontSize: 14,color: Colors.black)),
                                    );
                                  },
                                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(25, 16, 25, 8),
                  child: Text(
                    "Best Performances",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Obx(() {
                  // if (controller.bestBattingPerformance.isEmpty && controller.bestBowlingPerformance.isEmpty) {
                  //   return const SizedBox(height: 200);
                  // }
                  if(controller.performance.value!.bestBattingPerformance!.isEmpty){

                  }
                  return  BestPerformanceCard(
                    battingPerformance: controller.performance.value!.bestBattingPerformance,
                    bowlingPerformance:controller.performance.value!.bestBowlingPerformance ,

                  );
                }),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() {
                final matches = controller.performance.value?.matches;
                if (matches == null || matches.isEmpty) {
                  return const Center(child: Text('No matches available'));
                }
                return Column(
                  children: matches.map((match) {
                    return Performance_matchup(
                      matchup: match,
                    );
                  }).toList(),
                );
              }),
            ),
          ),

        ],
      ),
    ));
  }
  TextStyle _valueStyle() {
    return const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  }
}

class BestPerformanceCard extends StatefulWidget {
  final Map<String, dynamic>? battingPerformance;
  final Map<String, dynamic>? bowlingPerformance;

  const BestPerformanceCard({
    Key? key,
    required this.battingPerformance,
    required this.bowlingPerformance,
  }) : super(key: key);

  @override
  State<BestPerformanceCard> createState() => _BestPerformanceCardState();
}

class _BestPerformanceCardState extends State<BestPerformanceCard>
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.1),
        //     blurRadius: 6,
        //     offset: const Offset(0, 3),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            physics: const NeverScrollableScrollPhysics(),
            unselectedLabelColor: Colors.black87,
            // indicator: BoxDecoration(
            //   color: Colors.black,
            //   borderRadius: BorderRadius.circular(12),
            // ),
            tabs: const [
              Tab(text: 'Batting'),
              Tab(text: 'Bowling'),
            ],
          ),
          // const SizedBox(height: 16),
          SizedBox(
            height: 80,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPerformanceContent(
                  type: 'Batting',
                  performance: widget.battingPerformance,
                ),
                _buildPerformanceContent(
                  type: 'Bowling',
                  performance: widget.bowlingPerformance,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceContent({
    required String type,
    required Map<String, dynamic>? performance,
  }) {
    if (performance == null || performance.isEmpty) {
      return const Center(
        child: Text(
          'No data found',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              type == 'Batting'
                  ? '${performance?['runs'] ?? 0} Runs'
                  : '${performance?['performance'] ?? 0} Wickets',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'vs ${performance?['team'] ?? 'Unknown'}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ],
        ),
        Container(
          height: 60,
          width: 60,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: Icon(
            type == 'Batting' ? Icons.sports_cricket : Icons.sports_baseball,
            color: Colors.white,
            size: 36,
          ),
        ),
      ],
    );
  }
}

class Performance_matchup extends StatelessWidget {
  final MatchupModel matchup;
  final String? tourid;
  const Performance_matchup({super.key, required this.matchup, this.tourid});

  @override
  Widget build(BuildContext context) {
    final ScoreboardModel? scoreboard = matchup.scoreBoard == null
        ? null
        : ScoreboardModel.fromJson(matchup.scoreBoard!);
    final controller = Get.find<TournamentController>();
    logger.d("The Winner id is:${matchup.getWinningTeamName()}");

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
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Match Info
                Row(
                  children: [
                    Text(
                      matchup.round?.capitalize ?? '',
                      style: Get.textTheme.labelMedium?.copyWith(),
                    ),
                    const Spacer(),
                    Text(
                      formatDateTime('dd MMM yyyy hh:mm a', matchup.matchDate),
                      style: Get.textTheme.labelMedium?.copyWith(),
                    ),
                  ],
                ),
                SizedBox(height: Get.height * 0.01),
                // Team Info
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
                    const SizedBox(height: 5),
                    teamView(
                      matchup.team2.logo ?? '',
                      matchup.team2.name,
                      scoreboard.currentInnings == 1
                          ? "Did Not Bat"
                          : '${scoreboard.secondInnings?.totalScore}/${scoreboard.secondInnings?.totalWickets ?? 0}',
                    ),
                  ],
                ),
                // Match Result
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: const EdgeInsets.only(top: 8.0),
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.green.shade600,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      scoreboard.secondInningsText ?? "",
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // "View Match Statistics" Button
                // GestureDetector(
                //   onTap: () {
                //     // Navigate to the match statistics screen
                //     // Get.to(() => MatchStatisticsScreen(matchup: matchup));
                //   },
                //   child: Container(
                //     margin: const EdgeInsets.only(top: 8.0),
                //     padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
                //     decoration: BoxDecoration(
                //       color: Colors.blue.shade600,
                //       borderRadius: BorderRadius.circular(5.0),
                //     ),
                //     child: Text(
                //       "View Match Statistics",
                //       style: Get.textTheme.bodyMedium?.copyWith(
                //         color: Colors.white,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Empty Scorecard View when match not started yet
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
                        as ImageProvider,
                      ),
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
                      const SizedBox(height: 20),
                      Chip(
                        label: Text('VS',
                            style: Get.textTheme.labelLarge?.copyWith(
                                color: Colors.white, fontWeight: FontWeight.bold)),
                        backgroundColor: AppTheme.secondaryYellowColor,
                        side: BorderSide.none,
                      ),
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
                        as ImageProvider,
                      ),
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
            ],
          ),
        ),
      ),
    );
  }

  // Team View (Logo, Name, and Score)
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

