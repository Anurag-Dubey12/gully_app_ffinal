import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/config/app_constants.dart';
import 'package:gully_app/data/controller/scoreboard_controller.dart';
import 'package:gully_app/data/model/matchup_model.dart';
import 'package:gully_app/data/model/scoreboard_model.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ScoreBottomDialog extends StatefulWidget {
  final MatchupModel match;
  const ScoreBottomDialog({
    super.key,
    required this.match,
  });

  @override
  State<ScoreBottomDialog> createState() => _ScoreBottomDialogState();
}

class _ScoreBottomDialogState extends State<ScoreBottomDialog> {
  late io.Socket socket;
  late ScoreboardModel scoreboard;
  bool isLoading = true;
  Future getMatchScoreboard() async {
    logger.e('scoreboard ');
    final sb = await Get.find<ScoreBoardController>()
        .getMatchScoreboard(widget.match.id);
    logger.e('scoreboard ');
    setState(() {
      logger.e('scoreboard $sb');
      scoreboard = sb;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    getMatchScoreboard();
    try {
      logger.d('connectToSocket ${AppConstants.websocketUrl}');
      socket = io.io(AppConstants.websocketUrl, <String, dynamic>{
        'transports': ['websocket'],
      });
      logger.d('socket $socket');
      socket.onConnectError((data) => logger.e(data));

      socket.onConnect((_) {
        logger.d('connect');
        socket.emit('joinRoom', {
          'matchId': widget.match.id,
        });
      });
      socket.on('scoreboard', (data) {
        logger.i("scoreboard $data['scoreBoard']");
        setState(() {
          try {
            logger.i('updating $data');
            if (data['scoreBoard'] != null) {
              isLoading = false;
              scoreboard = ScoreboardModel.fromJson(data['scoreBoard']);
            }
            logger.i('scoreboard updated');
          } catch (e) {
            logger.i('SOME ERROR');
            logger.e(e);
          }
          logger.i('scoreboard ${scoreboard == null}');
          isLoading = false;
        });
      });
      socket.connect();
      socket.onDisconnect((_) => logger.i('disconnect'));
    } catch (e) {
      logger.e("SOME ERROR");
      logger.e(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    socket.disconnect();
    socket.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Container(
        width: Get.width,
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 7,
                  width: 120,
                  decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Text(
                    'Season Tournament',
                    style: Get.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 23,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 225, 222, 236),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          Container(
                            child: Text(
                                'Current Innings: ${scoreboard.currentInnings}'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.network(
                                      widget.match.team1.toImageUrl(),
                                      height: 50,
                                      fit: BoxFit.cover,
                                      width: 50,
                                    ),
                                  ),
                                  Text(
                                    widget.match.team1.name,
                                    style:
                                        Get.textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                  '${scoreboard.currentInningsScore.toString()}/${
                                  // scoreboard.currentInningsWickets.toString()
                                  2}',
                                  style: Get.textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                    fontSize: 28,
                                  )),
                              Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.network(
                                      widget.match.team2.toImageUrl(),
                                      height: 50,
                                      fit: BoxFit.cover,
                                      width: 50,
                                    ),
                                  ),
                                  Text(
                                    widget.match.team2.name,
                                    style:
                                        Get.textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Center(
                            child: Column(children: [
                              Text(
                                  'Over: ${scoreboard.currentOver}.${scoreboard.currentBall}'),
                              // const Text('To win: '),
                            ]),
                          ),
                          // const BattingStats()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
