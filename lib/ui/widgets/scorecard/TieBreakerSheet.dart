import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gully_app/config/api_client.dart';
import 'package:gully_app/data/model/scoreboard_model.dart';
import 'package:gully_app/data/model/team_model.dart';
import 'package:gully_app/utils/app_logger.dart';

import '../../../data/controller/scoreboard_controller.dart';

class TieBreakerSheet extends StatefulWidget {
  final ScoreboardModel scoreboard;
  final Function(String) onSubmit;
  const TieBreakerSheet({
    super.key,
    required this.scoreboard,
    required this.onSubmit,
  });
  @override
  State<StatefulWidget> createState() => _TieBreakerSheetState();
}

class _TieBreakerSheetState extends State<TieBreakerSheet> {
  String? SelectedTeamId;
  String? SelectedCriteria;
  late final Map<String, Map<String, int>> teamStats;
  bool isManualSelection = false;

  @override
  void initState() {
    teamStats = calculateTeamStats();
    logger.d("Toss Won by:${widget.scoreboard.tossWonBy}");
    super.initState();
  }

  Map<String, Map<String, int>> calculateTeamStats() {
    final team1Fours = widget.scoreboard.firstInningHistory.entries
        .where((entry) => entry.value.run == 4 &&
        !entry.value.events.contains(EventType.legByes) &&
        !entry.value.events.contains(EventType.bye))
        .length;

    final team1Sixes = widget.scoreboard.firstInningHistory.entries
        .where((entry) => entry.value.run == 6 &&
        !entry.value.events.contains(EventType.legByes) &&
        !entry.value.events.contains(EventType.bye))
        .length;
    final team1Wickets = widget.scoreboard.firstInnings!.totalWickets ?? 0;

    final team2Fours = widget.scoreboard.secondInningHistory.entries
        .where((entry) => entry.value.run == 4 &&
        !entry.value.events.contains(EventType.legByes) &&
        !entry.value.events.contains(EventType.bye))
        .length;

    final team2Sixes = widget.scoreboard.secondInningHistory.entries
        .where((entry) => entry.value.run == 6 &&
        !entry.value.events.contains(EventType.legByes) &&
        !entry.value.events.contains(EventType.bye))
        .length;

    final team2Wickets = widget.scoreboard.secondInnings!.totalWickets ?? 0;

    return {
      widget.scoreboard.team1.id: {
        'fours': team1Fours,
        'sixes': team1Sixes,
        'wickets': team1Wickets,
        'boundaries': team1Fours + team1Sixes,
        'toss':widget.scoreboard.tossWonBy==widget.scoreboard.team1.id ?1:0,
      },
      widget.scoreboard.team2.id: {
        'fours': team2Fours,
        'sixes': team2Sixes,
        'wickets': team2Wickets,
        'boundaries': team2Fours + team2Sixes,
        'toss':widget.scoreboard.tossWonBy==widget.scoreboard.team2.id ?1:0,
      }
    };
  }

  void updateSelectedTeam() {
    if (SelectedCriteria == null) return;

    final team1Value = teamStats[widget.scoreboard.team1.id]![SelectedCriteria]!;
    final team2Value = teamStats[widget.scoreboard.team2.id]![SelectedCriteria]!;

    if (team1Value == team2Value) {
      setState(() {
        isManualSelection = true;
        SelectedTeamId = null;
      });
    } else {
      setState(() {
        isManualSelection = false;
        if (SelectedCriteria == 'wickets') {
          SelectedTeamId = team1Value < team2Value
              ? widget.scoreboard.team1.id
              : widget.scoreboard.team2.id;
        } else if(SelectedCriteria=='toss'){
          SelectedTeamId=team1Value>team2Value ?
          widget.scoreboard.team1.id
              : widget.scoreboard.team2.id;
        }
        else {
          SelectedTeamId = team1Value > team2Value
              ? widget.scoreboard.team1.id
              : widget.scoreboard.team2.id;
        }
      });
    }
  }

