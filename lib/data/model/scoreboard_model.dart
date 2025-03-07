
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/scoreboard_controller.dart';
import 'package:gully_app/data/model/extras_model.dart';
import 'package:gully_app/data/model/innings_model.dart';
import 'package:gully_app/data/model/overs_model.dart';
import 'package:gully_app/data/model/partnership_model.dart';
import 'package:gully_app/data/model/player_model.dart';
import 'package:gully_app/data/model/team_model.dart';
import 'package:gully_app/ui/widgets/scorecard/change_batter.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:json_annotation/json_annotation.dart';

part 'scoreboard_model.g.dart';

@JsonSerializable(explicitToJson: true, createPerFieldToJson: true)
class ScoreboardModel {
  final TeamModel team1;
  final TeamModel team2;
  final bool? isChallenge;
  @JsonKey(disallowNullValue: false, defaultValue: null)
  InningsModel? firstInnings;
  @JsonKey(disallowNullValue: false, defaultValue: null)
  InningsModel? secondInnings;
  @JsonKey(
      disallowNullValue: false,
      defaultValue: {},
      includeToJson: true,
      includeFromJson: true)
  final Map<String, PartnershipModel> partnerships;
  @JsonKey(includeToJson: true)
  final String matchId;
  @JsonKey()
  final String tossWonBy;
  final String? electedTo;
  final int totalOvers;
  @JsonKey(
      includeToJson: true,
      defaultValue: true,
      includeFromJson: true,
      disallowNullValue: false)
  bool overCompleted = true;

  @JsonKey(
    includeToJson: true,
    name: 'extras',
  )
  ExtraModel extras =
  ExtraModel(wides: 0, noBalls: 0, byes: 0, legByes: 0, penalty: 0);

  int ballsToBowl = 6;
  @JsonKey(
    includeToJson: true,
    includeFromJson: true,
  )
  int currentOver = 0;
  @JsonKey(
    includeToJson: true,
    includeFromJson: true,
  )
  int currentBall = 0;
  @JsonKey(
    includeToJson: true,
    includeFromJson: true,
  )
  int currentInnings;
  int currentInningsScore = 0;
  @JsonKey(
    includeToJson: true,
    includeFromJson: true,
  )
  late String bowlerId;
  @JsonKey(
    includeToJson: true,
    includeFromJson: true,
  )
  late String strikerId;
  @JsonKey(
    includeToJson: true,
    includeFromJson: true,
  )
  late String nonStrikerId;
  @JsonKey(includeToJson: true, defaultValue: {}, includeFromJson: true)
  final Map<String, OverModel> firstInningHistory;
  @JsonKey(includeToJson: true, defaultValue: {}, includeFromJson: true)
  final Map<String, OverModel> secondInningHistory;
  late PlayerModel _partnershipStriker;
  late PlayerModel _partnershipNonStriker;
  Map<String, OverModel> get getCurrentInnings {
    if (currentInnings == 1) {
      return firstInningHistory;
    } else {
      return secondInningHistory;
    }
  }

  @JsonKey(includeFromJson: false, includeToJson: true)
  int get totalWickets => lastBall.wickets;

  ScoreboardModel({
    required this.team1,
    required this.currentInnings,
    required this.team2,
    required this.matchId,
    required this.tossWonBy,
    required this.electedTo,
    required this.totalOvers,
    required this.extras,
    required this.firstInningHistory,
    required this.secondInningHistory,
    required this.strikerId,
    required this.nonStrikerId,
    required this.bowlerId,
    required this.overCompleted,
    required this.partnerships,
    this.isChallenge = false,
  }) {
    partnerships.addAll({
      partnershipKey: PartnershipModel(player1: striker, player2: nonstriker)
    });
    _partnershipStriker = PlayerModel.fromJson(striker.toJson());
    _partnershipNonStriker = PlayerModel.fromJson(nonstriker.toJson());
  }
  String get partnershipKey {
    final List<String> key = [strikerId, nonStrikerId];
    key.sort();
    return key.join(".");
  }

  factory ScoreboardModel.fromJson(Map<String, dynamic> json) =>
      _$ScoreboardModelFromJson(json);
  Map<String, dynamic> toJson() => _$ScoreboardModelToJson(this);

