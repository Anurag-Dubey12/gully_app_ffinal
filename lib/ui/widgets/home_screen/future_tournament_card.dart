import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/tournament_model.dart';
import 'package:gully_app/ui/widgets/home_screen/i_button_dialog.dart';

import '../../../data/controller/tournament_controller.dart';
import '../../../utils/date_time_helpers.dart';
import '../../screens/register_team.dart';
import '../../theme/theme.dart';
import 'no_tournament_card.dart';

class FutureTournamentCard extends GetView<TournamentController> {
  const FutureTournamentCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: Get.height * 0.54,
      child: Obx(() {
        if (controller.tournamentList.isEmpty) {
          return const NoTournamentCard();
        } else {
          return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.tournamentList.length,
              padding: const EdgeInsets.only(bottom: 10, top: 10),
              shrinkWrap: true,
              itemBuilder: (context, snapshot) {
                return TournamentCard(
                  tournament: controller.tournamentList[snapshot],
                );
              });
        }
      }),
    );
  }
}

class TournamentCard extends StatefulWidget {
  final TournamentModel tournament;
  const TournamentCard({
    super.key,
    required this.tournament,
  });

  @override
  State<TournamentCard> createState() => _TournamentCardState();
}

class _TournamentCardState extends State<TournamentCard> {
  late StreamController<String> _timeStreamController;

  @override
  void initState() {
    super.initState();

    // Replace this with the actual date you get from the server

    _timeStreamController = StreamController<String>();
    _updateTime();
    // Update the time every second
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    Duration remainingTime =
        widget.tournament.tournamentEndDateTime.difference(DateTime.now());

    String formattedTime =
        '${remainingTime.inDays}d:${remainingTime.inHours.remainder(24)}h:${remainingTime.inMinutes.remainder(60)}m:${remainingTime.inSeconds.remainder(60)}s';

    _timeStreamController.add(formattedTime);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TournamentController>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: Get.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          image: const DecorationImage(
              image: AssetImage(
                'assets/images/cricket_bat.png',
              ),
              alignment: Alignment.bottomLeft,
              scale: 1),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(0, 1))
          ],
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            const SizedBox(height: 7),
            Text(
              widget.tournament.tournamentName,
              style: Get.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppTheme.darkYellowColor),
            ),
            const SizedBox(height: 7),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date: ${formatDateTime('dd MMM yyy', widget.tournament.tournamentStartDateTime)}',
                    style: Get.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  StreamBuilder<Object>(
                      stream: _timeStreamController.stream,
                      builder: (context, snapshot) {
                        return Text(
                          'Time Left: ${snapshot.data}',
                          style: Get.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        );
                      }),
                ],
              ),
            ),
            const SizedBox(height: 17),
            Padding(
              padding: const EdgeInsets.only(right: 28),
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 34,
                  width: 100,
                  child: ElevatedButton(
                      onPressed: () {
                        if (widget.tournament.registeredTeamsCount ==
                            widget.tournament.tournamentLimit) {
                          return;
                        }
                        controller.setSelectedTournament(widget.tournament);
                        Get.to(() => const RegisterTeam());
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(6)),
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (widget.tournament.registeredTeamsCount ==
                                widget.tournament.tournamentLimit) {
                              return Colors.grey;
                            }
                            if (states.contains(MaterialState.pressed)) {
                              return AppTheme.secondaryYellowColor
                                  .withOpacity(0.8);
                            } else {
                              return AppTheme.secondaryYellowColor;
                            }
                          })),
                      child: Text('Join Now',
                          style: Get.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              color: Colors.white))),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Team: ${widget.tournament.registeredTeamsCount}/${widget.tournament.tournamentLimit}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        onPressed: () {
                          Get.bottomSheet(
                              IButtonDialog(
                                organizerName: widget.tournament.organizerName!,
                                location: widget.tournament.stadiumAddress,
                                coverPhoto: widget.tournament.coverPhoto,
                              ),
                              backgroundColor: Colors.white);
                        },
                        icon: const Icon(Icons.info_outline_rounded, size: 18),
                        color: Colors.grey,
                      )
                    ],
                  ),
                  Text(
                    'Entry Fees: ₹${widget.tournament.fees}/-',
                    style: Get.textTheme.labelMedium,
                  )
                ],
              ),
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
