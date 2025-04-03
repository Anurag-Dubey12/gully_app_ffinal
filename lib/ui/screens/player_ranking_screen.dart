import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/player_ranking_model.dart';
import 'package:gully_app/utils/utils.dart';

import '../../data/controller/ranking_controller.dart';
import '../../utils/FallbackImageProvider.dart';
import '../../utils/app_logger.dart';
import '../../utils/internetConnectivty.dart';
import '../theme/theme.dart';
import '../widgets/arc_clipper.dart';

class PlayerRankingScreen extends StatefulWidget {
  const PlayerRankingScreen({super.key});

  @override
  State<PlayerRankingScreen> createState() => _PlayerRankingScreenState();
}

class _PlayerRankingScreenState extends State<PlayerRankingScreen> {
  int _selectedTab = 0;
  int _selectedChildTab = 1;
  String get selectedTab => _selectedTab == 0 ? 'leather' : 'tennis';
  final Internetconnectivty _connectivityService = Internetconnectivty();
  bool _isConnected = true;
  String get selectedChildTab {
    switch (_selectedChildTab) {
      case 1:
        return 'batting';
      case 2:
        return 'bowling';
      case 3:
        return 'all-rounder';
      default:
        return 'batting';
    }
  }

  @override
  initState() {
    super.initState();
    _connectivityService.listenToConnectionChanges((isConnected) {
      setState(() {
        _isConnected = isConnected;
      });
      if (!isConnected) {
        errorSnackBar("Please connect to the network");
      }
    });
  }

  @override
  void dispose() {
    _connectivityService.dispose();
    super.dispose();
  }

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
                          title: const Text('Player Ranking',
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _SelectBallTypeCard(
                                tab: 1,
                                selectedTab: _selectedChildTab,
                                text: 'Batting',
                                isChild: true,
                                onTap: (st) {
                                  setState(() {
                                    // ignore: unnecessary_statements
                                    _selectedChildTab = st;
                                  });
                                },
                              ),
                              const SizedBox(width: 10),
                              _SelectBallTypeCard(
                                tab: 2,
                                selectedTab: _selectedChildTab,
                                text: 'Bowling',
                                isChild: true,
                                onTap: (st) {
                                  setState(() {
                                    // ignore: unnecessary_statements
                                    _selectedChildTab = st;
                                  });
                                },
                              ),
                              const SizedBox(width: 10),
                              _SelectBallTypeCard(
                                tab: 3,
                                selectedTab: _selectedChildTab,
                                text: 'All Rounder ',
                                isChild: true,
                                onTap: (st) {
                                  setState(() {
                                    // ignore: unnecessary_statements
                                    _selectedChildTab = 3;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                              color: Colors.black26,
                              // height: Get.height * 0.6,
                              child: _isConnected
                                  ? FutureBuilder<List<PlayerRankingModel>>(
                                      future: controller.getPlayerRankingList(
                                          _selectedTab == 0
                                              ? 'leather'
                                              : 'tennis',
                                          selectedChildTab),
                                      builder: (context, snapshot) {
                                        if (snapshot.error != null) {
                                          //logger.e(
                                              // "Player Ranking Screen Error: ${snapshot.error}");
                                          return const Center(
                                            child:
                                                Text('Something went Wrong '),
                                          );
                                        }
                                        if (!_isConnected) {
                                          return const Center(
                                            child: Text(
                                              'No Internet Connection',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 18),
                                            ),
                                          );
                                        }
                                        return ListView.separated(
                                            padding: const EdgeInsets.all(20),
                                            itemCount:
                                                snapshot.data?.length ?? 0,
                                            shrinkWrap: true,
                                            separatorBuilder: (c, i) =>
                                                const SizedBox(height: 10),
                                            itemBuilder: (c, i) {
                                              final player = snapshot.data![i];
                                              final rank =
                                                  (i < 3) ? (i + 1) : null;
                                              return _TeamCard(
                                                player: player,
                                                rank: i + 1,
                                                selectedChildTab:
                                                    selectedChildTab,
                                              );
                                            });
                                      })
                                  : const Center(
                                      child: Text(
                                        'No internet connection',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18),
                                      ),
                                    )),
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
  final int? rank;
  final String selectedChildTab;
  final PlayerRankingModel player;
  const _TeamCard({
    required this.rank,
    required this.player,
    required this.selectedChildTab,
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
          children: [
            if (rank != null)
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            const SizedBox(width: 5),
            CircleAvatar(
              radius: 23,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: FallbackImageProvider(
                      toImageUrl(player.profilePhoto), 'assets/images/logo.png')
                  as ImageProvider,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(player.playerName,
                      style: Get.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 19)),
                  if (selectedChildTab == 'batting')
                    Text(
                      'Inn ${player.innings} | SR:${player.strikeRate?.toStringAsFixed(2)} | Runs: ${player.runs} |\nFours: ${player.fours} | Sixes: ${player.sixes}',
                      style: Get.textTheme.bodyMedium
                          ?.copyWith(color: Colors.black54, fontSize: 12),
                    ),
                  if (selectedChildTab == 'bowling')
                    FittedBox(
                      child: Text(
                        'Wickets ${player.wickets} | Economy:${player.economy?.toStringAsFixed(2)} | Runs: ${player.runs} |\nFours: ${player.fours} | Sixes: ${player.sixes}',
                        style: Get.textTheme.bodyMedium
                            ?.copyWith(color: Colors.black54, fontSize: 12),
                      ),
                    ),
                  if (selectedChildTab == 'all-rounder')
                    FittedBox(
                      child: Text(
                        'Inn ${player.innings} | SR:${player.strikeRate?.toStringAsFixed(2)} | Runs: ${player.runs} |Fours: ${player.fours} | Sixes: ${player.sixes} \n| Wickets ${player.wickets} | Economy:${player.economy?.toStringAsFixed(2)}',
                        style: Get.textTheme.bodyMedium
                            ?.copyWith(color: Colors.black54, fontSize: 13),
                      ),
                    ),
                ],
              ),
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
  final bool? isChild;

  const _SelectBallTypeCard({
    required this.onTap,
    required this.tab,
    required this.selectedTab,
    required this.text,
    this.isChild,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
      onTap: () => onTap(tab),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // border: Border.all(
          //     color: Colors.black
          // ),
          gradient: tab == selectedTab
              ? const LinearGradient(
                  colors: [AppTheme.secondaryYellowColor, Colors.orangeAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [Colors.white, Colors.grey.shade300],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(57, 0, 0, 0).withOpacity(0.15),
              blurRadius: 30,
              spreadRadius: 2,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => onTap(tab),
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
              child: Text(
                text,
                style: Get.textTheme.bodyLarge?.copyWith(
                  fontSize: isChild ?? false ? 14 : 18,
                  color: selectedTab == tab ? Colors.white : Colors.black,
                  fontWeight:
                      isChild ?? false ? FontWeight.normal : FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
