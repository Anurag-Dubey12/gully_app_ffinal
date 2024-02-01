import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/scoreboard_controller.dart';
import 'package:gully_app/data/model/bowling_model.dart';
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
  int currentOver = 0;
  int currentBall = 0;
  int currentInnings = 1;
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

  ScoreboardModel({
    required this.team1,
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

  List<OverModel?> get currentOverHistory {
    final List<OverModel?> temp = [];
    for (var i = 0; i < getCurrentInnings.length; i++) {
      final String key = '$currentOver.$i';
      // logger.i('Key: $key');
      if (getCurrentInnings.containsKey(key)) {
        // logger.i('Key: $key exists');
        temp.add(getCurrentInnings[key]!);
      } else {
        // logger.i('Key: $key does not exist');
        temp.add(null);
      }
    }
    return temp;
  }

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

  BowlingModel get bowler {
    if (currentInnings == 1) {
      return team2.players!
          .firstWhere((element) => element.id == bowlerId)
          .bowling!;
    } else {
      return team1.players!
          .firstWhere((element) => element.id == bowlerId)
          .bowling!;
    }
  }

  String get bowlerName {
    if (currentInnings == 1) {
      return team2.players!
          .firstWhere((element) => element.id == bowlerId)
          .name;
    } else {
      return team1.players!
          .firstWhere((element) => element.id == bowlerId)
          .name;
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

  Future<void> addRuns(int runs,
      {List<EventType>? events, List<EventType>? extraEvents}) async {
    events ??= [];
    int extraRuns = 0;
    int wickets = 0;
    String key = '$currentOver.${ballsToBowl - 6}';
    int ball = currentBall;
    int over = currentOver + 1;

    if (!events.contains(EventType.legByes) &&
        !events.contains(EventType.bye)) {
      striker.batting!.runs = striker.batting!.runs + runs;
      _partnershipStriker.batting!.runs =
          _partnershipStriker.batting!.runs + runs;
    }

    if (!events.contains(EventType.wide) &&
        !events.contains(EventType.noBall)) {
      _incrementBall();
      ball = currentBall;
      over = currentOver;
    }

    if (!events.contains(EventType.bye) &&
        !events.contains(EventType.noBall) &&
        !events.contains(EventType.wide) &&
        !events.contains(EventType.legByes)) {
      striker.batting!.balls = striker.batting!.balls + 1;
      _partnershipStriker.batting!.balls =
          _partnershipStriker.batting!.balls + 1;
    }
    if (events.contains(EventType.four)) {
      striker.batting!.fours = striker.batting!.fours + 1;
      _partnershipStriker.batting!.fours =
          _partnershipStriker.batting!.fours + 1;
    }
    if (events.contains(EventType.six)) {
      striker.batting!.sixes = striker.batting!.sixes + 1;
      _partnershipStriker.batting!.sixes =
          _partnershipStriker.batting!.sixes + 1;
    }
    if (events.contains(EventType.wicket)) {
      final res = await Get.bottomSheet(BottomSheet(
          backgroundColor: Colors.white,
          onClosing: () {},
          builder: (c) => const ChangeBatterWidget()));
      logger.i(res);

      wickets += 1;
      if (res['playerToOut'] != null) {
        if (res['playerToOut'] == strikerId) {
          setStriker = res['batsmanId'];
        } else {
          setNonStriker = res['batsmanId'];
        }
      }
      logger.i('Striker: $strikerId');
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
    }
    if (events.contains(EventType.bye)) {
      extras.byes += runs;
    }
    if (events.contains(EventType.legByes)) {
      extras.legByes += runs;
    }
    if (events.contains(EventType.noBall) || events.contains(EventType.wide)) {
      if (events.contains(EventType.noBall)) {
        extras.noBalls += 1;
      } else {
        extras.wides += 1;
      }

      if (events.contains(EventType.noBall) &&
          events.contains(EventType.wide)) {
        events.remove(EventType.wide);
      }

      extraRuns += 1;
      currentInningsScore += runs + extraRuns;
      ballsToBowl += 1;
      logger.d(key);
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
      bowler.addRuns(runs, events: events);
    } else {
      currentInningsScore += runs;
      logger.d(key);
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
      bowler.addRuns(runs, events: events);
    }

    logger.d(currentBall);

    if (currentBall == 6) {
      overCompleted = true;
      if (runs % 2 == 0) {
        logger.i('Last ball of the over and even runs, change strike');
        changeStrike();
      } else if (runs % 2 != 0) {
        logger.i('Last ball of the over and odd runs, no strike change');
      }
      currentBall = 0;
      currentOver += 1;
      ballsToBowl = 6;
    } else {
      if (runs % 2 != 0) {
        logger.i('Odd runs, change strike');
        changeStrike();
      } else {
        logger.i('Even runs, no strike change');
      }
    }
    _updateSR();
    _updatePartnership();
  }

  void _updateSR() {
    striker.batting!.strikeRate =
        (striker.batting!.runs / striker.batting!.balls) * 100;

    if (striker.batting!.strikeRate.isNaN) {
      striker.batting!.strikeRate = 0;
    }
    nonstriker.batting!.strikeRate =
        (nonstriker.batting!.runs / nonstriker.batting!.balls) * 100;
    if (nonstriker.batting!.strikeRate.isNaN) {
      nonstriker.batting!.strikeRate = 0;
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
    required PlayerModel striker,
    required PlayerModel nonstriker,
    required PlayerModel bowler,
  }) {
    try {
      if (currentInnings == 1) {
        firstInnings = InningsModel(
          totalScore: currentInningsScore,
          battingTeam: team1,
          bowlingTeam: team2,
          ballRecord: getCurrentInnings,
          openingStriker: PlayerModel.fromJson(striker.toJson()),
          openingNonStriker: PlayerModel.fromJson(nonstriker.toJson()),
          openingBowler: PlayerModel.fromJson(bowler.toJson()),
          extras: extras,
          partnerships: partnerships,
        );
        currentInnings = 2;
        strikerId = team2.players!.first.id;
        nonStrikerId = team2.players!.last.id;
        bowlerId = team1.players!.first.id;
        overCompleted = true;
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
          ballRecord: getCurrentInnings,
          openingStriker: PlayerModel.fromJson(striker.toJson()),
          openingNonStriker: PlayerModel.fromJson(nonstriker.toJson()),
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
    if (currentInnings == 1) {
      bowlerId = team2.players!.firstWhere((element) => element.id == id).id;
    } else {
      bowlerId = team1.players!.firstWhere((element) => element.id == id).id;
    }
    overCompleted = false;
  }

  static String extractIdFromMap(Map<String, dynamic> value) {
    return value['\$oid'];
  }
}