  // List<OverModel?> get currentOverHistory {
  //   final List<OverModel?> temp = [];
  //   for (var i = 0; i < getCurrentInnings.length; i++) {
  //     final String key = '$currentOver.$i';
  //     if (getCurrentInnings.containsKey(key)) {
  //       temp.add(getCurrentInnings[key]!);
  //     } else {
  //       temp.add(null);
  //     }
  //   }
  //   return temp;
  // }
  List<OverModel?> get currentOverHistory {
    final List<OverModel?> temp = [];

    // If over is completed but bowler hasn't changed, show the completed over
    if (overCompleted && currentBall == 0) {
      for (var i = 0; i < getCurrentInnings.length; i++) {
        final String key = '${currentOver-1}.$i';
        if (getCurrentInnings.containsKey(key)) {
          temp.add(getCurrentInnings[key]!);
        } else {
          temp.add(null);
        }
      }
    } else {
      for (var i = 0; i < getCurrentInnings.length; i++) {
        final String key = '$currentOver.$i';
        if (getCurrentInnings.containsKey(key)) {
          temp.add(getCurrentInnings[key]!);
        } else {
          temp.add(null);
        }
      }
    }

    logger.d("current Inning Data:${(getCurrentInnings.length/6).toStringAsFixed(1)}");
    logger.d("Current Over Data:$currentOver");
    return temp;
  }
  bool get isAllOut => lastBall.wickets == 10;

  PlayerModel get striker {
    if (currentInnings == 1) {
      return team1.players!.firstWhere((element) => element.id == strikerId);
    } else {
      return team2.players!.firstWhere((element) => element.id == strikerId);
    }
  }

  PlayerModel get nonstriker {
    if (currentInnings == 1) {
      return team1.players!.firstWhere((element) => element.id == nonStrikerId);
    } else {
      return team2.players!.firstWhere((element) => element.id == nonStrikerId);
    }
  }

  set setStriker(String id) {
    strikerId = id;
  }

  set setNonStriker(String id) {
    nonStrikerId = id;
  }

  PlayerModel get bowler {
    if (currentInnings == 1) {
      return team2.players!.firstWhere((element) => element.id == bowlerId);
    } else {
      return team1.players!.firstWhere((element) => element.id == bowlerId);
    }
  }
  ExtraModel get currentExtras {
    return extras;
  }

  double get currentRunRate {
    if (currentInningsScore == 0) {
      return 0;
    }
    return (currentInningsScore / currentOver);
  }

  OverModel get lastBall {
    if (getCurrentInnings.values.isEmpty) {
      logger.i('Over history is empty');
      return OverModel(
        over: 1,
        ball: 1,
        run: 0,
        wickets: 0,
        extra: 0,
        total: 0,
        events: [],
      );
    }
    return getCurrentInnings.values.last;
  }

  void _incrementBall() {
    currentBall++;
  }

  void _updatePartnership() {
    partnerships[partnershipKey] = PartnershipModel(
        player1: _partnershipStriker, player2: _partnershipNonStriker);
  }

  String get getWinningTeam {
    if ((lastBall.over == totalOvers && lastBall.ball == 6) &&
        currentInningsScore > firstInnings!.totalScore) {
      logger.i('Second team won');
      return team2.id;
    } else if ((lastBall.over == totalOvers && lastBall.ball == 6) ||
        currentInningsScore < firstInnings!.totalScore) {
      logger.i('First team won');
      return team1.id;
    }
    if (currentInningsScore > firstInnings!.totalScore) {
      logger.i('Second team won');
      return team2.id;
    } else {
      return team1.id;
    }
  }

  bool get inningsCompleted {
    if (currentInnings == 1) {
      return (firstInnings?.isOver ?? false) || currentOver == totalOvers;
    } else {
      return isSecondInningsOver;
    }
  }

  bool get isFirstInningsOver {
    logger.i('Checking if first innings is over $matchId');
    if (currentInnings == 1) {
      if (currentOver == totalOvers || lastBall.wickets == 10) {
        logger.i('First innings over');
        return true;
      }
    }
    return false;
  }


  bool get isSecondInningsOver {
    logger.i('Checking if second innings is over $matchId');
    if (currentInnings == 2) {
      // if (lastBall.over == totalOvers && lastBall.ball == 6) {
      if (currentOver == totalOvers || lastBall.wickets == 10) {
        logger.i('Second innings over');
        return true;
      }
      if (currentInningsScore > firstInnings!.totalScore) {
        logger.i('Second innings over');
        return true;
      }
    }
    return false;
  }


