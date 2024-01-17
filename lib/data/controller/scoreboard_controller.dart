import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/config/app_constants.dart';
import 'package:gully_app/data/api/score_board_api.dart';
import 'package:gully_app/data/model/scoreboard_model.dart';
import 'package:gully_app/data/model/team_model.dart';
import 'package:gully_app/utils/app_logger.dart';
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

      socket.value?.onConnect((_) {
        logger.d('connect');
        socket.value?.emit('joinMatch', {
          'matchId': '12345',
        });
      });
      socket.value?.onDisconnect((_) => logger.i('disconnect'));
    } catch (e) {
      logger.e(e);
    }
  }

  void emitEvent() {
    logger.i('Emiting Message');
    socket.value?.emit(
        'sendMessage', {'message': scoreboard.toJson(), 'matchId': '12345'});
  }

  void disconnect() {
    socket.value?.disconnect();
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
      required int overs}) {
    // Create sample ScoreboardModel
    scoreboard.value = ScoreboardModel(
      team1: team1,
      team2: team2,
      matchId: matchId,
      tossWonBy: tossWonBy,
      electedTo: electedTo,
      totalOvers: overs,
      strikerId: strikerId,
      nonStrikerId: nonStrikerId,
      bowlerId: openingBowler,
      firstInningHistory: {},
      secondInningHistory: {},
    );
    // logger.i(scoreboard.value!.toJson());
    _lastScoreboardInstance = scoreboard.value!;

    _scoreboardApi.updateScoreBoard(scoreboard.value!.toJson());
  }

  void setScoreBoard(ScoreboardModel scoreBoard) {
    scoreboard.value = scoreBoard;
    _lastScoreboardInstance = scoreboard.value!;
  }

  void addEvent(EventType type, {String? bowlerId, String? strikerId}) {
    _lastScoreboardInstance =
        ScoreboardModel.fromJson(scoreboard.value!.toJson());

    switch (type) {
      case EventType.four:
        scoreboard.value!.addRuns(4, events: [...events, EventType.four]);
        checkLastBall();

        break;
      case EventType.six:
        scoreboard.value!.addRuns(6, events: [EventType.six]);
        checkLastBall();
        break;
      case EventType.one:
        scoreboard.value!.addRuns(1, events: [...events]);
        checkLastBall();
        break;
      case EventType.two:
        scoreboard.value!.addRuns(2, events: [...events]);

        checkLastBall();
        break;
      case EventType.three:
        scoreboard.value!.addRuns(3, events: [...events]);
        checkLastBall();
        break;
      case EventType.wide:
        scoreboard.value!.addRuns(1, events: [...events, EventType.wide]);
        break;
      case EventType.noBall:
        scoreboard.value!.addRuns(1, events: [...events, EventType.noBall]);

        break;
      case EventType.wicket:
        // addWicket();
        break;
      case EventType.dotBall:
        scoreboard.value!.addRuns(0, events: [...events, EventType.dotBall]);
        checkLastBall();

        break;
      case EventType.changeBowler:
        logger.i(bowlerId!);
        scoreboard.value!.changeBowler(bowlerId);
        // changeBowler();
        break;
      case EventType.changeStriker:
        scoreboard.value!.changeStrike();
        break;
      case EventType.legByes:

        // addLegByes();
        break;
      case EventType.bye:
        // addByes();
        break;
    }
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
      _scoreboardApi.updateScoreBoard(scoreboard.value!.toJson());
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

class ChangeBowlerWidget extends GetView<ScoreBoardController> {
  const ChangeBowlerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final players = [];
    if (controller.scoreboard.value!.currentInnings == 1) {
      players.addAll(controller.scoreboard.value!.team2.players!);
    } else {
      players.addAll(controller.scoreboard.value!.team1.players!);
    }
    return SizedBox(
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Change Bowler',
                style: Get.textTheme.headlineMedium,
              ),
              SizedBox(
                height: Get.height * 0.5,
                child: ListView.builder(
                  itemCount: players.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(players[index].name),
                    onTap: () {
                      controller.addEvent(EventType.changeBowler,
                          bowlerId: players[index].id);
                      Navigator.pop(context);
                    },
                    subtitle: const Row(
                      children: [
                        BowlerStat(),
                        BowlerStat(),
                        BowlerStat(),
                        BowlerStat(),
                        BowlerStat(),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BowlerStat extends StatelessWidget {
  const BowlerStat({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text('O:',
              style:
                  TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          Text('1'),
        ],
      ),
    );
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
}
