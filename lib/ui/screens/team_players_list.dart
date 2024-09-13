import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/player_model.dart';

import '../../data/controller/team_controller.dart';
import '../../data/model/team_model.dart';
import '../../utils/FallbackImageProvider.dart';
import '../../utils/utils.dart';
import '../theme/theme.dart';
import '../widgets/arc_clipper.dart';

class ViewTeamPlayers extends StatefulWidget {
  final TeamModel teamModel;
  const ViewTeamPlayers({super.key, required this.teamModel});

  @override
  State<ViewTeamPlayers> createState() => _ViewTeamPlayersState();
}

class _ViewTeamPlayersState extends State<ViewTeamPlayers> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeamController>();
    controller.setTeam(widget.teamModel);
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
                                          CircleAvatar(
                                            radius: 49,
                                            backgroundColor: Colors.white,
                                            backgroundImage: widget.teamModel.toImageUrl().isNotEmpty && widget.teamModel.toImageUrl()!=null ?
                                            FallbackImageProvider(
                                                toImageUrl(widget.teamModel.logo ?? "assets/images/logo.png"),
                                                'assets/images/logo.png'
                                            ) as ImageProvider
                                                : const AssetImage('assets/images/logo.png')
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                              // TeamPlayersListBuilder(
                              //     teamId: widget.teamModel.id),
                              SizedBox(height: Get.height * 0.02),
                              SizedBox(
                                height: Get.height * 0.64,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FutureBuilder<List<PlayerModel>>(
                                      future: controller.getPlayers(),
                                      builder: (context, snapshot) {
                                        return ListView.separated(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            shrinkWrap: true,
                                            itemCount:
                                                snapshot.data?.length ?? 0,
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(height: 14),
                                            itemBuilder: (context, index) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            19),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.3),
                                                          blurRadius: 20,
                                                          spreadRadius: 2,
                                                          offset: const Offset(
                                                              0, 10))
                                                    ]),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          snapshot.data![index]
                                                              .name,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: Get.textTheme
                                                              .titleMedium
                                                              ?.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 20),
                                                        ),
                                                        Text(
                                                          snapshot.data![index]
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
                                                      ]),
                                                ),
                                              );
                                            });
                                      }),
                                ),
                              )
                              //
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
