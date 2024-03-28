import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/screens/add_team.dart';
import 'package:gully_app/ui/screens/select_team_to_register.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';

import 'add_player_to_team.dart';

class RegisterTeam extends StatefulWidget {
  const RegisterTeam({super.key});

  @override
  State<RegisterTeam> createState() => _RegisterTeamState();
}

class _RegisterTeamState extends State<RegisterTeam> {
  @override
  Widget build(BuildContext context) {
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
                  'Register Team',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: const BackButton(
                  color: Colors.white,
                )),
            body: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  _Card(
                    title: 'Select Team',
                    onTap: () {
                      Get.to(() => SelectTeamToRegister(
                            onTeamSelected: (team) {
                              Get.off(() => AddPlayersToTeam(
                                    team: team,
                                  ));
                            },
                          ));
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _Card(
                    title: 'Create Team',
                    onTap: () {
                      Get.to(() => const AddTeam());
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class _Card extends StatelessWidget {
  final String title;
  final Function onTap;
  const _Card({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap.call(),
      child: Ink(
        width: Get.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1, color: AppTheme.secondaryYellowColor)),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              Text(
                title,
              ),
              const Spacer(),

              /// forwad icon
              const Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.secondaryYellowColor,
                size: 18,
              )
            ],
          ),
        ),
      ),
    );
  }
}
