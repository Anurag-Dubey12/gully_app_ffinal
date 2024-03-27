import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/team_controller.dart';
import 'package:gully_app/data/model/team_model.dart';
import 'package:gully_app/ui/screens/add_player_to_team.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/utils.dart';

import 'team_entry_form.dart';

class SelectTeamToRegister extends StatefulWidget {
  const SelectTeamToRegister({
    super.key,
  });

  @override
  State<SelectTeamToRegister> createState() => _SelectTeamToRegisterState();
}

class _SelectTeamToRegisterState extends State<SelectTeamToRegister> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TeamController>();
    controller.getTeams();
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
                  'Select your Team',
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
                      future: controller.getTeams(),
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
                            child: Text('No teams created yet',
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
    return Container(
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
                style:
                    const TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
              ),
            ),
            const Spacer(),
            if (team.playersCount! < 14)
              Row(
                children: [
                  Text('(${team.playersCount!}/15)',
                      style: const TextStyle(fontSize: 13)),
                  const SizedBox(
                    width: 10,
                  ),
                  Material(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(09),
                      onTap: () {
                        Get.off(() => AddPlayersToTeam(
                              team: team,
                            ));
                      },
                      child: Ink(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(09),
                            color: AppTheme.secondaryYellowColor,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          )),
                    ),
                  )
                ],
              ),
            const SizedBox(
              width: 10,
            ),
            if (team.playersCount! >= 10)
              Material(
                child: InkWell(
                  borderRadius: BorderRadius.circular(09),
                  onTap: () async {
                    logger.i('Team selected ${team.name}');
                    Get.to(() => TeamEntryForm(
                          team: team,
                        ));
                  },
                  child: Ink(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(09),
                        // color: AppTheme.secondaryYellowColor,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        // color: Colors.white,
                      )),
                ),
              )
          ],
        ),
      ),
    );
  }
}
