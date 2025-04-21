import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/data/controller/team_controller.dart';
import 'package:gully_app/ui/screens/schedule_screen.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';

import '../../data/controller/tournament_controller.dart';
import '../widgets/performance/BestPerformanceCard.dart';
import '../widgets/performance/performance_matches.dart';
import '../widgets/performance/performance_tournament.dart';

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
                Tab(text: 'Matches'),
                Tab(text: 'Tournaments'),
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
                  child: Text(
                    "Recent Forms",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Obx(() {
                    if (controller.performance.value == null) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final battingData = controller
                            .performance.value?.latestMatchesData
                            ?.map((match) {
                          final runs =
                              match.playerData?.batting['runs']?.toString() ??
                                  '0';
                          final balls =
                              match.playerData?.batting['balls']?.toString() ??
                                  '0';
                          return (balls == '0') ? '-' : runs;
                        }).toList() ??
                        [];
                    if (battingData.isEmpty) {
                      battingData.addAll(['-', '-', '-', '-', '-']);
                    }
                    final bowlingData = controller
                            .performance.value?.latestMatchesData
                            ?.map((match) {
                          final wickets = match.playerData?.bowling['wickets']
                                  ?.toString() ??
                              '0';
                          final runs =
                              match.playerData?.bowling['runs']?.toString() ??
                                  '0';
                          final overs =
                              match.playerData?.bowling['overs']?.toString() ??
                                  '0.0';
                          return (overs == '0.0') ? '-' : '$wickets-$runs';
                        }).toList() ??
                        [];

                    if (bowlingData.isEmpty) {
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
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
                                      child: Text(
                                          battingData[index].isEmpty
                                              ? '-'
                                              : battingData[index],
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black)),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(width: 8),
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
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
                                      child: Text(
                                          bowlingData[index].isEmpty
                                              ? '-'
                                              : bowlingData[index],
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black)),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(width: 8),
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
                  return BestPerformanceCard(
                    battingPerformance:
                        controller.performance.value?.bestBattingPerformance,
                    bowlingPerformance:
                        controller.performance.value?.bestBowlingPerformance,
                  );
                }),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() {
                final matches = controller.performance.value?.matches.reversed;
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() {
                var tournaments =
                    controller.performance.value?.userPlayedTournament ?? [];
                if (tournaments.isEmpty) {
                  return const Center(child: Text("No tournaments available"));
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tournaments.length,
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var tournament = tournaments[index];
                      return PerformanceTournament(
                        tournament: tournament,
                        onTap: () {
                          final tournamentController =
                              Get.find<TournamentController>();
                          tournamentController.tournamentname.value =
                              tournament['tournamentName'];
                          Get.to(() => ScheduleScreen(performance: tournament));
                        },
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                  ),
                );
              }),
            ),
          )
        ],
      ),
    ));
  }

  TextStyle _valueStyle() {
    return const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  }
}
