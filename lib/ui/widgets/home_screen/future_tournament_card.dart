import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/tournament_model.dart';
import 'package:gully_app/ui/widgets/home_screen/i_button_dialog.dart';

import '../../../data/controller/tournament_controller.dart';
import '../../../utils/FallbackImageProvider.dart';
import '../../../utils/app_logger.dart';
import '../../../utils/date_time_helpers.dart';
import '../../../utils/image_picker_helper.dart';
import '../../../utils/utils.dart';
import '../../screens/register_team.dart';
import '../../screens/schedule_screen.dart';
import '../../theme/theme.dart';
import 'no_tournament_card.dart';

class FutureTournamentCard extends GetView<TournamentController> {
  const FutureTournamentCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Obx(() {
        if (controller.tournamentList.isEmpty) {
          return const NoTournamentCard();
        } else {
          // final sortedTournaments = List<TournamentModel>.from(controller.tournamentList)
          //   ..sort((a, b) => a.tournamentStartDateTime.compareTo(b.tournamentStartDateTime));
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ListView.separated(
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
            ),
          );
        }
      }),
    );
  }
}

class TournamentCard extends StatefulWidget {
  final TournamentModel tournament;
  final bool isSearch;
  const TournamentCard({
    super.key,
    required this.tournament,
    this.isSearch = false,
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
            ' ${remainingTime.inDays}d:${remainingTime.inHours.remainder(24)}h:${remainingTime.inMinutes.remainder(60)}m:${remainingTime.inSeconds.remainder(60)}s';
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
    return GestureDetector(
      onTap: widget.isSearch ? (){
        logger.d("The TournamentId is:${tournamentdata!.id} }");
        controller.setScheduleStatus(true);
        Get.to(() => ScheduleScreen(tournament: tournamentdata));
      }:(){},
      child: Container(
          margin: const EdgeInsets.only(left: 10,right: 10),
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
               margin: const EdgeInsets.only(left:10),
               child: GestureDetector(
                 onTap: () {
                   imageViewer(context,tournamentdata?.coverPhoto,true);
                   logger.e("The image url is ${tournamentdata?.coverPhoto}");
                 },
                 child: CircleAvatar(
                      radius: 45,
                      backgroundImage: tournamentdata?.coverPhoto != null
                          ? FallbackImageProvider(toImageUrl(tournamentdata!.coverPhoto!),'assets/images/logo.png')
                          : const AssetImage('assets/images/logo.png') as ImageProvider,
                      backgroundColor: Colors.transparent,
                    ),
               ),
             ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width:150,
                            child: Center(
                              child: Text(
                                widget.tournament.tournamentName,
                                style: Get.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: AppTheme.darkYellowColor,
                                ),
                                softWrap: true,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
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
                      // const SizedBox(height: 1),
                      // Row(
                      //   children: [
                      //     StreamBuilder<String>(
                      //       stream: _timeStreamController.stream,
                      //       builder: (context, snapshot) {
                      //         if (snapshot.hasData) {
                      //           final data = snapshot.data!;
                      //           if (data == "Tournament is ongoing") {
                      //             return Text(
                      //               data,
                      //               style: Get.textTheme.labelMedium?.copyWith(
                      //                 fontWeight: FontWeight.bold,
                      //                 fontSize: 12,
                      //                 color: Colors.green,
                      //               ),
                      //             );
                      //           } else {
                      //             return Row(
                      //               children: [
                      //                 Text(
                      //                   "Time Left:",
                      //                   style: TextStyle(
                      //                     color: Colors.black,
                      //                     fontWeight: FontWeight.w500,
                      //                   ),
                      //                 ),
                      //                 const SizedBox(width: 5),
                      //                 Text(
                      //                   data,
                      //                   style: Get.textTheme.labelMedium?.copyWith(
                      //                     fontWeight: FontWeight.bold,
                      //                     fontSize: 12,
                      //                   ),
                      //                 ),
                      //               ],
                      //             );
                      //           }
                      //         }
                      //         return const SizedBox.shrink();
                      //       },
                      //     ),
                      //   ],
                      // ),
                      Row(
                        children: [
                          const Text("Time Left:",style: TextStyle(
                            color: Colors.black,
                          ),),
                          StreamBuilder<String>(
                            stream: _timeStreamController.stream,
                            builder: (context, snapshot) {
                              return Text(
                                '${snapshot.data}',
                                style: Get.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      // const SizedBox(height: 2),
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
      ),
    );
  }
}