  Widget winnerTypes({
    required String label,
    required String imagePath,
    required String criteria,
  }) {
    bool isSelected = SelectedCriteria == criteria;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? Colors.black : Colors.transparent,
              width: 2,
            ),
          ),
          child: IconButton(
            onPressed: () {
              if (criteria == 'superovers') {
                // updateSuperOverData();
                logger.d("Clicked Scoreboar");
              } else {
                setState(() {
                  SelectedCriteria = criteria;
                  updateSelectedTeam();
                });
                logger.d("Selected Types:$criteria");
              }
            },
            icon: Image.asset(
              imagePath,
              height: 40,
              width: 40,
              color: isSelected ? Colors.black : Colors.grey,
            ),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.black : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget TeamStats({
    required String? imagePath,
    required String teamName,
    required String teamId,
    required int score,
    required bool isWinner,
  }) {
    return GestureDetector(
      onTap: isManualSelection ? () {
        setState(() {
          SelectedTeamId = teamId;
        });
      } : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isWinner ? Colors.white : Colors.grey.withOpacity(0.05),
          border: Border.all(
            color: isWinner ? Colors.black : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: isWinner
              ? [
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ]
              : null,
        ),
        child: Column(
          children: [
            Row(
              children: [
                teamlogo(
                  logoUrl: imagePath,
                  isWinner: isWinner,
                  teamName: teamName,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              teamName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isWinner ? FontWeight.bold : FontWeight.w200,
                                color: isWinner ? Colors.black : Colors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isWinner && !isManualSelection) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.emoji_events,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'WINNER',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber.shade900,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isWinner
                              ? Colors.black
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getCriteriaIcon(),
                              size: 18,
                              color: isWinner ? Colors.white : Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              getCriteriaText(score),
                              style: TextStyle(
                                fontSize: 13,
                                color: isWinner ? Colors.white : Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget teamlogo({
    required String? logoUrl,
    required bool isWinner,
    required String teamName,
  }) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isWinner ? Colors.black : Colors.grey.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: SizedBox(
          width: 50,
          height: 50,
          child: logoUrl != null && logoUrl.isNotEmpty
              ? Image.network(
            logoUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return teamIconPlaceHolder(isWinner);
            },
            errorBuilder: (context, error, stackTrace) {
              return teamInitialsPlaceholder(teamName, isWinner);
            },
          )
              : teamInitialsPlaceholder(teamName, isWinner),
        ),
      ),
    );
  }
  Widget teamIconPlaceHolder(bool isWinner) {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: isWinner ? Colors.black : Colors.grey,
        ),
      ),
    );
  }

  Widget teamInitialsPlaceholder(String teamName, bool isWinner) {
    final initials = teamName
        .split(' ')
        .take(2)
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() : '')
        .join();

    return Container(
      color: isWinner ? Colors.black : Colors.grey[200],
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isWinner ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }
  IconData _getCriteriaIcon() {
    switch (SelectedCriteria) {
      case 'fours':
        return Icons.looks_4_rounded;
      case 'sixes':
        return Icons.looks_6_rounded;
      case 'wickets':
        return Icons.sports_cricket;
      case 'boundaries':
        return Icons.score;
      default:
        return Icons.analytics;
    }
  }

  String getCriteriaText(int score) {
    switch (SelectedCriteria) {
      case 'fours':
        return '$score Fours';
      case 'sixes':
        return '$score Sixes';
      case 'wickets':
        return '$score Wickets Lost';
      case 'boundaries':
        return '$score Boundaries';
      default:
        return 'Score: $score';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              "Choose The Method to Select Winner",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              winnerTypes(
                label: "Toss",
                imagePath: "assets/images/toss.png",
                criteria: 'toss',
              ),
              winnerTypes(
                label: "Sixes",
                imagePath: "assets/images/umpire_six.png",
                criteria: 'sixes',
              ),
              winnerTypes(
                label: "Wickets",
                imagePath: "assets/images/umpire_wicket.png",
                criteria: 'wickets',
              ),
              // winnerTypes(
              //   label: "Super-Overs",
              //   imagePath: "assets/images/umpire_wicket.png",
              //   criteria: 'superovers',
              // ),
            ],
          ),
          if (SelectedCriteria != null) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(
                  "Team Comparison",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (isManualSelection)
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  "Teams have equal values. Tap on a team to select the winner or consider different Method to decide Winner.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            TeamStats(
              teamName: widget.scoreboard.team1.name,
              imagePath: widget.scoreboard.team1.logo,
              teamId: widget.scoreboard.team1.id,
              score: teamStats[widget.scoreboard.team1.id]![SelectedCriteria]!,
              isWinner: SelectedTeamId == widget.scoreboard.team1.id,
            ),
            const SizedBox(height: 12),
            TeamStats(
              teamName: widget.scoreboard.team2.name,
              imagePath: widget.scoreboard.team2.logo,
              teamId: widget.scoreboard.team2.id,
              score: teamStats[widget.scoreboard.team2.id]![SelectedCriteria]!,
              isWinner: SelectedTeamId == widget.scoreboard.team2.id,
            ),
            const SizedBox(height: 20),
            if (SelectedTeamId != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onSubmit(SelectedTeamId!);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Confirm Winner",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
class SuperOverData {
  final String team1Id;
  final String team2Id;
  final int team1Score;
  final int team2Score;

  SuperOverData({
    required this.team1Id,
    required this.team2Id,
    required this.team1Score,
    required this.team2Score
  });

  int getTeamScore(String teamId) {
    return teamId == team1Id ? team1Score : team2Score;
  }
}
class SuperOverDialog extends StatefulWidget {
  final TeamModel team1;
  final TeamModel team2;
  final Function(SuperOverData) onSubmit;

  const SuperOverDialog({
    super.key,
    required this.team1,
    required this.team2,
    required this.onSubmit
  });

  @override
  _SuperOverDialogState createState() => _SuperOverDialogState();
}

class _SuperOverDialogState extends State<SuperOverDialog> {
  final TextEditingController _team1Controller = TextEditingController();
  final TextEditingController _team2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Super Over Scores'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _team1Controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: '${widget.team1.name} Score',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _team2Controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: '${widget.team2.name} Score',
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final team1Score = int.tryParse(_team1Controller.text) ?? 0;
            final team2Score = int.tryParse(_team2Controller.text) ?? 0;

            final superOverData = SuperOverData(
                team1Id: widget.team1.id,
                team2Id: widget.team2.id,
                team1Score: team1Score,
                team2Score: team2Score
            );

            widget.onSubmit(superOverData);
            Navigator.of(context).pop();
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _team1Controller.dispose();
    _team2Controller.dispose();
    super.dispose();
  }
}