import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/tournament_model.dart';
import 'package:gully_app/ui/widgets/home_screen/i_button_dialog.dart';

import '../../../data/controller/tournament_controller.dart';
import '../../../utils/FallbackImageProvider.dart';
import '../../../utils/app_logger.dart';
import '../../../utils/date_time_helpers.dart';
import '../../../utils/utils.dart';
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
      // width: 340,
      // height: 250,
      child: Obx(() {
        if (controller.tournamentList.isEmpty) {
          return const NoTournamentCard();
        } else {
          return ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.tournamentList.length,
            padding: const EdgeInsets.only(bottom: 10, top: 10),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return TournamentCard(
                tournament: controller.tournamentList[index],
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 10),
          );
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

    _timeStreamController = StreamController<String>();
    _updateTime();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }
  void _updateTime() {
    if (widget.tournament.tournamentStartDateTime != null &&
        widget.tournament.tournamentEndDateTime != null) {
      DateTime now = DateTime.now();
      if (now.isBefore(widget.tournament.tournamentStartDateTime)) {
        Duration remainingTime = widget.tournament.tournamentStartDateTime.difference(now);
        String formattedTime =
            ' Time left :${remainingTime.inDays}d:${remainingTime.inHours.remainder(24)}h:${remainingTime.inMinutes.remainder(60)}m:${remainingTime.inSeconds.remainder(60)}s';
        _timeStreamController.add(formattedTime);
      } else if (now.isAfter(widget.tournament.tournamentEndDateTime)) {
        _timeStreamController.add('Tournament has ended');
      } else {
        _timeStreamController.add('Tournament is ongoing');
      }
    } else {
      _timeStreamController.add('Date information not available');
    }
  }
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TournamentController>();
    final tournamentdata = controller.tournamentList
        .firstWhereOrNull((t) => t.id == widget.tournament.id);
    logger.d("Launched tournament");
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: tournamentdata?.coverPhoto != null
                    ? FallbackImageProvider(toImageUrl(tournamentdata!.coverPhoto!),'assets/images/logo.png')
                    : const AssetImage('assets/images/logo.png') as ImageProvider,
                backgroundColor: Colors.transparent,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width:150,
                          child: Text(
                            widget.tournament.tournamentName ?? "Unkown Tournament",
                            style: Get.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppTheme.darkYellowColor,
                            ),
                            softWrap: true,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.bottomSheet(
                              IButtonDialog(
                                organizerName: widget.tournament.organizerName!,
                                location: widget.tournament.stadiumAddress,
                                tournamentName: widget.tournament.tournamentName,
                                tournamentPrice: widget.tournament.fees.toString(),
                                coverPhoto: widget.tournament.coverPhoto,
                              ),
                              backgroundColor: Colors.white,
                            );
                          },
                          icon: const Icon(Icons.info_outline_rounded, size: 18),
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Text(
                          'Start Date',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'End Date',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          formatDateTime('dd/MM/yyyy', widget.tournament.tournamentStartDateTime),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          formatDateTime('dd/MM/yyyy', widget.tournament.tournamentEndDateTime),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 1),
                    StreamBuilder<String>(
                      stream: _timeStreamController.stream,
                      builder: (context, snapshot) {
                        return Text(
                          '${snapshot.data}',
                          style: Get.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (widget.tournament.registeredTeamsCount ==
                                widget.tournament.tournamentLimit) {
                              return;
                            }
                            controller.setSelectedTournament(widget.tournament);
                            Get.to(() => const RegisterTeam());
                          },
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                            ),
                            backgroundColor:
                            WidgetStateProperty.resolveWith((states) {
                              if (widget.tournament.registeredTeamsCount ==
                                  widget.tournament.tournamentLimit) {
                                return Colors.grey;
                              }
                              if (states.contains(WidgetState.pressed)) {
                                return AppTheme.secondaryYellowColor.withOpacity(0.8);
                              } else {
                                return AppTheme.secondaryYellowColor;
                              }
                            }),
                          ),
                          child: Text(
                            'Join Now',
                            style: Get.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width:10),
                        Text(
                          'Team: ${widget.tournament.registeredTeamsCount}/${widget.tournament.tournamentLimit}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
}