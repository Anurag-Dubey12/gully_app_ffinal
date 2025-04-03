import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/image_picker_helper.dart';

import '../../data/controller/misc_controller.dart';
import '../../data/controller/team_controller.dart';
import '../../data/model/team_model.dart';
import '../../utils/FallbackImageProvider.dart';
import '../../utils/utils.dart';
import '../theme/theme.dart';
import '../widgets/arc_clipper.dart';
import '../widgets/primary_button.dart';
import 'add_player_to_team.dart';

class ViewTeamPlayers extends StatefulWidget {
  final TeamModel teamModel;
  const ViewTeamPlayers({super.key, required this.teamModel});

  @override
  State<ViewTeamPlayers> createState() => _ViewTeamPlayersState();
}

class _ViewTeamPlayersState extends State<ViewTeamPlayers> {
  @override
  void initState() {
    super.initState();
    final controller = Get.find<TeamController>();
    controller.setTeam(widget.teamModel);
    controller.getPlayers();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeamController>();
    final MiscController connectionController = Get.find<MiscController>();
    return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage(
                'assets/images/sports_icon.png',
              ),
              fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          // bottomNavigationBar: Builder(
          //   builder: (context) => Obx(() {
          //     return Container(
          //       height: 70,
          //       decoration: BoxDecoration(
          //         color: Colors.white,
          //         boxShadow: [
          //           BoxShadow(
          //             color: Colors.black.withOpacity(0.1),
          //             blurRadius: 5,
          //             spreadRadius: 2,
          //             offset: const Offset(0, -1),
          //           ),
          //         ],
          //       ),
          //       child: Column(
          //         children: [
          //           Padding(
          //             padding: const EdgeInsets.symmetric(
          //                 horizontal: 20.0, vertical: 10),
          //             child: PrimaryButton(
          //               isDisabled: controller.players.value.length == 15 ||!connectionController.isConnected.value,
          //               disabledText: !connectionController.isConnected.value
          //                   ? 'Connect to the Internet to add Players'
          //                   : 'Maximum 15 players added',
          //               onTap: () async {
          //                 await Get.bottomSheet(
          //                   BottomSheet(
          //                     backgroundColor: const Color(0xffEBEBEB),
          //                     enableDrag: false,
          //                     builder: (context) => AddPlayerDialog(
          //                       teamId: controller.state.id,
          //                     ),
          //                     onClosing: () {
          //                       setState(() {});
          //                     },
          //                   ),
          //                 );
          //
          //                 setState(() {});
          //               },
          //               title: "Add Player",
          //             ),
          //           ),
          //         ],
          //       ),
          //     );
          //   }),
          // ),
          body: Stack(
            children: [
              ClipPath(
                clipper: ArcClipper(),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const RadialGradient(
                      colors: [
                        Color(0xff368EBF),
                        AppTheme.primaryColor,
                      ],
                      center: Alignment(-0.4, -0.8),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: AppTheme.secondaryYellowColor.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: const Offset(0, 70))
                    ],
                  ),
                  width: double.infinity,
                ),
              ),
              Positioned(
                  top: 0,
                  child: SizedBox(
                    width: Get.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 0, top: 30),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: BackButton(
                                color: Colors.white,
                              )),
                        ),
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Column(
                                  children: [
                                    Text(widget.teamModel.name,
                                        style: Get.textTheme.headlineLarge
                                            ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              SizedBox(height: Get.height * 0.04),
                              Center(
                                child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: AppTheme.primaryColor,
                                            width: 1)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Stack(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              imageViewer(context,
                                                  widget.teamModel.logo, true);
                                            },
                                            child: CircleAvatar(
                                                radius: 49,
                                                backgroundColor: Colors.white,
                                                backgroundImage: FallbackImageProvider(
                                                    toImageUrl(widget
                                                            .teamModel.logo ??
                                                        "assets/images/logo.png"),
                                                    'assets/images/logo.png')),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                              SizedBox(height: Get.height * 0.001),
                              SizedBox(
                                // height: Get.height * 0.58,
                                height: Get.height,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Obx(() {
                                    final playersList = controller.players;

                                    return !connectionController
                                            .isConnected.value
                                        ? Center(
                                            child: SizedBox(
                                              width: Get.width,
                                              height: Get.height,
                                              child: const Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.signal_wifi_off,
                                                    size: 48,
                                                    color: Colors.black54,
                                                  ),
                                                  SizedBox(height: 16),
                                                  Text(
                                                    'No internet connection',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : ListView.separated(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            shrinkWrap: true,
                                            itemCount: playersList.length,
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(height: 10),
                                            itemBuilder: (context, index) {
                                              return Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5,
                                                        horizontal: 5),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                  borderRadius:
                                                      BorderRadius.circular(19),
                                                  border: Border.all(
                                                      color: Colors.black87),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        SizedBox(
                                                          width: 150,
                                                          child: Text(
                                                            playersList[index]
                                                                .name,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: Get.textTheme
                                                                .titleMedium
                                                                ?.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        18),
                                                          ),
                                                        ),
                                                        Text(
                                                          playersList[index]
                                                              .role,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: Get.textTheme
                                                              .titleMedium
                                                              ?.copyWith(
                                                                  color: Colors
                                                                          .grey[
                                                                      600],
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 14),
                                                        ),
                                                        // IconButton(
                                                        //   onPressed: () async {
                                                        //     bool? confirm =await Get.dialog(
                                                        //             AlertDialog.adaptive(
                                                        //       title: const Text('Confirm Delete'),
                                                        //       content: Text('Are you sure you want to remove ${playersList[index].name}?'),
                                                        //       actions: [
                                                        //         TextButton(
                                                        //           onPressed: () {Navigator.of(context).pop(false); },
                                                        //           child: const Text('Cancel'),
                                                        //         ),
                                                        //         TextButton(
                                                        //           onPressed: () {Navigator.of(context).pop(true);},
                                                        //           child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                                        //         ),
                                                        //       ],
                                                        //     ));
                                                        //     if (confirm == true) {
                                                        //       //logger.d
                                                        //           "Player delete Data is:\n Team id ${widget.teamModel.id}\n"
                                                        //           "player id ${playersList[index].id}");
                                                        //       bool isRemoved = await controller.removePlayerFromTeam(
                                                        //         teamId: widget.teamModel.id,
                                                        //         playerId: playersList[index].id,
                                                        //       );
                                                        //       if (isRemoved) {
                                                        //         //logger.d"Player removed successfully");
                                                        //       }
                                                        //     }
                                                        //   },
                                                        //   icon: const Icon(
                                                        //       Icons.delete,
                                                        //       color: Colors.red,
                                                        //       size: 20),
                                                        // )
                                                      ]),
                                                ),
                                              );
                                            });
                                  }),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }
}
