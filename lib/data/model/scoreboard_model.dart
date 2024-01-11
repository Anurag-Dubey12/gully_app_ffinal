import 'package:gully_app/data/controller/scoreboard_controller.dart';
import 'package:gully_app/data/model/bowling_model.dart';
import 'package:gully_app/data/model/extras_model.dart';
import 'package:gully_app/data/model/overs_model.dart';
import 'package:gully_app/data/model/partnership_model.dart';
import 'package:gully_app/data/model/player_model.dart';
import 'package:gully_app/data/model/team_model.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:json_annotation/json_annotation.dart';

part 'scoreboard_model.g.dart';

@JsonSerializable(explicitToJson: true, createPerFieldToJson: true)
class ScoreboardModel {
  final TeamModel team1;
  final TeamModel team2;
  @JsonKey(
    includeToJson: true,
  )
  final Map<String, PartnershipModel> partnerships = {};
  final String matchId;
  List<String> lastOvers = [];
  @JsonKey(
    includeToJson: true,
    name: 'extras',
  )
  final ExtraModel _extras =
      ExtraModel(wides: 0, noBalls: 0, byes: 0, legByes: 0, penalty: 0);
  int ballsToBowl = 6;
  int currentOver = 0;
  int currentBall = 0;
  int currentInnings = 0;
  int currentInningsScore = 0;
  int currentInningsWickets = 0;
  EventType? lastEventType;
  late String _bowlerId;
  late String _strikerId;
  late String _nonStrikerId;
  Map<String, OverModel> overHistory = {};

  ScoreboardModel({
    required this.team1,
    required this.team2,
    required this.matchId,
  }) {
    logger.i('ScoreboardModel: ');
    _strikerId = team1.players!.first.id;
    _nonStrikerId = team1.players!.last.id;
    _bowlerId = team2.players!.first.id;
    final key = [striker.id, nonstriker.id];
    key.sort();
    partnerships.addAll({
      partnershipKey: PartnershipModel(
          player1: team1.players!.first, player2: team1.players!.last)
    });
    logger.i('ScoreboardModel: ${toJson()}');
  }
  String get partnershipKey {
    final List<String> key = [_strikerId, _nonStrikerId];
    key.sort();
    return key.join();
  }

  factory ScoreboardModel.fromJson(Map<String, dynamic> json) =>
      _$ScoreboardModelFromJson(json);
  Map<String, dynamic> toJson() => _$ScoreboardModelToJson(this);

  List<OverModel?> get currentOverHistory {
    final List<OverModel?> temp = [];
    for (var i = 0; i < 6; i++) {
      final String key = '$currentOver.$i';
      logger.i('Key: $key');
      if (overHistory.containsKey(key)) {
        logger.i('Key: $key exists');
        temp.add(overHistory[key]!);
      } else {
        logger.i('Key: $key does not exist');
        temp.add(null);
      }
    }
    return temp;
  }

  PlayerModel get striker {
    if (currentInnings == 1) {
      return team1.players!.firstWhere((element) => element.id == _strikerId);
    } else {
      return team2.players!.firstWhere((element) => element.id == _strikerId);
    }
  }

  PlayerModel get nonstriker {
    if (currentInnings == 1) {
      return team1.players!
          .firstWhere((element) => element.id == _nonStrikerId);
    } else {
      return team2.players!
          .firstWhere((element) => element.id == _nonStrikerId);
    }
  }

  BowlingModel get bowler {
    if (currentInnings == 1) {
      return team2.players!
          .firstWhere((element) => element.id == _bowlerId)
          .bowling!;
    } else {
      return team1.players!
          .firstWhere((element) => element.id == _bowlerId)
          .bowling!;
    }
  }

  String get bowlerName {
    if (currentInnings == 1) {
      return team2.players!
          .firstWhere((element) => element.id == _bowlerId)
          .name;
    } else {
      return team1.players!
          .firstWhere((element) => element.id == _bowlerId)
          .name;
    }
  }

  ExtraModel get currentExtras {
    return _extras;
  }

  double get currentRunRate {
    if (currentInningsScore == 0) {
      return 0;
    }
    return (currentInningsScore / currentOver);
  }

