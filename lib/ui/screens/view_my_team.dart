import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/player_model.dart';
import 'package:gully_app/ui/screens/add_team.dart';

import '../../data/controller/team_controller.dart';
import '../../data/model/team_model.dart';
import '../theme/theme.dart';
import '../widgets/arc_clipper.dart';

class ViewTeam extends StatefulWidget {
  final TeamModel teamModel;
  const ViewTeam({super.key, required this.teamModel});

  @override
  State<ViewTeam> createState() => _ViewTeamState();
}

class _ViewTeamState extends State<ViewTeam> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeamController>();
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
                                    Text('Hi, meet your teammates!',
                                        style: Get.textTheme.headlineLarge
                                            ?.copyWith(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300)),
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
                                            backgroundImage: NetworkImage(
                                                widget.teamModel.toImageUrl()),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: InkWell(
                                              onTap: () {
                                                Get.off(() => AddTeam(
                                                      team: widget.teamModel,
                                                    ));
                                              },
                                              child: const CircleAvatar(
                                                radius: 20,
                                                backgroundColor: AppTheme
                                                    .secondaryYellowColor,
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                          )
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
                                      future: controller
                                          .getPlayers(widget.teamModel.id),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        if (snapshot.hasError) {
                                          return const Center(
                                            child: Text('Error fetching data'),
                                          );
                                        }
                                        if (snapshot.data?.isEmpty ?? true) {
                                          return const Center(
                                            child:
                                                Text('No Players in this team'),
                                          );
                                        }
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
                                                      12.0),
                                                  child: Row(children: [
                                                    const Spacer(),
                                                    SizedBox(
                                                      width: Get.width / 2,
                                                      child: Text(
                                                        snapshot
                                                            .data![index].name,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: Get.textTheme
                                                            .titleMedium
                                                            ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 25),
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        await Get.dialog(
                                                            AlertDialog
                                                                .adaptive(
                                                          title: const Text(
                                                              'Delete Player'),
                                                          content: const Text(
                                                              'Are you sure you want to delete this Player'),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  Get.back();
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'No')),
                                                            TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  await controller.removePlayerFromTeam(
                                                                      teamId: widget
                                                                          .teamModel
                                                                          .id,
                                                                      playerId: snapshot
                                                                          .data![
                                                                              index]
                                                                          .id);
                                                                  setState(
                                                                      () {});
                                                                  Get.back();
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'Yes')),
                                                          ],
                                                        ));
                                                        setState(() {});
                                                      },
                                                      child: const Icon(
                                                          Icons.delete,
                                                          color: Colors.red),
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
