import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/team_controller.dart';
import 'package:gully_app/data/model/opponent_model.dart';
import 'package:gully_app/data/model/team_model.dart';
import 'package:gully_app/ui/screens/view_opponent_team.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/utils/utils.dart';

class ViewOpponentTeamList extends StatefulWidget {
  final OpponentModel opponent;
  const ViewOpponentTeamList({
    super.key,
    required this.opponent,
  });

  @override
  State<ViewOpponentTeamList> createState() => _ViewOpponentTeamListState();
}

class _ViewOpponentTeamListState extends State<ViewOpponentTeamList> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeamController>();
    // controller.getTeams();
    return DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage('assets/images/sports_icon.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: GradientBuilder(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text(
                  'Opponent Teams',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: const BackButton(
                  color: Colors.white,
                )),
            body: Container(
              width: Get.width,
              // height: Get.height * 0.54,
              margin: const EdgeInsets.only(top: 10),
              color: Colors.black26,
              child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: FutureBuilder<List<TeamModel>>(
                      future: controller.getOpponentTeamList(
                          widget.opponent.tournamentId, widget.opponent.teamId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error ${snapshot.error}}'),
                          );
                        }
                        if (snapshot.data?.isEmpty ?? true) {
                          return const Center(
                            child: Text('No Teams found',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold)),
                          );
                        }
                        return ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 10,
                                ),
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              return _TeamCard(
                                team: snapshot.data![index],
                              );
                            });
                      })),
            ),
          ),
        ));
  }
}

class _TeamCard extends StatelessWidget {
  final TeamModel team;
  const _TeamCard({
    required this.team,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => ViewOpponentTeam(
            team: team,
          )),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(toImageUrl(team.logo ?? '')),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: Get.width / 3,
                child: Text(
                  team.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 19, fontWeight: FontWeight.w500),
                ),
              ),
              const Spacer(),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