  String? get secondInningsText {
    logger.i('Second Inning text is called');
    if (currentInnings == 2) {
      // if (lastBall.over == totalOvers && lastBall.ball == 6) {
      //   return 'Innings Over';
      // }
      if (currentInningsScore > firstInnings!.totalScore) {
        return '${team2.name} won by ${10 - lastBall.wickets} wickets';
      }
      if (lastBall.wickets == 10 &&
          firstInnings!.totalScore > currentInningsScore) {
        return '${team1.name.capitalize} won by ${firstInnings!.totalScore - currentInningsScore} runs';
      }
      if (isSecondInningsOver &&
          firstInnings!.totalScore > currentInningsScore) {
        return '${team1.name.capitalize} won by ${firstInnings!.totalScore - currentInningsScore} runs';
      }
      if (isSecondInningsOver &&
          currentInningsScore == firstInnings!.totalScore) {
        // final MatchupModel match;
        return "Match Tied";
      }
      final int runsRequired =
          (firstInnings!.totalScore - currentInningsScore) + 1;
      int oversRemaining = totalOvers - currentOver;
      int ballRemaining = 6 - currentBall;
      oversRemaining = ballRemaining == 6 ? oversRemaining : oversRemaining - 1;
      ballRemaining = ballRemaining == 6 ? 0 : ballRemaining;
      final String text =
          '${team2.name} needs $runsRequired runs in $oversRemaining.$ballRemaining overs';
      return text;
    }
    return null;
  }

  // String? _getWinningTeamNameForTiedMatch() {
  //
  //   MatchupModel match;
  //   if(match.winningTeam==null){}
  //   return null;
  // }
  String getBowlerName(String bowlerId) {
    if (currentInnings == 1) {
      return team2.players!
          .firstWhere(
              (player) => player.id == bowlerId,
          orElse: () => PlayerModel(
              name: 'Unknown',
              id: 'unknown_id',
              phoneNumber: 'unknown',
              role: 'unknown'
          )
      )
          .name;
    } else {
      return team1.players!
          .firstWhere(
              (player) => player.id == bowlerId,
          orElse: () => PlayerModel(
              name: 'Unknown',
              id: 'unknown_id',
              phoneNumber: 'unknown',
              role: 'unknown'
          )
      )
          .name;
    }
  }

  // void addWicket(int wickets,int runs,ScoreBoardController controller,{bool shouldAddRuns = true}) async{
  //   logger.d("Processing wicket");
  //   try {
  //     final res = await Get.bottomSheet(
  //         BottomSheet(
  //             backgroundColor: Colors.white,
  //             onClosing: () {},
  //             builder: (c) => const ChangeBatterWidget()),
  //         isDismissible: false,
  //         enableDrag: false);
  //     if (res != null) {
  //       logger.d("Wicket result: $res");
  //       wickets += 1;
  //       _updateSR();
  //
  //       if (res['outType'] == "RO") {
  //         logger.d('Run out: Adding $runs runs to striker ${striker.name}');
  //         striker.batting!.runs = striker.batting!.runs + runs;
  //         _partnershipStriker.batting!.runs = _partnershipStriker.batting!.runs + runs;
  //       } else {
  //         logger.d('Not adding runs due to dismissal type: ${res['outType']}');
  //         shouldAddRuns = false;
  //       }
  //
  //       if (res['playerToOut'] != null) {
  //         logger.d('Processing playerToOut: ${res['playerToOut']}');
  //         if (res['playerToOut'] == strikerId) {
  //           logger.d('Striker ${striker.name} is out');
  //           striker.batting!.bowledBy = controller.getBowlerName(bowlerId);
  //           striker.batting!.outType = res['outType'];
  //           setStriker = res['batsmanId'];
  //         } else {
  //           logger.d('Non-striker ${nonstriker.name} is out');
  //           nonstriker.batting!.bowledBy = controller.getBowlerName(bowlerId);
  //           nonstriker.batting!.outType = res['outType'];
  //           setNonStriker = res['batsmanId'];
  //         }
  //       } else {
  //         logger.d('Default out processing for striker ${striker.name}');
  //         striker.batting!.outType = res['outType'];
  //         striker.batting!.bowledBy = controller.getBowlerName(bowlerId);
  //         setStriker = res['batsmanId'];
  //       }
  //
  //       logger.d('Updating partnership players');
  //       _partnershipStriker = PlayerModel(
  //         name: striker.name,
  //         id: strikerId,
  //         phoneNumber: striker.phoneNumber,
  //         role: striker.role,
  //       );
  //       _partnershipNonStriker = PlayerModel(
  //         name: nonstriker.name,
  //         id: nonStrikerId,
  //         phoneNumber: nonstriker.phoneNumber,
  //         role: nonstriker.role,
  //       );
  //     } else {
  //       logger.d("Wicket processing cancelled");
  //       return;
  //     }
  //   } catch (e) {
  //     logger.e("Error processing wicket: $e");
  //     return;
  //   }
  // }

