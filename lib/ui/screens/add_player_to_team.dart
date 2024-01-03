import 'package:flutter/material.dart';
import 'package:get/get.dart'; //
import 'package:gully_app/data/controller/team_controller.dart';
import 'package:gully_app/data/model/player_model.dart';
import 'package:gully_app/utils/app_logger.dart';

import '../theme/theme.dart';
import '../widgets/arc_clipper.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class AddPlayersToTeam extends StatefulWidget {
  final String teamId;
  const AddPlayersToTeam({super.key, required this.teamId});

  @override
  State<AddPlayersToTeam> createState() => _AddPlayersToTeamState();
}

class _AddPlayersToTeamState extends State<AddPlayersToTeam> {
  @override
  void initState() {
    super.initState();
    final controller = Get.find<TeamController>();
    controller.getPlayers(widget.teamId);
  }

  @override
  Widget build(BuildContext context) {
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
          bottomNavigationBar: Container(
            height: 90,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: const Offset(0, -1))
            ]),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 35.0, vertical: 19),
                  child: PrimaryButton(
                    onTap: () async {
                      final d = await Get.bottomSheet(
                        BottomSheet(
                          backgroundColor: const Color(0xffEBEBEB),
                          enableDrag: false,
                          builder: (context) => _AddPlayerDialog(
                            teamId: widget.teamId,
                          ),
                          onClosing: () {
                            setState(() {});
                          },
                        ),
                      );
                      logger.f("Calling NOWOWOWOWOWOWOWOWOOWWO $d");
                      setState(() {});
                    },
                    title: 'Add Player',
                  ),
                ),
              ],
            ),
          ),
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
                    height: Get.height * 1.4,
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
                                child: Text('Add Players',
                                    style: Get.textTheme.headlineLarge
                                        ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(height: Get.height * 0.04),
                              // Padding(
                              //   padding: EdgeInsets.symmetric(
                              //     horizontal: Get.width * 0.07,
                              //   ),
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //         color: Colors.white,
                              //         borderRadius: BorderRadius.circular(10),
                              //         boxShadow: [
                              //           BoxShadow(
                              //               color:
                              //                   Colors.black.withOpacity(0.1),
                              //               blurRadius: 5,
                              //               spreadRadius: 2,
                              //               offset: const Offset(0, 1))
                              //         ]),
                              //     child: Padding(
                              //       padding: const EdgeInsets.all(28.0),
                              //       child: Row(
                              //         children: [
                              //           Container(
                              //               decoration: BoxDecoration(
                              //                   shape: BoxShape.circle,
                              //                   border: Border.all(
                              //                       color:
                              //                           AppTheme.primaryColor,
                              //                       width: 1)),
                              //               child: const Padding(
                              //                 padding: EdgeInsets.all(3.0),
                              //                 child: Stack(
                              //                   children: [
                              //                     CircleAvatar(
                              //                       radius: 39,
                              //                     ),
                              //                     Positioned(
                              //                       bottom: 0,
                              //                       right: 0,
                              //                       child: CircleAvatar(
                              //                         radius: 10,
                              //                         backgroundColor: AppTheme
                              //                             .secondaryYellowColor,
                              //                         child: Icon(
                              //                           Icons.edit,
                              //                           color: Colors.white,
                              //                           size: 15,
                              //                         ),
                              //                       ),
                              //                     )
                              //                   ],
                              //                 ),
                              //               )),
                              //           const SizedBox(width: 10),
                              //           Text('Black Panther',
                              //               style: Get.textTheme.headlineMedium
                              //                   ?.copyWith(
                              //                       color: Colors.black,
                              //                       fontWeight:
                              //                           FontWeight.w500)),
                              //           const Icon(
                              //             Icons.edit,
                              //             color: AppTheme.secondaryYellowColor,
                              //             size: 18,
                              //           )
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),

                              SizedBox(height: Get.height * 0.02),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Text('Players',
                                    style: Get.textTheme.headlineMedium
                                        ?.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                              ),
                              TeamPlayersListBuilder(teamId: widget.teamId)
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

class TeamPlayersListBuilder extends GetView<TeamController> {
  final String teamId;
  const TeamPlayersListBuilder({
    super.key,
    required this.teamId,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.65,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black26,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() {
            return ListView.separated(
                padding: const EdgeInsets.only(bottom: 30),
                shrinkWrap: true,
                itemCount: controller.players.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  return PlayerCard(
                    teamId,
                    player: controller.players[index],
                  );
                });
          }),
        ),
      ),
    );
  }
}

class PlayerCard extends StatefulWidget {
  final PlayerModel player;
  final String team;
  const PlayerCard(
    this.team, {
    super.key,
    required this.player,
  });

