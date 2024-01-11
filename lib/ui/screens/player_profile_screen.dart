import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/ui/screens/add_team.dart';
import 'package:gully_app/ui/screens/my_teams.dart';
import 'package:gully_app/ui/screens/select_team_to_view_history.dart';
import 'package:gully_app/ui/screens/view_opponent_team.dart';
import 'package:gully_app/ui/theme/theme.dart';

class PlayerProfileScreen extends GetView<AuthController> {
  const PlayerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage(
                'assets/images/sports_icon.png',
              ),
              fit: BoxFit.cover),
        ),
        child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff3F5BBF), Colors.white24, Colors.white24],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(children: [
                AppBar(
                  iconTheme: const IconThemeData(color: Colors.white),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: const Text(
                    'Profile',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.w800),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1)),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            image: DecorationImage(
                                image: NetworkImage(
                                    controller.user.value.toImageUrl()),
                                fit: BoxFit.cover))),

                    // backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Text(
                      controller.user.value.fullName,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey[900]),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.mail,
                          color: Colors.grey[900],
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          controller.user.value.email,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey[800]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.grey[900],
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '304/c, S.V. Road, Kandivali East',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey[800]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.phone,
                          color: Colors.grey[900],
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          controller.user.value.phoneNumber ?? "",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey[800]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.black26),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ProfileTileCard(
                              text: 'Add team',
                              onTap: () {
                                Get.to(() => const AddTeam());
                              },
                            ),
                            ProfileTileCard(
                              text: 'View My Team',
                              onTap: () {
                                Get.off(() => const MyTeams());
                              },
                            ),
                            ProfileTileCard(
                              text: 'My performance',
                              onTap: () {
                                Get.to(() => const SelectTeamToViewHistory());
                              },
                            ),
                            ProfileTileCard(
                              text: 'View Opponent',
                              onTap: () {
                                Get.to(() => const ViewOpponentTeam());
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ]),
            )));
  }
}

class ProfileTileCard extends StatelessWidget {
  final String text;
  final Widget? subTrailingWidget;
  final Function? onTap;
  const ProfileTileCard({
    super.key,
    required this.text,
    this.subTrailingWidget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap == null ? () {} : () => onTap!(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.secondaryYellowColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Text(text, style: Get.textTheme.bodyLarge),
              const Spacer(),
              subTrailingWidget ?? const SizedBox(),
              const Icon(
                Icons.arrow_forward_ios,
                size: 19,
                color: AppTheme.secondaryYellowColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