  Future<void> addRuns(int runs,
      {List<EventType>? events, List<EventType>? extraEvents}) async {
    logger.d("Starting addRuns with $runs runs");
    logger.d("Current events: ${events?.map((e) => e.toString()).join(', ')}");

    bool shouldAddRuns = true;
    events ??= [];
    int extraRuns = 0;
    int wickets = 0;
    String key = '$currentOver.${ballsToBowl - 6}';
    int ball = currentBall;
    int over = currentOver + 1;

    final ScoreBoardController controller = Get.find<ScoreBoardController>();

    if (!events.contains(EventType.legByes) &&
        !events.contains(EventType.bye) &&
        !events.contains(EventType.wide) &&
        !events.contains(EventType.wicket)) {
      logger.d("Adding $runs runs to striker ${striker.name}");
      logger.d("Striker previous runs: ${striker.batting!.runs}");
      striker.batting!.runs = striker.batting!.runs + runs;
      logger.d("Striker new runs: ${striker.batting!.runs}");

      logger.d("Partnership striker previous runs: ${_partnershipStriker.batting!.runs}");
      _partnershipStriker.batting!.runs = _partnershipStriker.batting!.runs + runs;
      logger.d("Partnership striker new runs: ${_partnershipStriker.batting!.runs}");
    }

    if (!events.contains(EventType.wide) &&
        !events.contains(EventType.noBall)) {
      logger.d("Incrementing ball count");
      _incrementBall();
      ball = currentBall;
      over = currentOver;
      logger.d("New ball: $ball, New over: $over");
    }

    if (!events.contains(EventType.bye) &&
        !events.contains(EventType.noBall) &&
        !events.contains(EventType.wide) &&
        !events.contains(EventType.legByes)) {
      logger.d("Incrementing balls faced for striker ${striker.name}");
      striker.batting!.balls = striker.batting!.balls + 1;
      _partnershipStriker.batting!.balls = _partnershipStriker.batting!.balls + 1;
    }

    if (events.contains(EventType.four)) {
      logger.d("Recording four for ${striker.name}");
      striker.batting!.fours = striker.batting!.fours + 1;
      _partnershipStriker.batting!.fours = _partnershipStriker.batting!.fours + 1;
    }

    if (events.contains(EventType.six)) {
      logger.d("Recording six for ${striker.name}");
      striker.batting!.sixes = striker.batting!.sixes + 1;
      _partnershipStriker.batting!.sixes = _partnershipStriker.batting!.sixes + 1;
    }

    if (events.contains(EventType.wicket)) {
      try {
        final res = await Get.bottomSheet(
            BottomSheet(
                backgroundColor: Colors.white,
                onClosing: () {
                },
                builder: (c) => const ChangeBatterWidget()),
            isDismissible: true,
            isScrollControlled: true,
            enableDrag: false);
        if (res != null) {
          logger.d("Wicket result: $res");
          wickets += 1;
          _updateSR();

          if (res['outType'] == "RO") {
            logger.d('Run out: Adding $runs runs to striker ${striker.name}');
            striker.batting!.runs = striker.batting!.runs + runs;
            _partnershipStriker.batting!.runs = _partnershipStriker.batting!.runs + runs;
          } else {
            logger.d('Not adding runs due to dismissal type: ${res['outType']}');
            shouldAddRuns = false;
          }

          if (res['playerToOut'] != null) {
            logger.d('Processing playerToOut: ${res['playerToOut']}');
            if (res['playerToOut'] == strikerId) {
              logger.d('Striker ${striker.name} is out');
              striker.batting!.bowledBy = controller.getBowlerName(bowlerId);
              striker.batting!.outType = res['outType'];
              setStriker = res['batsmanId'];
            } else {
              logger.d('Non-striker ${nonstriker.name} is out');
              nonstriker.batting!.bowledBy = controller.getBowlerName(bowlerId);
              nonstriker.batting!.outType = res['outType'];
              setNonStriker = res['batsmanId'];
            }
          } else {
            logger.d('Default out processing for striker ${striker.name}');
            striker.batting!.outType = res['outType'];
            striker.batting!.bowledBy = controller.getBowlerName(bowlerId);
            setStriker = res['batsmanId'];
          }

          logger.d('Updating partnership players');
          _partnershipStriker = PlayerModel(
            name: striker.name,
            id: strikerId,
            phoneNumber: striker.phoneNumber,
            role: striker.role,
          );
          _partnershipNonStriker = PlayerModel(
            name: nonstriker.name,
            id: nonStrikerId,
            phoneNumber: nonstriker.phoneNumber,
            role: nonstriker.role,
          );
        } else {
          logger.d("Wicket processing cancelled");
          if(events.contains(EventType.noBall)){
            logger.d("No Ball with wicket found ");
          } else{
            List<EventType> selectedEvent=events;

            controller.addEvent(EventType.dotBall);
            currentBall=currentBall-1;
            striker.batting!.balls = striker.batting!.balls -1;
          }
          return;
        }
      } catch (e) {
        logger.e("Error processing wicket: $e");
        return;
      }
    }

    if (events.contains(EventType.bye)) {
      logger.d("Adding $runs byes to extras");
      extras.byes += runs;
    }
    if (events.contains(EventType.legByes)) {
      logger.d("Adding $runs leg byes to extras");
      extras.legByes += runs;
    }

    if (events.contains(EventType.noBall) || events.contains(EventType.wide)) {
      if (events.contains(EventType.noBall)) {
        logger.d("Recording no ball");
        extras.noBalls += 1;
      } else {
        logger.d("Recording wide");
        extras.wides += 1;
      }

      if (events.contains(EventType.noBall) && events.contains(EventType.wide)) {
        logger.d("Removing wide from no ball delivery");
        events.remove(EventType.wide);
      }

      extraRuns += 1;
      logger.d("Adding extra run, new total extras: $extraRuns");

      currentInningsScore += runs + extraRuns;
      logger.d("New innings score after extras: $currentInningsScore");
      ballsToBowl += 1;

      getCurrentInnings.addAll({
        key: OverModel(
          over: over,
          ball: ball,
          run: runs,
          wickets: lastBall.wickets + wickets,
          extra: extraRuns,
          total: currentInningsScore,
          events: events,
        ),
      });
      logger.d("Updated over model for $key");
      bowler.bowling!.addRuns(runs, events: events);
    } else {
      if (shouldAddRuns) {
        logger.d("Adding $runs to innings score");
        currentInningsScore += runs;
      }

      ballsToBowl += 1;
      getCurrentInnings.addAll({
        key: OverModel(
          over: over,
          ball: ball,
          run: shouldAddRuns ? runs : 0,
          wickets: lastBall.wickets + wickets,
          extra: extraRuns,
          total: currentInningsScore,
          events: events,
        ),
      });
      logger.d("Updated over model for $key");
      bowler.bowling!.addRuns(shouldAddRuns ? runs : 0, events: events);
    }

    if (currentBall == 6) {
      logger.d("Over completed");
      overCompleted = true;
      if (runs % 2 == 0) {
        logger.d('Last ball of the over and even runs, changing strike');
        changeStrike();
      } else {
        logger.d('Last ball of the over and odd runs, no strike change needed');
      }
      currentBall = 0;
      currentOver += 1;
      ballsToBowl = 6;
    } else {
      if (runs % 2 != 0) {
        logger.d('Odd runs in middle of over, changing strike');
        changeStrike();
      } else {
        logger.d('Even runs in middle of over, no strike change needed');
      }
    }

    _updateSR();
    _updatePartnership();
    logger.d("=== Completed addRuns processing ===");
  }
  void _updateSR() {

    logger.d('Striker total Ball faced is :${striker.batting?.balls}');
    striker.batting!.strikeRate =
        (striker.batting!.runs / striker.batting!.balls) * 100;

    if (striker.batting!.strikeRate.isNaN ||
        striker.batting!.strikeRate.isInfinite) {
      striker.batting!.strikeRate = 0;
    }
    nonstriker.batting!.strikeRate =
        (nonstriker.batting!.runs / nonstriker.batting!.balls) * 100;
    if (nonstriker.batting!.strikeRate.isNaN) {
      nonstriker.batting!.strikeRate = 0;
    }
    logger.f('Updating second Innings');
    final Map<String, PartnershipModel> tempPartnerships =
    Map.from(partnerships);
    partnerships.clear();
    if (currentInnings == 1) {
      firstInnings = InningsModel(
        totalScore: currentInningsScore,
        battingTeam: team1,
        bowlingTeam: team2,
        ballRecord: getCurrentInnings,
        totalWickets: lastBall.wickets,
        overs: lastBall.over,
        balls: lastBall.ball,
        // TODO: Fix this

        openingStriker: team1.players![0],
        openingNonStriker: team1.players![1],
        openingBowler: team1.players![0],
        extras: extras,
        partnerships: tempPartnerships,
      );
    } else {
      secondInnings = InningsModel(
        totalScore: currentInningsScore,
        battingTeam: team2,
        bowlingTeam: team1,
        ballRecord: getCurrentInnings,
        totalWickets: lastBall.wickets,
        overs: lastBall.over,
        balls: lastBall.ball,
        // TODO: Fix this

        openingStriker: team1.players![0],
        openingNonStriker: team1.players![1],
        openingBowler: team1.players![0],
        extras: extras,
        partnerships: tempPartnerships,
      );
    }
  }

