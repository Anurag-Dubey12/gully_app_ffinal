import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/team_controller.dart';
import 'package:gully_app/data/model/challenge_match.dart';
import 'package:gully_app/data/model/team_model.dart';
import 'package:gully_app/ui/screens/view_opponent_team.dart';
import 'package:gully_app/utils/utils.dart';

import '../../data/controller/auth_controller.dart';
import '../../utils/app_logger.dart';
import '../theme/theme.dart';
import '../widgets/arc_clipper.dart';

class SearchChallengeTeam extends StatefulWidget {
  final TeamModel team;
  const SearchChallengeTeam({super.key, required this.team});

  @override
  State<SearchChallengeTeam> createState() => _SearchChallengeTeamState();
}

class _SearchChallengeTeamState extends State<SearchChallengeTeam> {
  bool searchOpen = false;
  TextEditingController searchValue = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final TeamController teamController = Get.find<TeamController>();
    final AuthController authController = Get.find<AuthController>();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          searchOpen = false;
        });
        searchValue.clear();
      },
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage('assets/images/sports_icon.png'),
            fit: BoxFit.cover,
          ),
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
                  child: SizedBox(
                width: Get.width,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 0, top: 30),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: BackButton(
                            color: Colors.white,
                          )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          // 'Challenge team',
                          AppLocalizations.of(context)!.challengeTeamTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height * 0.04),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: const Color.fromARGB(132, 61, 60, 58)
                                  .withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                              offset: const Offset(0, 7))
                        ],
                      ),
                      height: 54,
                      width: Get.width / 1.2,
                      child: TextField(
                        onTap: () {
                          setState(() {
                            searchOpen = true;
                          });
                        },
                        onSubmitted: (value) {
                          setState(() {
                            searchOpen = false;
                          });
                        },
                        controller: searchValue,
                        onChanged: (e) {
                          if (e.isEmpty) {
                            setState(() {
                              searchOpen = false;
                            });
                          } else {
                            setState(() {
                              searchOpen = true;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          isDense: true,

                          suffixIcon: const Icon(
                            CupertinoIcons.search,
                            color: AppTheme.secondaryYellowColor,
                            size: 28,
                          ),
                          hintText: 'Search..',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          // isCollapsed: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          color: const Color.fromARGB(96, 82, 80, 124),
                          child: Column(
                            children: [
                              searchOpen
                                  ? const SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: FutureBuilder<
                                              List<ChallengeMatchModel>>(
                                          future: teamController
                                              .getChallengeMatch(),
                                          builder: (context, snapshot) {
                                            return ListView.separated(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) =>
                                                  StatefulBuilder(
                                                builder: (c, s) => _Challenges(
                                                  team: snapshot.data![index],
                                                  isChallengedByMe:
                                                      authController
                                                              .state?.id ==
                                                          snapshot.data![index]
                                                              .challengedBy,
                                                  onTap: (status) {
                                                    teamController
                                                        .updateChallengeMatch(
                                                            matchId: snapshot
                                                                .data![index]
                                                                .id,
                                                            status: status);
                                                    successSnackBar(
                                                        'Status Updated to $status');
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                              separatorBuilder:
                                                  (context, index) =>
                                                      const SizedBox(
                                                height: 20,
                                              ),
                                              itemCount:
                                                  snapshot.data?.length ?? 0,
                                              shrinkWrap: true,
                                            );
                                          }),
                                    ),
                              SizedBox(
                                  // height: Get.height / 3.5,
                                  child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: FutureBuilder<List<TeamModel>>(
                                          future:
                                              teamController.getAllNearByTeam(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasError) {
                                              return Center(
                                                  child: TextButton(
                                                      onPressed: () {
                                                        teamController
                                                            .getAllNearByTeam();
                                                      },
                                                      child: Text(
                                                          'Error: ${snapshot.error}')));
                                            }

                                            List<TeamModel>? filteredTeams =
                                                snapshot.data;
                                            if (searchValue.text.isNotEmpty) {
                                              logger.f(
                                                  'Search Value: $searchValue');
                                              filteredTeams = snapshot.data
                                                  ?.where((e) => e.name
                                                      .toLowerCase()
                                                      .contains(searchValue.text
                                                          .toLowerCase()))
                                                  .toList();
                                            }
                                            logger.f(
                                                'Filtered Teams: ${filteredTeams?.length}');
                                            if (filteredTeams == null ||
                                                filteredTeams.isEmpty) {
                                              return const SizedBox(
                                                height: 240,
                                                child: Center(
                                                  child: Text('No Teams Found'),
                                                ),
                                              );
                                            }
                                            return ListView.separated(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) =>
                                                  StatefulBuilder(
                                                builder: (c, s) => _TeamCard(
                                                  team: filteredTeams![index],
                                                  onTap: () async {
                                                    await teamController
                                                        .createChallengeMatch(
                                                            teamId:
                                                                widget.team.id,
                                                            opponentId:
                                                                filteredTeams![
                                                                        index]
                                                                    .id);
                                                    successSnackBar(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .request_sent_successfully);
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                              separatorBuilder:
                                                  (context, index) =>
                                                      const SizedBox(
                                                height: 20,
                                              ),
                                              itemCount:
                                                  filteredTeams.length ?? 0,
                                              shrinkWrap: true,
                                            );
                                          }))),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class _TeamCard extends StatelessWidget {
  final Function onTap;
  final TeamModel team;
  const _TeamCard({super.key, required this.team, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(children: [
          CircleAvatar(
              backgroundImage: NetworkImage(toImageUrl(team.logo ?? ""))),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                team.name.capitalize,
                style:
                    const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              // const Text(
              //   '20th April 2021',
              //   style: TextStyle(
              //       fontSize: 13, color: Color.fromARGB(255, 255, 154, 22)),
              // ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(90),
                    color: AppTheme.darkYellowColor),
                child: IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    onTap();
                  },
                  icon: const Icon(Icons.add),
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              // Chip(
              //     label: Text('Decline', style: TextStyle(color: Colors.white)),
              //     backgroundColor: Colors.red,
              //     side: BorderSide.none),
            ],
          )
        ]),
      ),
    );
  }
}

class _Challenges extends StatelessWidget {
  final ChallengeMatchModel team;
  final bool isChallengedByMe;
  final Function onTap;

  const _Challenges(
      {required this.team,
      required this.isChallengedByMe,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (team.status == "Accepted") {
          Get.to(() => ViewOpponentTeam(
              team: isChallengedByMe ? team.team2 : team.team1));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(children: [
            // CircleAvatar(
            //     backgroundImage: NetworkImage(toImageUrl(team.logo ?? ""))),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isChallengedByMe
                      ? team.team2.name.capitalize
                      : team.team1.name.capitalize,
                  style: const TextStyle(
                      fontSize: 19, fontWeight: FontWeight.bold),
                ),
                // const Text(
                //   '20th April 2021',
                //   style: TextStyle(
                //       fontSize: 13, color: Color.fromARGB(255, 255, 154, 22)),
                // ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                isChallengedByMe
                    ? Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),
                            color: team.status == "Pending"
                                ? AppTheme.darkYellowColor
                                : team.status == "Accepted"
                                    ? Colors.green
                                    : AppTheme.darkYellowColor),
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Text(team.status,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12)),
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(
                  width: 10,
                ),
                team.status == "Accepted"
                    ? const Icon(Icons.arrow_forward_ios)
                    : const SizedBox(),
                const SizedBox(width: 10),
                !isChallengedByMe && team.status == "Pending"
                    ? Row(
                        children: [
                          InkWell(
                            onTap: () {
                              onTap('Accepted');
                            },
                            child: const Chip(
                                label: Text('Accept',
                                    style: TextStyle(color: Colors.white)),
                                backgroundColor: Colors.green,
                                side: BorderSide.none),
                          ),
                          const SizedBox(width: 12),
                          InkWell(
                            onTap: () {
                              onTap('Denied');
                            },
                            child: const Chip(
                                label: Text('Decline',
                                    style: TextStyle(color: Colors.white)),
                                backgroundColor: Colors.red,
                                side: BorderSide.none),
                          ),
                        ],
                      )
                    : const SizedBox()
              ],
            )
          ]),
        ),
      ),
    );
  }
}
