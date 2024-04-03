import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/config/app_constants.dart';
import 'package:gully_app/data/api/score_board_api.dart';
import 'package:gully_app/data/model/extras_model.dart';
import 'package:gully_app/data/model/player_model.dart';
import 'package:gully_app/data/model/scoreboard_model.dart';
import 'package:gully_app/data/model/team_model.dart';
import 'package:gully_app/ui/widgets/scorecard/change_bowler.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ScoreBoardController extends GetxController with StateMixin {
  final ScoreboardApi _scoreboardApi;
  final Rx<ScoreboardModel?> scoreboard = Rx<ScoreboardModel?>(null);

  late ScoreboardModel _lastScoreboardInstance;
  Rx<io.Socket?> socket = Rx(null);

  RxList<EventType> events = RxList<EventType>([]);

  ScoreBoardController({required ScoreboardApi scoreboardApi})
      : _scoreboardApi = scoreboardApi;
  @override
  void onInit() {
    super.onInit();
  }

  void connectToSocket() {
    try {
      logger.d('connectToSocket ${AppConstants.websocketUrl}');
      socket.value = io.io(AppConstants.websocketUrl, <String, dynamic>{
        'transports': ['websocket'],
      });
      logger.d('socket $socket');
      socket.value?.onConnectError((data) => logger.e(data));
      socket.value!.on('scoreboard', (data) {
        logger.i('Scoreboard updated to channel $data');
        if (data != null) {
          logger.f('41');
          scoreboard.value = ScoreboardModel.fromJson(data['scoreBoard']);
          logger.f('Innings ${scoreboard.value?.lastBall.run}');
          scoreboard.refresh();
        }
      });
      socket.value?.onConnect((_) {
        logger.d('connect ${scoreboard.value?.matchId}');
        socket.value?.emit('joinRoom', {
          'matchId': scoreboard.value?.matchId,
        });
      });
      socket.value!.connect();
      socket.value?.onDisconnect((_) => logger.i('disconnect'));
    } catch (e) {
      logger.e(e);
    }
  }

  void emitEvent() {
    logger.i('Emiting Message');
    socket.value?.emit('scoreboard', {
      'scoreBoard': scoreboard.toJson(),
      'matchId': scoreboard.value!.matchId
    });
  }

  void disconnect() {
    socket.value?.disconnect();
    socket.value?.destroy();
    socket.value?.dispose();

    socket.refresh();
  }

  Future<ScoreboardModel?> getMatchScoreboard(String matchId) async {
    final response = await _scoreboardApi.getSingleMatchup(matchId);
    try {
      return ScoreboardModel.fromJson(response.data!['match']['scoreBoard']);
    } catch (e) {
      logger.e('ScoreboardController::getMatchScoreboard $e');
      return null;
    }
  }

  void createScoreBoard(
      {required TeamModel team1,
      required TeamModel team2,
      required String strikerId,
      required String nonStrikerId,
      required String openingBowler,
      required String matchId,
      required String tossWonBy,
      required String electedTo,
      required int overs,
      required ExtraModel extras,
      bool shouldUpdate = true}) {
    // Create sample ScoreboardModel

    scoreboard.value = ScoreboardModel(
        team1: team1,
        team2: team2,
        currentInnings: 1,
        overCompleted: false,
        matchId: matchId,
        tossWonBy: tossWonBy,
        electedTo: electedTo,
        totalOvers: overs,
        strikerId: strikerId,
        extras: extras,
        nonStrikerId: nonStrikerId,
        bowlerId: openingBowler,
        firstInningHistory: {},
        secondInningHistory: {},
        partnerships: {});
    // logger.i(scoreboard.value!.toJson());
    _lastScoreboardInstance = scoreboard.value!;
    if (shouldUpdate) {
      _scoreboardApi.updateScoreBoard(scoreboard.value!.toJson());
    }
  }

  void setScoreBoard(ScoreboardModel scoreBoard) {
    scoreboard.value = scoreBoard;
    _lastScoreboardInstance = scoreboard.value!;
  }

  Future<bool> addEvent(
    EventType type, {
    String? bowlerId,
    String? strikerId,
    String? selectedBatsmanId,
    String? playerToRetire,
    PlayerModel? striker,
    PlayerModel? nonStriker,
    PlayerModel? bowler,
  }) async {
    if (scoreboard.value?.isAllOut ?? false) {
      errorSnackBar('All out');
      return false;
    }
    if (scoreboard.value?.isSecondInningsOver ?? false) {
      errorSnackBar('Match Over');
      return false;
    }
    if ((scoreboard.value?.overCompleted ?? true) &&
        type != EventType.changeBowler) {
      errorSnackBar('Please select a bowler');
      return false;
    }
    if (scoreboard.value?.inningsCompleted ?? false) {
      errorSnackBar('Innings Completed');

      return false;
    }

    _lastScoreboardInstance =
        ScoreboardModel.fromJson(scoreboard.value!.toJson());

    switch (type) {
      case EventType.four:
        await scoreboard.value!.addRuns(
          4,
          events: [...events.value, EventType.four],
        );

        break;
      case EventType.six:
        await scoreboard.value!
            .addRuns(6, events: [...events.value, EventType.six]);

        break;
      case EventType.one:
        await scoreboard.value!.addRuns(1, events: events.value);

        break;
      case EventType.two:
        await scoreboard.value!.addRuns(2, events: events.value);

        break;
      case EventType.three:
        await scoreboard.value!.addRuns(3, events: events.value);

        break;

      case EventType.wicket:
        // scoreboard.value!.addWicket();
        break;
      case EventType.dotBall:
        await scoreboard.value!.addRuns(0, events: events.value);

        break;
      case EventType.changeBowler:
        logger.i('changeBowler $bowlerId');
        // if (scoreboard.value?.currentOverHistory.last == null) {
        //   undoLastEvent();
        // }
        logger.i('changeBowler $bowlerId');
        scoreboard.value!.changeBowler(bowlerId!);

        break;
      case EventType.changeStriker:
        scoreboard.value!.changeStrike();
        break;
      case EventType.retire:
        scoreboard.value!.retirePlayer(selectedBatsmanId!, playerToRetire!);
      case EventType.eoi:
        scoreboard.value!.endOfInnings(
          strikerT: striker!,
          nonstrikerT: nonStriker!,
          bowlerT: bowler!,
        );

        break;
      case EventType.bye:
        break;
      default:
    }
    if (scoreboard.value!.isSecondInningsOver) {
      updateFinalScoreBoard(scoreboard.value!.getWinningTeam);
    }
    _scoreboardApi.updateScoreBoard(scoreboard.value!.toJson());
    events.value = [];
    events.refresh();
    emitEvent();
    scoreboard.refresh();
    return true;
  }

  void endOfInnings(
      {required PlayerModel striker,
      required PlayerModel nonStriker,
      required PlayerModel bowler}) {
    scoreboard.value!.endOfInnings(
      strikerT: striker,
      nonstrikerT: nonStriker,
      bowlerT: bowler,
    );
    _scoreboardApi.updateScoreBoard(scoreboard.value!.toJson());
    emitEvent();
    scoreboard.refresh();
  }

  void undoLastEvent() {
    logger.i('undoLastEvent ${_lastScoreboardInstance.lastBall.toJson()}');
    scoreboard.value = _lastScoreboardInstance;
    scoreboard.refresh();
  }

  void checkLastBall() {
    if (scoreboard.value!.currentBall == 0 &&
        scoreboard.value!.currentOver != 0) {
      scoreboard.value!.overCompleted = true;
      showModalBottomSheet(
          context: Get.context!,
          builder: (c) => const ChangeBowlerWidget(),
          enableDrag: true,
          isDismissible: true);
    }
  }

  void addEventType(EventType type) {
    // if events contains wide ball and new event is no ball then remove wide ball
    if (type == EventType.noBall && events.value.contains(EventType.wide)) {
      events.value.remove(EventType.wide);
    }
    if (type == EventType.wide && events.value.contains(EventType.noBall)) {
      events.value.remove(EventType.noBall);
    }
    // same for legByes and byes
    if (type == EventType.legByes && events.value.contains(EventType.bye)) {
      events.value.remove(EventType.bye);
    }
    if (type == EventType.bye && events.value.contains(EventType.legByes)) {
      events.value.remove(EventType.legByes);
    }
    events.value.add(type);
    events.refresh();
  }

  void removeEventType(EventType type) {
    events.value.remove(type);
    events.refresh();
  }

  void updateFinalScoreBoard(String winningTeamId) {
    _scoreboardApi.updateFinalScoreBoard(
        scoreboard.value!.matchId, winningTeamId);
  }
}

enum EventType {
  one,
  two,
  three,
  four,
  six,
  wide,
  noBall,
  wicket,
  dotBall,
  changeBowler,
  changeStriker,
  legByes,
  bye,
  retire,
  eoi
}
