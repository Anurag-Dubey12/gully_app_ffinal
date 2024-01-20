import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/ui/screens/current_tournament_list.dart';
import 'package:gully_app/ui/screens/tournament_requests_screen.dart';
import 'package:gully_app/ui/screens/view_tournaments_screen.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/utils/utils.dart';

class OrganizerProfileScreen extends GetView<AuthController> {
  const OrganizerProfileScreen({super.key});

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
                                image: CachedNetworkImageProvider(toImageUrl(
                                    controller.state!.profilePhoto!)),
                                fit: BoxFit.cover))),

                    // backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => Column(
                    children: [
                      Text(
                        controller.state!.captializedName,
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
                            controller.state!.email,
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
                          SizedBox(
                            width: Get.width * 0.5,
                            child: Obx(() => Text(
                                  controller.location.value,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.grey[800]),
                                )),
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
                            controller.state!.phoneNumber ?? "",
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
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.black26),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            InkWell(
                              child: ProfileTileCard(
                                onTap: () {
                                  Get.to(() => const TournamentRequestScreen());
                                },
                                text: 'Request',
                              ),
                            ),
                            ProfileTileCard(
                              text: 'Current Tournament',
                              onTap: () {
                                Get.to(() => const CurrentTournamentListScreen(
                                      redirectType:
                                          RedirectType.currentTournament,
                                    ));
                              },
                            ),
                            ProfileTileCard(
                              text: 'Organize',
                              onTap: () {
                                Get.to(() => const CurrentTournamentListScreen(
                                      redirectType: RedirectType.organizeMatch,
                                    ));
                              },
                            ),
                            ProfileTileCard(
                              text: 'View Matchups',
                              onTap: () {
                                Get.to(() => const CurrentTournamentListScreen(
                                      redirectType: RedirectType.matchup,
                                    ));
                              },
                            ),
                            ProfileTileCard(
                              text: 'Score Board',
                              onTap: () {
                                Get.to(() => const CurrentTournamentListScreen(
                                      redirectType: RedirectType.scoreboard,
                                    ));
                              },
                            ),
                            ProfileTileCard(
                              text: 'Edit Tournament Form',
                              onTap: () {
                                // Get.to(() => const EditTournamentScreen());

                                Get.to(() => const CurrentTournamentListScreen(
                                      redirectType: RedirectType.editForm,
                                    ));
                              },
                            ),
                            // ProfileTileCard(
                            //   text: 'Transaction History',
                            //   onTap: () {
                            //     Get.to(() => const TxnHistoryScreen());
                            //   },
                            // ),
                            ProfileTileCard(
                              text: 'View your tournament',
                              onTap: () {
                                Get.to(() => const ViewTournamentScreen());
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
