import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/scoreboard_controller.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/data/model/matchup_model.dart';
import 'package:gully_app/ui/screens/full_scorecard.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:gully_app/ui/widgets/scorecard/current_over_card.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../../utils/app_logger.dart';
import '../../../utils/utils.dart';
import '../../screens/home_screen.dart';
import '../sponsor/FullScreenVideoPlayer.dart';
import '../sponsor/VideoPlayerWidget.dart';

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

  bool isLoading = true;
  Future getMatchScoreboard() async {
    final sb = await Get.find<ScoreBoardController>()
        .getMatchScoreboard(widget.match.id);
    setState(() {
      isLoading = false;
    });
    final controller = Get.find<ScoreBoardController>();
    if (sb != null) {
      controller.setScoreBoard(sb);
      controller.connectToSocket(hideDialog: true);
    }
  }

  @override
  void initState() {
    //logger.d"The match is is:${widget.match.id}");
    //logger.d"The scoreboard is:${widget.match.scoreBoard}");
    getMatchScoreboard();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    final controller = Get.find<ScoreBoardController>();
    controller.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScoreBoardController>();
    final tournamentcontroller = Get.find<TournamentController>();
    tournamentcontroller.getTournamentSponsor(widget.match.tournamentId ?? '');
    //logger.d(
        // "These tournament Sponsor are:${tournamentcontroller.tournamentSponsor.length}");
    // if (tournamentcontroller.tournamentSponsor.isEmpty) {
    //   return const Center(child: CircularProgressIndicator());
    // }
    if (isLoading) {
      return SizedBox(
          height: Get.height * 0.4,
          child: const Center(child: CircularProgressIndicator()));
    } else if (controller.isScoreboardNull.value) {
      //logger.d"Found a scorecard null");
      return SizedBox(
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              tournamentcontroller.tournamentSponsor.isNotEmpty
                  ? const FullBannerSlider()
                  : const SizedBox.shrink(),
              const SizedBox(
                height: 3,
              ),
              Obx(() {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    tournamentcontroller.tournamentSponsor.isNotEmpty
                        ? const Icon(
                            Icons.arrow_back_ios_new,
                            size: 12,
                            color: AppTheme.darkYellowColor,
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        tournamentcontroller.tournamentSponsor.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          height: 10,
                          width: tournamentcontroller.indexvalue.value == index
                              ? 15
                              : 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                                tournamentcontroller.indexvalue.value == index
                                    ? AppTheme.darkYellowColor
                                    : Colors.grey.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    tournamentcontroller.tournamentSponsor.isNotEmpty
                        ? const Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: AppTheme.darkYellowColor,
                          )
                        : const SizedBox.shrink(),
                  ],
                );
              }),
              Text(
                widget.match.tournamentName ?? '',
                style: Get.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 225, 222, 236),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Text('Match not started yet',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16,
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              PrimaryButton(
                onTap: () {
                  Get.close();
                },
                title: 'Go back',
              )
            ],
          ),
        ),
      );
    } else {
      return Container(
        width: Get.width,
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
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
            tournamentcontroller.tournamentSponsor.isNotEmpty
                ? const FullBannerSlider()
                : const SizedBox.shrink(),
            const SizedBox(
              height: 3,
            ),
            Obx(() {
              return Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  tournamentcontroller.tournamentSponsor.isNotEmpty
                      ? const Icon(
                          Icons.arrow_back_ios_new,
                          size: 12,
                          color: AppTheme.darkYellowColor,
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      tournamentcontroller.tournamentSponsor.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        height: 10,
                        width: tournamentcontroller.indexvalue.value == index
                            ? 15
                            : 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: tournamentcontroller.indexvalue.value == index
                              ? AppTheme.darkYellowColor
                              : Colors.grey.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  tournamentcontroller.tournamentSponsor.isNotEmpty
                      ? const Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: AppTheme.darkYellowColor,
                        )
                      : const SizedBox.shrink(),
                ],
              );
            }),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Obx(
                () => Column(
                  children: [
                    Text(
                      widget.match.tournamentName ?? '',
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
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Obx(() => Text(
                                'Current Innings: ${controller.scoreboard.value?.currentInnings}')),
                            SizedBox(
                              width: Get.width,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: widget.match.scoreBoard![
                                                                  'team1']
                                                              ['teamLogo'] !=
                                                          null &&
                                                      widget
                                                          .match
                                                          .scoreBoard!['team1']
                                                              ['teamLogo']
                                                          .isNotEmpty
                                                  ? Image.network(
                                                      widget.match.scoreBoard![
                                                                      'team1'][
                                                                  'teamLogo'] ==
                                                              widget.match.team1
                                                                  .toImageUrl()
                                                          ? widget.match.team1
                                                              .toImageUrl()
                                                          : widget.match.team2
                                                              .toImageUrl(),
                                                      height: 50,
                                                      fit: BoxFit.cover,
                                                      width: 50)
                                                  : Image.asset(
                                                      "assets/images/logo.png",
                                                      height: 50,
                                                      fit: BoxFit.contain,
                                                      width: 50,
                                                    ),
                                            ),
                                            const SizedBox(width: 10),
                                            Obx(() {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: AppTheme
                                                      .secondaryYellowColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '${controller.scoreboard.value?.firstInningHistory.entries.lastOrNull?.value.total ?? 0}/${controller.scoreboard.value?.firstInningHistory.entries.lastOrNull?.value.wickets ?? 0}',
                                                    style: Get.textTheme
                                                        .headlineMedium
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 12),
                                                  ),
                                                ),
                                              );
                                              // if (controller.scoreboard.value?.currentInnings == 1)
                                              //   BlinkingText(
                                              //     text: 'Batting',
                                              //     style: TextStyle(
                                              //       color: Colors.green,
                                              //       fontWeight: FontWeight.bold,
                                              //       fontSize: 10,
                                              //     ),
                                              //   );
                                            })
                                          ],
                                        ),
                                        Text(
                                          widget.match.scoreBoard!['team1']
                                                      ['teamName'] ==
                                                  widget.match.team1.name
                                              ? widget.match.team1.name
                                              : widget.match.team2.name,
                                          overflow: TextOverflow.ellipsis,
                                          style: Get.textTheme.headlineMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            // color: controller.scoreboard.value?.currentInnings==2 ? Colors.grey :Colors.black,
                                            color: Colors.black,
                                            fontSize: 13,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 30),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            controller.scoreboard.value
                                                        ?.secondInnings ==
                                                    null
                                                ? const Text(
                                                    "DNB",
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  )
                                                : Obx(() {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        color: AppTheme
                                                            .secondaryYellowColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          '${controller.scoreboard.value?.secondInningHistory.entries.lastOrNull?.value.total ?? 0}/${controller.scoreboard.value?.secondInningHistory.entries.lastOrNull?.value.wickets ?? 0}',
                                                          style: Get.textTheme
                                                              .headlineMedium
                                                              ?.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                            const SizedBox(width: 10),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              child: SizedBox(
                                                height: 50,
                                                width: 50,
                                                child: widget.match.scoreBoard![
                                                                    'team2']
                                                                ['teamLogo'] !=
                                                            null &&
                                                        widget
                                                            .match
                                                            .scoreBoard![
                                                                'team2']
                                                                ['teamLogo']
                                                            .isNotEmpty
                                                    ? Image.network(
                                                        widget.match.scoreBoard![
                                                                        'team2']
                                                                    [
                                                                    'teamLogo'] ==
                                                                widget
                                                                    .match.team2
                                                                    .toImageUrl()
                                                            ? widget.match.team2
                                                                .toImageUrl()
                                                            : widget.match.team1
                                                                .toImageUrl(),
                                                        height: 50,
                                                        fit: BoxFit.cover,
                                                        width: 50,
                                                      )
                                                    : Image.asset(
                                                        "assets/images/logo.png",
                                                        height: 50,
                                                        fit: BoxFit.cover,
                                                        width: 50,
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              widget.match.scoreBoard!['team2']
                                                          ['teamName'] ==
                                                      widget.match.team2.name
                                                  ? widget.match.team2.name
                                                  : widget.match.team1.name,
                                              style: Get
                                                  .textTheme.headlineMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        // controller.scoreboard.value
                                        //     ?.currentInnings ==
                                        //     1
                                        //     ? const SizedBox()
                                        //     : Container(
                                        //   decoration: BoxDecoration(
                                        //     color: AppTheme
                                        //         .secondaryYellowColor,
                                        //     borderRadius:
                                        //     BorderRadius.circular(10),
                                        //   ),
                                        //   child: Padding(
                                        //     padding:
                                        //     const EdgeInsets.all(8.0),
                                        //     child: Text(
                                        //       '${controller.scoreboard.value?.firstInningHistory.entries.last.value.total}/${controller.scoreboard.value?.firstInningHistory.entries.last.value.wickets}',
                                        //       style: Get.textTheme
                                        //           .headlineMedium
                                        //           ?.copyWith(
                                        //         fontWeight:
                                        //         FontWeight.bold,
                                        //         color: Colors.white,
                                        //         fontSize: 14,
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: Column(children: [
                                Text(
                                    'Over: ${controller.scoreboard.value?.currentOver}.${controller.scoreboard.value?.currentBall}'),
                                // const Text('To win: '),
                              ]),
                            ),
                            Obx(() {
                              final secondInningsText = controller
                                  .scoreboard.value?.secondInningsText;
                              if (secondInningsText == 'Match Tied') {
                                return Text(
                                  widget.match.getWinningTeamName() == null
                                      ? "Match Tied"
                                      : "${widget.match.getWinningTeamName()} Won The Match" ??
                                          "Match Tied",
                                );
                              } else {
                                return Text(
                                  secondInningsText ?? '',
                                );
                              }
                            }),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset('assets/images/bat.png',
                                              height: 12),
                                          const SizedBox(width: 3),
                                          const Text('Striker: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13)),
                                          Expanded(
                                            child: Text(
                                              '${controller.scoreboard.value?.striker.name}',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: controller
                                                            .scoreboard
                                                            .value
                                                            ?.striker
                                                            .batting
                                                            ?.outType
                                                            .isNotEmpty ==
                                                        true
                                                    ? Colors.red
                                                    : Colors.black,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(width: 15),
                                          const Text('Runs: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13)),
                                          Text(
                                              '${controller.scoreboard.value?.striker.batting?.runs}',
                                              style:
                                                  const TextStyle(fontSize: 13))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(width: 15),
                                          const Text('SR: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12)),
                                          Text(
                                              '${controller.scoreboard.value?.striker.batting?.strikeRate.toStringAsFixed(2)}',
                                              style:
                                                  const TextStyle(fontSize: 13))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 1),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset('assets/images/bat.png',
                                              height: 12),
                                          const SizedBox(width: 3),
                                          const Text('Non Striker: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13)),
                                          Expanded(
                                            child: Text(
                                              '${controller.scoreboard.value?.nonstriker.name}',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: controller
                                                              .scoreboard
                                                              .value
                                                              ?.nonstriker
                                                              .batting
                                                              ?.outType
                                                              .isNotEmpty ==
                                                          true
                                                      ? Colors.red
                                                      : Colors.black),
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(width: 15),
                                          const Text('Runs: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13)),
                                          Text(
                                              '${controller.scoreboard.value?.nonstriker.batting?.runs}',
                                              style:
                                                  const TextStyle(fontSize: 13))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(width: 15),
                                          const Text('SR: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13)),
                                          Text(
                                              '${controller.scoreboard.value?.nonstriker.batting?.strikeRate.toStringAsFixed(2)}',
                                              style:
                                                  const TextStyle(fontSize: 13))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Image.asset('assets/images/ball.png',
                                    height: 14),
                                const SizedBox(width: 5),
                                const Text('Bowler :  ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500)),
                                Text(
                                    '${controller.scoreboard.value?.bowler.name}'),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const CurrentOverStats(),
                            const SizedBox(
                              height: 10,
                            ),
                            PrimaryButton(
                              onTap: () {
                                Get.to(() => const FullScoreboardScreen());
                              },
                              title: 'View Scorecard ',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }
  }
}

class FullBannerSlider extends StatefulWidget {
  const FullBannerSlider({super.key});

  @override
  State<FullBannerSlider> createState() => _FullBannerSliderState();
}

class _FullBannerSliderState extends State<FullBannerSlider> {
  final Map<String, VideoPlayerController> _videoControllers = {};
  VideoPlayerController? _videoPlayerController2;
  bool _isFullScreen = false;
  final double _volume = 1.0;
  int _current = 0;

  @override
  void dispose() {
    final tournamentcontroller = Get.find<TournamentController>();
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    _videoControllers.clear();
    //logger.d"Cleared Done");
    tournamentcontroller.indexvalue.value = 0;
    super.dispose();
  }

  Future<void> _initializeVideoPlayer(String mediaUrl) async {
    if (_videoControllers.containsKey(mediaUrl) &&
        _videoControllers[mediaUrl]!.value.isInitialized) {
      return;
    }

    try {
      final controller = VideoPlayerController.network(mediaUrl);
      _videoControllers[mediaUrl] = controller;

      await controller.initialize();
      await controller.setVolume(_volume);
      await controller.setLooping(true);

      if (_current == _getCurrentVideoIndex() && mounted) {
        await controller.play();
        setState(() {});
      }
    } catch (e) {
      //logger.e("Error initializing video player for $mediaUrl: $e");
    }
  }

  int _getCurrentVideoIndex() {
    final controller = Get.find<TournamentController>();
    return controller.indexvalue.value;
  }

  void _handleFullScreenToggle() {
    final controller = Get.find<TournamentController>();
    final sponsors = controller.tournamentSponsor.value;
    final currentSponsor = sponsors[_current];

    if (currentSponsor.isVideo) {
      final mediaUrl = toImageUrl(currentSponsor.brandMedia);
      final videoController = _videoControllers[mediaUrl];

      if (videoController?.value.isInitialized ?? false) {
        if (!_isFullScreen) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FullScreenVideoPlayer(
                controller: videoController!,
                onExitFullScreen: () {
                  Navigator.of(context).pop();
                  SystemChrome.setPreferredOrientations(
                      [DeviceOrientation.portraitUp]);
                  setState(() => _isFullScreen = false);
                },
              ),
            ),
          );
        }
        setState(() => _isFullScreen = !_isFullScreen);
      }
    }
  }

  void _handlePageChange(int index) {
    final controller = Get.find<TournamentController>();
    final sponsors = controller.tournamentSponsor.value;

    for (var videoController in _videoControllers.values) {
      videoController.pause();
    }

    if (index < sponsors.length && sponsors[index].isVideo) {
      final mediaUrl = toImageUrl(sponsors[index].brandMedia);
      final videoController = _videoControllers[mediaUrl];
      if (videoController?.value.isInitialized ?? false) {
        videoController?.play();
      }
    }

    setState(() {
      _current = index;
      controller.updateIndex(index);
    });
  }

  void _preInitializeNextVideo(int currentIndex) {
    final controller = Get.find<TournamentController>();
    final sponsors = controller.tournamentSponsor.value;

    if (currentIndex + 1 < sponsors.length &&
        sponsors[currentIndex + 1].isVideo) {
      _initializeVideoPlayer(toImageUrl(sponsors[currentIndex + 1].brandMedia));
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TournamentController>();
    return SizedBox(
      height: 150,
      width: Get.width,
      child: Obx(
        () => CarouselSlider(
          items: controller.tournamentSponsor.value.map((e) {
            final mediaUrl = toImageUrl(e.brandMedia);

            if (e.isVideo &&
                _current == controller.tournamentSponsor.value.indexOf(e)) {
              _initializeVideoPlayer(mediaUrl);
              _preInitializeNextVideo(
                  controller.tournamentSponsor.value.indexOf(e));
            }

            return ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (e.isVideo)
                    _videoControllers[mediaUrl]?.value.isInitialized == true
                        ? VideoPlayerWidget(
                            videoController: _videoControllers[mediaUrl]!,
                            initialVolume: _volume,
                            onFullScreenToggle: _handleFullScreenToggle,
                            sponsorlink: e.brandUrl != "Not Defined"
                                ? e.brandUrl ?? ''
                                : '',
                          )
                        : const Center(child: CircularProgressIndicator())
                  else
                    CachedNetworkImage(
                      imageUrl: mediaUrl,
                      fit: BoxFit.fill,
                      width: double.infinity,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  !e.isVideo && e.brandUrl != "Not Defined"
                      ? Positioned(
                          bottom: 10,
                          right: 10,
                          child: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.black45,
                                )),
                            child: IconButton(
                              icon: const Icon(
                                Icons.link_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {
                                if (e.brandUrl != null &&
                                    e.brandUrl!.isNotEmpty &&
                                    e.brandUrl != "Not Defined") {
                                  _launchURL(e.brandUrl ?? '');
                                }
                              },
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  Positioned(
                    top: 2,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          _showDescription(context, e.brandName ?? '',
                              e.brandDescription ?? '', e.brandUrl ?? '');
                        },
                        child: const Text(
                          "Sponsored",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          options: CarouselOptions(
            viewportFraction: 0.91,
            enableInfiniteScroll: false,
            autoPlay: false,
            onPageChanged: (index, reason) {
              _handlePageChange(index);
            },
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
          ),
        ),
      ),
    );
  }

  void _showDescription(BuildContext context, String brandName,
      String description, String BrandUrl) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          width: Get.width,
          padding: const EdgeInsets.all(20.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "About $brandName",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    if (BrandUrl != null &&
                        BrandUrl.isNotEmpty &&
                        BrandUrl != 'Not Defined')
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: AppTheme.primaryColor,
                        ),
                        onPressed: () {
                          _launchURL(BrandUrl);
                        },
                        child: const Text(
                          "Visit Site",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      )
                  ],
                ),
                const Divider(
                  height: 20,
                  color: Colors.grey,
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
