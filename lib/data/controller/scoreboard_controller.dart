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

import '../model/matchup_model.dart';

class ScoreBoardController extends GetxController with StateMixin {
  final ScoreboardApi _scoreboardApi;
  final Rx<ScoreboardModel?> scoreboard = Rx<ScoreboardModel?>(null);
  bool isChallenge = false;
  MatchupModel? match;
  late ScoreboardModel _lastScoreboardInstance;
  Rx<io.Socket?> socket = Rx(null);

  RxList<EventType> events = RxList<EventType>([]);

  ScoreBoardController({required ScoreboardApi scoreboardApi})
      : _scoreboardApi = scoreboardApi;
  @override
  void onInit() {
    super.onInit();
  }
  void connectToSocket({bool hideDialog = false}) {
    try {
      logger.d('connectToSocket ${AppConstants.websocketUrl}');
      socket.value = io.io(AppConstants.websocketUrl, <String, dynamic>{
        'transports': ['websocket'],
      });
      logger.d('socket $socket');
      socket.value?.onConnectError((data) => logger.e(data));
      socket.value!.on('scoreboard', (data) {
        logger.i('Scoreboard updated to channel ');
        // showDrawPopup();
        if (hideDialog == false) {
          showPopups();
        }
        if (data != null) {
          if (data['scoreBoard'] != null) {
            scoreboard.value = ScoreboardModel.fromJson(data['scoreBoard']);
          }
          logger.f('Innings ${scoreboard.value?.lastBall.run}');
          scoreboard.refresh();
        }
      });
      socket.value?.onConnect((_) {
        logger.d('connect ${scoreboard.value?.matchId}');
        // check if match is drawn
        // showDrawPopup();
        if (hideDialog == false) {
          showPopups();
        }
        socket.value?.emit('joinRoom', {
          'matchId': scoreboard.value?.matchId,
        });
      });
      socket.value!.connect();
      socket.value?.onDisconnect((_) {
        logger.d('disconnect');
        scoreboard.value = null;
        scoreboard.refresh();
      });
    } catch (e) {
      logger.e(e);
    }
  }

