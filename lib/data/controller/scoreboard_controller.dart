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
      socket.value!.on('scoreboard', (data) => {logger.e('NEW DATA $data')});
      socket.value?.onConnect((_) {
        logger.d('connect');
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

  Future<ScoreboardModel> getMatchScoreboard(String matchId) async {
    final response = await _scoreboardApi.getSingleMatchup(matchId);
    try {
      return ScoreboardModel.fromJson(response.data!['match']['scoreBoard']);
    } catch (e) {
      logger.e(e);
      throw Exception('Unable to fetch Scoreboard');
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
      required ExtraModel extras}) {
    // Create sample ScoreboardModel

    scoreboard.value = ScoreboardModel(
        team1: team1,
        team2: team2,
        overCompleted: true,
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

    _scoreboardApi.updateScoreBoard(scoreboard.value!.toJson());
  }

  void setScoreBoard(ScoreboardModel scoreBoard) {
    scoreboard.value = scoreBoard;
    _lastScoreboardInstance = scoreboard.value!;
  }

  void addEvent(
    EventType type, {
    String? bowlerId,
    String? strikerId,
    String? selectedBatsmanId,
    String? playerToRetire,
    PlayerModel? striker,
    PlayerModel? nonStriker,
    PlayerModel? bowler,
  }) async {
    if ((scoreboard.value?.overCompleted ?? true) &&
        type != EventType.changeBowler) {
      errorSnackBar('Please select a bowler');
      return;
    }
    if (scoreboard.value?.currentOver == scoreboard.value?.totalOvers &&
        type != EventType.changeBowler) {
      errorSnackBar('Match Overs Completed');
      return;
    }
    logger.i('addEvent $type');
    _lastScoreboardInstance =
        ScoreboardModel.fromJson(scoreboard.value!.toJson());

    switch (type) {
      case EventType.four:
        await scoreboard.value!
            .addRuns(4, events: [...events.value, EventType.four]);

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
        logger.i(bowlerId!);
        scoreboard.value!.changeBowler(bowlerId);

        // changeBowler();
        break;
      case EventType.changeStriker:
        scoreboard.value!.changeStrike();
        break;
      case EventType.retire:
        scoreboard.value!.retirePlayer(selectedBatsmanId!, playerToRetire!);
      case EventType.eoi:
        scoreboard.value!.endOfInnings(
          striker: striker!,
          nonstriker: nonStriker!,
          bowler: bowler!,
        );

        break;
      case EventType.bye:
        break;
      default:
    }
    _scoreboardApi.updateScoreBoard(scoreboard.value!.toJson());
    events.value = [];
    events.refresh();
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
    events.value.add(type);
    events.refresh();
  }

  void removeEventType(EventType type) {
    events.value.remove(type);
    events.refresh();
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