  @override
  State<PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeamController>();
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(19)),
      child: Padding(
        padding: const EdgeInsets.all(19.0),
        child: Row(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: Get.width / 2.8,
                    child: Text(
                      widget.player.name,
                      overflow: TextOverflow.ellipsis,
                      style: Get.textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.player.role,
                    style: Get.textTheme.labelSmall,
                  ),
                ],
              ),
              Text(widget.player.phoneNumber)
            ],
          ),
          const Spacer(),
          const CircleAvatar(
            // radius: 13,
            backgroundColor: Color.fromARGB(255, 71, 224, 79),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.share),
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            // radius: 13,
            backgroundColor: const Color.fromARGB(255, 235, 17, 24),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () {
                    controller.removePlayerFromTeam(
                        teamId: widget.team, playerId: widget.player.id);
                    setState(() {});
                  },
                  child: const Icon(
                    Icons.cancel,
                  )),
            ),
          )
        ]),
      ),
    );
  }
}

class _AddPlayerDialog extends StatelessWidget {
  final String teamId;
  const _AddPlayerDialog({required this.teamId});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: Get.width,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
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
                Text('Add Player ',
                    style: Get.textTheme.headlineMedium?.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                // 1. Create two containers with some box shadow
                // 2. in each of the conatiner, it contains one circle avatar having an icon and one text

                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    // Get.back();
                    await Get.bottomSheet(_AddPlayerDetails(teamId: teamId),
                        backgroundColor: Colors.white);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 2,
                            offset: const Offset(0, 1))
                      ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppTheme.secondaryYellowColor,
                            child: Icon(Icons.person_add),
                          ),
                          SizedBox(width: 15),
                          Text('Add via phone number')
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          spreadRadius: 2,
                          offset: const Offset(0, 1))
                    ],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppTheme.secondaryYellowColor,
                          child: Icon(Icons.contact_phone),
                        ),
                        SizedBox(width: 15),
                        Text('Add from contacts')
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AddPlayerDetails extends StatefulWidget {
  final String teamId;
  const _AddPlayerDetails({required this.teamId});

  @override
  State<_AddPlayerDetails> createState() => _AddPlayerDetailsState();
}

class _AddPlayerDetailsState extends State<_AddPlayerDetails> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String errorText = '';
  String role = 'Batter';
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeamController>();
    return SizedBox(
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
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
              Text('Add via Phone Number ',
                  style: Get.textTheme.headlineMedium?.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Text(errorText,
                  style: Get.textTheme.bodyLarge?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              const SizedBox(height: 20),
              const Text('Name'),
              const SizedBox(height: 10),
              CustomTextField(
                controller: nameController,
                maxLen: 23,
              ),
              const SizedBox(height: 20),
              const Text('Contact Number'),
              const SizedBox(height: 10),
              CustomTextField(
                controller: phoneController,
                maxLen: 10,
                textInputType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: Get.width,
                child: Wrap(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RoleTile(
                        value: 'Batter',
                        role: role,
                        onChanged: (e) {
                          setState(() {
                            role = e!;
                          });
                        }),
                    RoleTile(
                        value: 'Bowler',
                        role: role,
                        onChanged: (e) {
                          setState(() {
                            role = e!;
                          });
                        }),
                    RoleTile(
                        value: 'All Rounder',
                        role: role,
                        onChanged: (e) {
                          setState(() {
                            role = e!;
                          });
                        }),
                    RoleTile(
                        value: 'Wicket Keeper',
                        role: role,
                        onChanged: (e) {
                          setState(() {
                            role = e!;
                          });
                        }),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                onTap: () async {
                  if (nameController.text.isEmpty ||
                      phoneController.text.isEmpty) {
                    setState(() {
                      errorText = 'Please fill all the fields';
                    });
                    return;
                  }
                  if (!phoneController.text.isPhoneNumber ||
                      phoneController.text.length != 10) {
                    setState(() {
                      errorText = 'Please enter a valid phone number';
                    });
                    return;
                  }
                  try {
                    final res = await controller.addPlayerToTeam(
                        teamId: widget.teamId,
                        name: nameController.text,
                        phone: phoneController.text,
                        role: role);

                    if (res) {
                      Get.back();
                      Get.back();
                    }
                  } catch (e) {
                    rethrow;
                  }
                  // Get.to(() => ViewTeamScreen());
                },
                title: 'Add Player',
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RoleTile extends StatelessWidget {
  const RoleTile({
    super.key,
    required this.role,
    required this.onChanged,
    required this.value,
  });
  final String value;
  final String role;
  final Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Row(
        children: [
          Radio(value: value, groupValue: role, onChanged: onChanged),
          Text(value)
        ],
      ),
    );
  }
}