  showPopups() {
    if (scoreboard.value?.isSecondInningsOver ?? false) {
      final firstInning = scoreboard.value?.firstInnings!.totalScore;
      final secondInning = scoreboard.value?.secondInnings!.totalScore;
      if (firstInning! > secondInning!) {
        successSnackBar('Team ${scoreboard.value?.team1.name} Won the Match');
      }
      if (firstInning < secondInning) {
        successSnackBar('Team ${scoreboard.value?.team2.name} Won the Match');
      }
      if (firstInning == secondInning) {
        errorSnackBar('The Match is Drawn');
      }
    } else if (scoreboard.value?.isFirstInningsOver ?? false) {
      successSnackBar(
          'First Innings has been completed you can start 2nd inning');
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
  // In ScoreBoardController
  // Future<MatchupModel?> getMatchById(String matchId) async {
  //   try {
  //     final response = await _scoreboardApi.getSingleMatchup(matchId);
  //     return MatchupModel.fromJson(response.data!['match']);
  //   } catch (e) {
  //     logger.e('ScoreboardController::getMatchById $e');
  //     return null;
  //   }
  // }

  void createScoreBoard({
    required TeamModel team1,
    required TeamModel team2,
    required String strikerId,
    required String nonStrikerId,
    required String openingBowler,
    required String matchId,
    required String tossWonBy,
    required String electedTo,
    required int overs,
    required ExtraModel extras,
    bool shouldUpdate = true,
  }) {
    // Create sample ScoreboardModel
    logger.f("isChallenge $isChallenge");
    logger.f("matchID ${match?.id}");

    scoreboard.value = ScoreboardModel(
        team1: team1,
        team2: team2,
        currentInnings: 1,
        overCompleted: false,
        matchId: match!.id,
        tossWonBy: tossWonBy,
        electedTo: electedTo,
        totalOvers: overs,
        strikerId: strikerId,
        extras: extras,
        isChallenge: isChallenge,
        nonStrikerId: nonStrikerId,
        bowlerId: openingBowler,
        firstInningHistory: {},
        secondInningHistory: {},
        partnerships: {});
    // logger.i(scoreboard.value!.toJson());
    _lastScoreboardInstance = scoreboard.value!;
    if (shouldUpdate && !isChallenge) {
      _scoreboardApi.updateScoreBoard(scoreboard.value!.toJson());
    } else {
      _scoreboardApi.updateChallengeScoreBoard(scoreboard.value!.toJson());
    }
  }
  String getPlayerName(String? playerId) {
    if (playerId == null) return '';

    PlayerModel? player = match?.team1.players?.firstWhere(
            (p) => p.id == playerId,
        orElse: () => match?.team2.players?.firstWhere(
                (p) => p.id == playerId,
            orElse: () => PlayerModel(name: 'Unknown', id: 'unknown', phoneNumber: 'unknown', role: 'unknown')
        ) ?? PlayerModel(name: 'Unknown', id: 'unknown', phoneNumber: 'unknown', role: 'unknown')
    );

    return player?.name ?? 'Unknown';
  }

  void setScoreBoard(ScoreboardModel scoreBoard) {
    scoreboard.value = scoreBoard;
    _lastScoreboardInstance = scoreboard.value!;
  }

  String getBowlerName(String bowlerId) {
    if (scoreboard.value == null) {
      return 'Unknown';
    }
    TeamModel bowlingTeam = scoreboard.value!.currentInnings == 1
        ? scoreboard.value!.team2
        : scoreboard.value!.team1;

    PlayerModel? bowler = bowlingTeam.players?.firstWhere(
            (player) => player.id == bowlerId,
        orElse: () => PlayerModel(
            name: 'Unknown',
            id: 'unknown_id',
            phoneNumber: 'unknown',
            role: 'unknown'
        )
    );
    return bowler!.name;
  }


  Future<bool> addEvent(EventType type,
      {String? bowlerId,
      String? strikerId,
      String? selectedBatsmanId,
      String? playerToRetire,
      PlayerModel? striker,
      PlayerModel? nonStriker,
      PlayerModel? bowler,
      int? runs}) async {
    if (scoreboard.value?.isAllOut ?? false) {
      if (scoreboard.value?.currentInnings == 1) {
        // opps all out start 2nd inning
        errorSnackBar('Oops! All out. Start 2nd Innings');
        return false;
      }
      errorSnackBar('Oops! All out. Match Over');
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
      errorSnackBar(
          'First Innings has been completed you can start 2nd Innings');

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
      case EventType.five:
        await scoreboard.value!.addRuns(5, events: events.value);

        break;
      case EventType.custom:
        await scoreboard.value!.addRuns(runs!, events: events.value);

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
    if (scoreboard.value!.isSecondInningsOver &&
        !scoreboard.value!.isChallenge!) {
      updateFinalScoreBoard(scoreboard.value!.getWinningTeam);
    } else if (scoreboard.value!.isSecondInningsOver &&
        scoreboard.value!.isChallenge!) {
      updateFinalChallengeScoreBoard(scoreboard.value!.getWinningTeam);
    }
    if (scoreboard.value!.isChallenge!) {
      _scoreboardApi.updateChallengeScoreBoard(scoreboard.value!.toJson());
    } else {
      _scoreboardApi.updateScoreBoard(scoreboard.value!.toJson());
    }
    events.value = [];
    events.refresh();
    scoreboard.refresh();
    emitEvent();
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

  // void checkLastBall() {
  //   if (scoreboard.value!.currentBall == 0 &&
  //       scoreboard.value!.currentOver != 0 ) {
  //     scoreboard.value!.overCompleted = true;
  //     showModalBottomSheet(
  //         context: Get.context!,
  //         builder: (c) => const ChangeBowlerWidget(),
  //         enableDrag: true,
  //         isDismissible: true);
  //   }
  // }

  void checkLastBall() {
    if (scoreboard.value!.currentBall == 6 ||
        (scoreboard.value!.currentBall == 0 && scoreboard.value!.currentOver != 0)) {
      scoreboard.value!.overCompleted = true;
      scoreboard.value!.currentBall = 0;
      if (scoreboard.value!.currentOver == scoreboard.value!.currentOver) {
        scoreboard.value!.currentOver++;
      }
      showModalBottomSheet(
          context: Get.context!,
          builder: (c) => const ChangeBowlerWidget(),
          enableDrag: true,
          isDismissible: true
      );
    }
  }
  // void checkLastBall() {
  //   if (scoreboard.value!.currentBall == 6) {
  //     scoreboard.value!.overCompleted = true;
  //     scoreboard.value!.currentBall = 0;
  //     scoreboard.value!.currentOver++;
  //     showModalBottomSheet(
  //         context: Get.context!,
  //         builder: (c) => const ChangeBowlerWidget(),
  //         enableDrag: true,
  //         isDismissible: true
  //     );
  //   }
  // }

  void addEventType(EventType type) {
    if (type == EventType.noBall && events.value.contains(EventType.wide)) {
      events.value.remove(EventType.wide);
    }
    if (type == EventType.wide && events.value.contains(EventType.noBall)) {
      events.value.remove(EventType.noBall);
    }
    if (type == EventType.wide && events.value.contains(EventType.legByes)) {
      events.value.remove(EventType.legByes);
    }
    // same for legByes and byes
    if (type == EventType.legByes && events.value.contains(EventType.bye)) {
      events.value.remove(EventType.bye);
    }
    if (type == EventType.legByes && events.value.contains(EventType.wide)) {
      events.value.remove(EventType.wide);
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

  void updateFinalChallengeScoreBoard(String winningTeamId) {
    _scoreboardApi.updateFinalChallengeScoreBoard(
        scoreboard.value!.matchId, winningTeamId);
  }

}

enum EventType {
  one,
  two,
  three,
  four,
  five,
  six,
  custom,
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