  OverModel get lastBall {
    if (overHistory.values.isEmpty) {
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
    return overHistory.values.last;
  }

  void _incrementBall() {
    currentBall++;
  }

  void _updatePartnership() {
    partnerships[partnershipKey] =
        PartnershipModel(player1: striker, player2: nonstriker);
  }

  void addRuns(int runs, {List<EventType>? events}) {
    events ??= [];
    int extraRuns = 0;
    String key = '$currentOver.${ballsToBowl - 6}';
    int ball = currentBall;
    int over = currentOver + 1;
    if (!events.contains(EventType.legByes) &&
        !events.contains(EventType.bye)) {
      striker.batting!.runs = striker.batting!.runs + runs;
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
    }
    if (events.contains(EventType.four)) {
      striker.batting!.fours = striker.batting!.fours + 1;
    }
    if (events.contains(EventType.six)) {
      striker.batting!.sixes = striker.batting!.sixes + 1;
    }
    if (events.contains(EventType.noBall) || events.contains(EventType.wide)) {
      if (events.contains(EventType.noBall)) {
        _extras.noBalls += 1;
      } else {
        _extras.wides += 1;
      }
      extraRuns += 1;
      currentInningsScore += runs + extraRuns;
      ballsToBowl += 1;
      logger.d(key);
      overHistory.addAll({
        key: OverModel(
          over: over,
          ball: ball,
          run: runs,
          wickets: 0,
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
      overHistory.addAll({
        key: OverModel(
          over: over,
          ball: ball,
          run: runs,
          wickets: 0,
          extra: extraRuns,
          total: currentInningsScore,
          events: events,
        ),
      });
      bowler.addRuns(runs, events: events);
    }
    if (runs % 2 != 0) {
      logger.i('Odd runs, change strike');
      changeStrike();
    } else {
      logger.i('Even runs, no strike change');
    }
    if (currentBall == 0 && currentOver != 0) {
      if (runs % 2 == 0) {
        logger.i('Last ball of the over and even runs, change strike');
        changeStrike();
      } else if (runs % 2 != 0) {
        logger.i('Last ball of the over and odd runs, no strike change');
      }
      return;
    }

    if (currentBall == 6) {
      currentBall = 0;
      currentOver += 1;
      ballsToBowl = 6;
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
    _strikerId = _nonStrikerId;
    _nonStrikerId = temp.id;
  }

  void changeBowler(String id) {
    if (currentInnings == 1) {
      _bowlerId = team2.players!.firstWhere((element) => element.id == id).id;
    } else {
      _bowlerId = team1.players!.firstWhere((element) => element.id == id).id;
    }
  }

  void _decrementBall() {
    currentBall--;
    // handle case when currentBall goes to -1 and currentOver is not 0
    if (currentBall == -1 && currentOver > 0) {
      currentBall = 5;
      currentOver -= 1;
    }

// handle case when currentBall goes to -1 and currentOver is 0
    if (currentBall == -1 && currentOver == 0) {
      currentBall = 0;
    }
  }

  void decrementRuns(int runs) {
    if (runs % 2 == 0 && currentBall == 0) {
      logger.i('Undo: Last ball of the over and even runs, change strike');
      changeStrike();
    }
    if (runs % 2 != 0) {
      logger.i('Undo: Last ball of the over and odd runs, no strike change');
      changeStrike();
    }
    if (striker.batting!.runs < runs) {
      return;
    }

    striker.batting!.runs = striker.batting!.runs - runs;
    currentInningsScore -= runs;
  }

  void undoLastEvent() {
    if (lastEventType == null) {
      return;
    }
    final EventType event = lastEventType!;
    switch (event) {
      case EventType.four:
        if (striker.batting!.fours < 0) {
          striker.batting!.fours = 0;
        }
        striker.batting!.fours = striker.batting!.fours - 1;
        decrementRuns(4);
        if (currentBall == 0) {
          changeStrike();
        }
        break;
      case EventType.six:
        if (currentBall == 0) {
          changeStrike();
        }
        striker.batting!.sixes = striker.batting!.sixes - 1;
        if (striker.batting!.sixes < 0) {
          striker.batting!.sixes = 0;
        }
        decrementRuns(6);
        break;
      case EventType.one:
        decrementRuns(1);
        break;
      case EventType.two:
        decrementRuns(2);
        break;
      case EventType.three:
        decrementRuns(3);
        break;
      case EventType.wide:
        currentInningsScore -= 1;
        if (currentInningsScore < 0) {
          currentInningsScore = 0;
        }

        break;
      case EventType.noBall:
        currentInningsScore -= 1;
        if (currentInningsScore < 0) {
          currentInningsScore = 0;
        }
        break;
      case EventType.wicket:
        currentInningsWickets -= 1;
        if (currentInningsWickets < 0) {
          currentInningsWickets = 0;
        }

        break;
      case EventType.dotBall:
        _decrementBall();

        break;
      case EventType.changeBowler:
        break;
      case EventType.changeStriker:
        final PlayerModel temp = striker;
        _strikerId = _nonStrikerId;
        _nonStrikerId = temp.id;
        break;
      default:
        break;
    }
    lastOvers.removeLast();
    lastEventType = null;
    _decrementBall();
  }
}
