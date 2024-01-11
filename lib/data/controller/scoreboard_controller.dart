import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/player_model.dart';
import 'package:gully_app/data/model/scoreboard_model.dart';
import 'package:gully_app/data/model/team_model.dart';
import 'package:gully_app/utils/app_logger.dart';

class ScoreBoardController extends GetxController {
  final Rx<ScoreboardModel?> scoreboard = Rx<ScoreboardModel?>(null);
  RxList<EventType> events = RxList<EventType>([]);
  @override
  void onInit() {
    super.onInit();
    createScoreBoard();
  }

  void createScoreBoard() {
    final TeamModel team1 = TeamModel(
      11,
      name: 'Team A',
      logo: 'team_a_logo.png',
      id: 'team_a',
      players: generatePlayers(),
    );

    final TeamModel team2 = TeamModel(
      11,
      name: 'Team B',
      logo: 'team_b_logo.png',
      id: 'team_b',
      players: generatePlayers(),
    );

    // Create sample ScoreboardModel
    scoreboard.value = ScoreboardModel(
      team1: team1,
      team2: team2,
      matchId: '12345',
    );
    logger.i(scoreboard.value!.toJson());
  }

  void addEvent(EventType type, {String? bowlerId, String? strikerId}) {
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
    scoreboard.refresh();
  }

  void undoLastEvent() {
    scoreboard.value!.undoLastEvent();
    scoreboard.refresh();
  }

  void checkLastBall() {
    if (scoreboard.value!.currentBall == 0 &&
        scoreboard.value!.currentOver != 0) {
      // Show your dialog here
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
  // Function to generate a random phone number

// Generate a random phone number
  String generatePhoneNumber() {
    final Random random = Random();
    return '9${random.nextInt(1000000000)}';
  }

// Function to generate random player names
  String generateRandomName() {
    return faker.person.name();
  }

  // Function to generate a list of 11 players with random names
  List<PlayerModel> generatePlayers() {
    return List.generate(11, (index) {
      return PlayerModel(
        name: generateRandomName(),
        id: index.toString(),
        phoneNumber: generatePhoneNumber(),
        role: 'Batsman',
        // batting: BattingModel(
        //   runs: 0,
        //   balls: 0,
        //   fours: 0,
        //   sixes: 0,
        //   strikeRate:
        //       faker.randomGenerator.decimal(min: 39, scale: 1).toDouble(),
        //   bowledBy: '',
        //   outType: '',
        // ),
        // bowling: BowlingModel(
        //   runs: 0,
        //   wickets: 0,
        //   economy: 0,
        //   maidens: 0,
        //   fours: 0,
        //   sixes: 0,
        //   wides: 0,
        //   noBalls: 0,
        // ),
      );
    });
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