  void changeStrike() {
    final PlayerModel temp = striker;
    strikerId = nonStrikerId;
    nonStrikerId = temp.id;
    final PlayerModel temp2 = _partnershipStriker;
    _partnershipStriker = _partnershipNonStriker;
    _partnershipNonStriker = temp2;
  }

  void retirePlayer(String newPlayer, String retiredPlayerId) {
    if (retiredPlayerId == strikerId) {
      striker.batting!.outType = 'Retired';
      setStriker = newPlayer;
    }
    if (retiredPlayerId == nonStrikerId) {
      nonstriker.batting!.outType = 'Retired';
      setNonStriker = newPlayer;
    }
  }

  void endOfInnings({
    required PlayerModel strikerT,
    required PlayerModel nonstrikerT,
    required PlayerModel bowlerT,
  }) {
    try {
      // assign partnerships to a new variable and clear the partnerships
      final Map<String, PartnershipModel> tempPartnerships =
      Map.from(partnerships);
      partnerships.clear();
      if (currentInnings == 1) {
        firstInnings = InningsModel(
          totalScore: currentInningsScore,
          battingTeam: team1,
          bowlingTeam: team2,
          ballRecord: getCurrentInnings,
          totalWickets: lastBall.wickets,
          overs: lastBall.over,
          balls: lastBall.ball,
          isOver: true,
          openingStriker: team1.players![0],
          openingNonStriker: team1.players![1],
          openingBowler: team1.players![0],
          extras: extras,
          partnerships: tempPartnerships,
        );
        // partnerships.clear();
        currentInnings = 2;
        strikerId = strikerT.id;
        nonStrikerId = nonstrikerT.id;
        bowlerId = bowlerT.id;

        overCompleted = false;
        currentBall = 0;
        currentOver = 0;
        currentInningsScore = 0;
        ballsToBowl = 6;
        extras = ExtraModel(
          byes: 0,
          legByes: 0,
          noBalls: 0,
          penalty: 0,
          wides: 0,
        );
      }
      if (currentInnings == 2) {
        secondInnings = InningsModel(
          totalScore: currentInningsScore,
          battingTeam: team2,
          bowlingTeam: team1,
          totalWickets: lastBall.wickets,
          overs: lastBall.over,
          balls: lastBall.ball,
          ballRecord: getCurrentInnings,
          openingStriker: PlayerModel.fromJson(strikerT.toJson()),
          openingNonStriker: PlayerModel.fromJson(nonstrikerT.toJson()),
          openingBowler: PlayerModel.fromJson(bowler.toJson()),
          extras: extras,
          partnerships: partnerships,
        );
      }
    } catch (e) {
      logger.e(e);
    }
  }

  void changeBowler(String id) {
    // bowlerId = id;
    bowler.bowling!.currentBall = 0;
    bowlerId = id;
    overCompleted = false;
  }

  static String extractIdFromMap(Map<String, dynamic> value) {
    return value['\$oid'];
  }
}
