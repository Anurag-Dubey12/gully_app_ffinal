import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/scoreboard_controller.dart';
import 'package:gully_app/data/model/bowling_model.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/ui/widgets/scorecard/batting_card.dart';

import '../../data/model/player_model.dart';
import '../../data/model/scoreboard_model.dart';
import '../../utils/app_logger.dart';
import '../widgets/scorecard/extras_and_total.dart';

class FullScoreboardScreen extends StatefulWidget {
  final ScoreboardModel? scoreboard;
  const FullScoreboardScreen({Key? key, this.scoreboard}) : super(key: key);

  @override
  State<FullScoreboardScreen> createState() => _FullScoreboardScreenState();
}

class _FullScoreboardScreenState extends State<FullScoreboardScreen> {
  int currentInning = 1;
  List<PlayerModel> battingTeamPlayers = [];
  List<PlayerModel> opponentBattingTeamPlayers = [];
  List<PlayerModel> bowlingTeam = [];
  OverlayEntry? _overlayEntry;
  String selectedTeamName = "";
  final GlobalKey _dropdownKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    final controller = Get.find<ScoreBoardController>();
    if (widget.scoreboard != null) {
      updateInningData();
    } else {
      battingTeamPlayers =
          controller.scoreboard.value?.firstInnings?.battingTeam.players ?? [];
      controller.scoreboard.value?.firstInnings?.battingTeam.players ?? [];
      opponentBattingTeamPlayers = currentInning == 1
          ? widget.scoreboard?.secondInnings?.bowlingTeam.players ?? []
          : widget.scoreboard?.firstInnings?.bowlingTeam.players ?? [];

      bowlingTeam =
          controller.scoreboard.value?.firstInnings?.bowlingTeam.players ?? [];
      selectedTeamName = controller.scoreboard.value?.team1.name ?? "";
    }
  }

  void updateInningData() {
    setState(() {
      if (widget.scoreboard != null) {
        battingTeamPlayers = currentInning == 1
            ? widget.scoreboard?.firstInnings?.battingTeam.players ?? []
            : widget.scoreboard?.secondInnings?.battingTeam.players ??
                widget.scoreboard?.team2.players ??
                [];
        opponentBattingTeamPlayers = currentInning == 1
            ? widget.scoreboard?.secondInnings?.bowlingTeam.players ?? []
            : widget.scoreboard?.firstInnings?.bowlingTeam.players ?? [];
        bowlingTeam = currentInning == 1
            ? widget.scoreboard?.firstInnings?.bowlingTeam.players ?? []
            : widget.scoreboard?.secondInnings?.bowlingTeam.players ??
                widget.scoreboard?.team1.players ??
                [];
        selectedTeamName = currentInning == 1
            ? widget.scoreboard?.team1.name ?? ""
            : widget.scoreboard?.team2.name ?? "";
      }
    });
  }

  void changeInning(int selected) {
    final controller = Get.find<ScoreBoardController>();
    setState(() {
      if (widget.scoreboard != null) {
        currentInning = selected;
        updateInningData();
      } else {
        currentInning = selected;
        battingTeamPlayers = currentInning == 1
            ? controller.scoreboard.value?.firstInnings?.battingTeam.players ??
                []
            : controller.scoreboard.value?.secondInnings?.battingTeam.players ??
                [];

        opponentBattingTeamPlayers = currentInning == 1
            ? controller.scoreboard.value?.secondInnings?.bowlingTeam.players ??
                []
            : controller.scoreboard.value?.firstInnings?.bowlingTeam.players ??
                [];

        bowlingTeam = currentInning == 1
            ? controller.scoreboard.value?.firstInnings?.bowlingTeam.players ??
                []
            : controller.scoreboard.value?.secondInnings?.bowlingTeam.players ??
                [];

        selectedTeamName = currentInning == 1
            ? controller.scoreboard.value?.team1.name ?? ""
            : controller.scoreboard.value?.team2.name ?? "";
      }
    });

    //logger.d"Current inning: $currentInning");
    //logger.d"Batting team players: ${battingTeamPlayers.map((player) => player.name)}");
    //logger.d"Opponent batting team players: ${opponentBattingTeamPlayers.map((player) => player.name)}");
  }

  void _toggleDropdown(GlobalKey key) {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry(key);
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlayEntry(GlobalKey key) {
    RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    const double spacing = 5.0;

    final controller = Get.find<ScoreBoardController>();

    return OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _overlayEntry?.remove();
          _overlayEntry = null;
        },
        child: Stack(
          children: [
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height + spacing,
              width: size.width,
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: widget.scoreboard == null
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text(
                                controller.scoreboard.value!.team1.name,
                                style: const TextStyle(fontSize: 16),
                              ),
                              onTap: () {
                                setState(() {
                                  changeInning(1);
                                  selectedTeamName =
                                      controller.scoreboard.value!.team1.name;
                                });
                                _overlayEntry?.remove();
                                _overlayEntry = null;
                              },
                            ),
                            const Divider(height: 1, color: Colors.grey),
                            ListTile(
                              title: Text(
                                controller.scoreboard.value!.team2.name,
                                style: const TextStyle(fontSize: 16),
                              ),
                              onTap: () {
                                setState(() {
                                  changeInning(2);
                                  selectedTeamName =
                                      controller.scoreboard.value!.team2.name;
                                });
                                _overlayEntry?.remove();
                                _overlayEntry = null;
                              },
                            ),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text(
                                widget.scoreboard?.team1.name ?? "Team 1",
                                style: const TextStyle(fontSize: 16),
                              ),
                              onTap: () {
                                changeInning(1);
                                _overlayEntry?.remove();
                                _overlayEntry = null;
                              },
                            ),
                            const Divider(height: 1, color: Colors.grey),
                            ListTile(
                              title: Text(
                                widget.scoreboard?.team2.name ?? "Team 2",
                                style: const TextStyle(fontSize: 16),
                              ),
                              onTap: () {
                                changeInning(2);
                                _overlayEntry?.remove();
                                _overlayEntry = null;
                              },
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.find<ScoreBoardController>();
    return GradientBuilder(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Full Scoreboard',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: GestureDetector(
                      onTap: () => _toggleDropdown(_dropdownKey),
                      child: Container(
                        key: _dropdownKey,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedTeamName,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: Column(children: [
                            // widget.scoreboard?.secondInnings==null && opponentBattingTeamPlayers.isNotEmpty ?
                            //   const Padding(
                            //     padding: EdgeInsets.all(8.0),
                            //     child: Text(
                            //       "This inning has not Started. Showing lineup.",
                            //       style: TextStyle(
                            //         color: Colors.black,
                            //         fontSize: 14,
                            //         fontWeight: FontWeight.bold,
                            //       ),
                            //       textAlign: TextAlign.center,
                            //     ),
                            //   ):const SizedBox.shrink(),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                // borderRadius: BorderRadius.circular(5)
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: GestureDetector(
                                      child: Text('Batter',
                                          style: Get.textTheme.labelMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Colors.black)),
                                    ),
                                  ),
                                  const Spacer(flex: 1),
                                  Expanded(
                                    child: Center(
                                      child: Text('R',
                                          style: Get.textTheme.labelMedium
                                              ?.copyWith(color: Colors.black)),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text('B',
                                          style: Get.textTheme.labelMedium
                                              ?.copyWith(color: Colors.black)),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text('4s',
                                          style: Get.textTheme.labelMedium
                                              ?.copyWith(color: Colors.black)),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text('6s',
                                          style: Get.textTheme.labelMedium
                                              ?.copyWith(color: Colors.black)),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text('SR',
                                          style: Get.textTheme.labelMedium
                                              ?.copyWith(color: Colors.black)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1, color: Colors.grey),
                            const SizedBox(height: 4),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (c, i) =>
                                  const SizedBox(height: 10),
                              // itemCount: currentInning == 1 ? battingTeamPlayers.length : opponentBattingTeamPlayers.length,
                              itemCount: battingTeamPlayers.length,
                              itemBuilder: ((context, index) {
                                // final player = currentInning == 1 ? battingTeamPlayers[index] : opponentBattingTeamPlayers[index];
                                // return BatterPlayerStat(player, false, currentInning == 1);
                                // return BatterPlayerStat(battingTeamPlayers[index], false, currentInning == 1);
                                return BatterPlayerStat(
                                    battingTeamPlayers[index],
                                    false,
                                    true,
                                    false);
                              }),
                            ),
                            const SizedBox(height: 10),
                            widget.scoreboard != null
                                ? ExtrasAndTotal(
                                    currentInning: currentInning,
                                    scoreboard: widget.scoreboard,
                                  )
                                : ExtrasAndTotal(currentInning: currentInning),
                            const Divider(height: 1),
                            Column(children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  // borderRadius: BorderRadius.circular()
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text('Bowler',
                                          style: Get.textTheme.labelMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Colors.black)),
                                    ),
                                    const Spacer(flex: 2),
                                    Expanded(
                                      child: Center(
                                        child: Text('O',
                                            style: Get.textTheme.labelMedium
                                                ?.copyWith(
                                                    color: Colors.black)),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text('M',
                                            style: Get.textTheme.labelMedium
                                                ?.copyWith(
                                                    color: Colors.black)),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text('R',
                                            style: Get.textTheme.labelMedium
                                                ?.copyWith(
                                                    color: Colors.black)),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text('W',
                                            style: Get.textTheme.labelMedium
                                                ?.copyWith(
                                                    color: Colors.black)),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text('ER',
                                            style: Get.textTheme.labelMedium
                                                ?.copyWith(
                                                    color: Colors.black)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(height: 1, color: Colors.grey),
                              const SizedBox(height: 3),
                              GetBuilder<ScoreBoardController>(
                                builder: (controller) {
                                  final activeBowlers = bowlingTeam
                                      .where((player) =>
                                          player.bowling != null &&
                                          (player.bowling!.currentOver > 0 ||
                                              player.bowling!.currentBall > 0 ||
                                              player.bowling!.runs > 0))
                                      .toList();
                                  return ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    separatorBuilder: (c, i) =>
                                        const SizedBox(height: 10),
                                    itemCount: activeBowlers.length,
                                    itemBuilder: ((context, index) {
                                      return ScoreboardBowlerPlayerStat(
                                          activeBowlers[index]);
                                    }),
                                  );
                                },
                              ),
                              const SizedBox(height: 4),
                            ])
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScoreboardBowlerPlayerStat extends GetView<ScoreBoardController> {
  final PlayerModel bowler;
  const ScoreboardBowlerPlayerStat(this.bowler, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
              flex: 5,
              child: Text(
                bowler.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
          Expanded(
              child: Center(
                  child: Text((getCurrentBowl(bowler.bowling!)),
                      style: Get.textTheme.labelMedium))),
          Expanded(
            child: Center(
                child: Text((bowler.bowling?.maidens ?? "").toString(),
                    style: Get.textTheme.labelMedium)),
          ),
          Expanded(
              child: Center(
                  child: Text(bowler.bowling?.runs.toString() ?? "",
                      style: Get.textTheme.labelMedium))),
          Expanded(
              child: Center(
                  child: Text(bowler.bowling?.wickets.toString() ?? "0",
                      style: Get.textTheme.labelMedium))),
          Expanded(
              child: Center(
                  child: Text(
                      bowler.bowling?.economyRate.toStringAsFixed(1) ?? "N/A",
                      style: Get.textTheme.labelMedium)))
        ],
      ),
    );
  }
}

String getCurrentBowl(BowlingModel bowling) {
  if (bowling.overs.length == 1) {
    return '0.0';
  }

  if (bowling.currentBall == 0 && bowling.overs.entries.last.value.ball != 6) {
    return '${bowling.currentOver}.${bowling.overs.entries.last.value.ball}';
  }
  return '${bowling.currentOver}.${bowling.currentBall}';
}
