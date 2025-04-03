import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../data/controller/team_controller.dart';
import '../../data/model/challenge_match.dart';
import '../../data/model/team_model.dart';
import 'package:gully_app/ui/screens/view_opponent_team.dart';
import 'package:gully_app/utils/FallbackImageProvider.dart';
import 'package:gully_app/utils/utils.dart';

import '../../config/app_constants.dart';
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
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          // 'Challenge team',
                          AppConstants.challengeTeamTitle,
                          style: TextStyle(
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
                        maxLength: 50,
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
                          if (e.isNotEmpty) {
                            if (!RegExp(r'^[a-zA-Z0-9]*$').hasMatch(e)) {
                              searchValue.text = searchValue.text
                                  .substring(0, searchValue.text.length - 1);
                            }
                          }
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          counter: const SizedBox(),
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
                                            // if (snapshot.hasError) {
                                            //   return Center(
                                            //       child: TextButton(
                                            //           onPressed: () {
                                            //             teamController
                                            //                 .getChallengeMatch();
                                            //           },
                                            //           child: Text(
                                            //               'Error: ${snapshot.error}')));
                                            // }
                                            if (snapshot.hasError) {
                                              return Center(
                                                  child: TextButton(
                                                      onPressed: () {
                                                        teamController
                                                            .getChallengeMatch();
                                                      },
                                                      child: const Text(
                                                          'No Data Found')));
                                            }
                                            final filteredMatches =
                                                (snapshot.data ?? [])
                                                    .where((e) =>
                                                        e.status != "played")
                                                    .toList();

                                            return ListView.separated(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) =>
                                                  StatefulBuilder(
                                                builder: (c, s) => _Challenges(
                                                  team: filteredMatches[index],
                                                  isChallengedByMe:
                                                      authController
                                                              .state?.id ==
                                                          filteredMatches[index]
                                                              .challengedBy,
                                                  onTap: (status) async {
                                                    await teamController
                                                        .updateChallengeMatch(
                                                            matchId:
                                                                filteredMatches[
                                                                        index]
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
                                              itemCount: filteredMatches.length,
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
                                                    successSnackBar(AppConstants
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
                                              itemCount: filteredTeams.length,
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
  const _TeamCard({required this.team, required this.onTap});

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
              backgroundImage: FallbackImageProvider(
                  toImageUrl(team.logo ?? ""), "assets/images/logo.png")),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 150,
                child: Text(
                  team.name.capitalize,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 19, fontWeight: FontWeight.bold),
                ),
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
                SizedBox(
                  width: 150,
                  child: Text(
                    isChallengedByMe
                        ? team.team2.name.capitalize
                        : team.team1.name.capitalize,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
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
                isChallengedByMe && team.status == "Pending"
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
                  width: 1,
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
                                padding: EdgeInsets.zero,
                                label: Text('Accept',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 11)),
                                backgroundColor: Colors.green,
                                side: BorderSide.none),
                          ),
                          const SizedBox(width: 12),
                          InkWell(
                            onTap: () {
                              onTap('Denied');
                            },
                            child: const Chip(
                                padding: EdgeInsets.zero,
                                label: Text('Decline',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 11)),
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
