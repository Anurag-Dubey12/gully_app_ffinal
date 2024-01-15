import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/config/preferences.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/ui/screens/splash_screen.dart';

import '../screens/contact_us_screen.dart';
import '../screens/legal_screen.dart';
import '../screens/looking_for_screen.dart';
import '../screens/organizer_profile.dart';
import '../screens/others_looking_for.dart';
import '../screens/player_ranking_screen.dart';
import '../screens/rate_us.dart';
import '../screens/select_team_to_view_history.dart';
import '../screens/team_ranking_screen.dart';
import '../screens/top_performers.dart';
import 'home_screen/drawer_card.dart';

class AppDrawer extends GetView<AuthController> {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 75, 76, 103),
              Color(0xff272857),
              Color(0xff33345e),
              Color(0xff33345e),
            ],
            stops: [0.1, 0.3, 0.8, 1],
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Get.bottomBarHeight / 2),
                InkWell(
                  onTap: () {
                    Get.to(() => const OrganizerProfileScreen());
                  },
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 142, 133, 133),
                                  width: 2)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                                radius: 50,
                                backgroundImage: CachedNetworkImageProvider(
                                    controller.state?.toImageUrl())),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          controller.state!.fullName,
                          style: Get.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 22),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          controller.state!.email,
                          style: Get.textTheme.labelMedium?.copyWith(
                              color: const Color.fromARGB(255, 200, 189, 189),
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
                DrawerCard(
                  title: 'Looking',
                  icon: Icons.search,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const LookingForScreen());
                        },
                        child: Container(
                          // width: 200,
                          height: 30,
                          decoration: transBg(),
                          child: const Center(
                              child: Text(
                            'What i am looking for',
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.3,
                        child: Divider(
                          height: 0,
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => const OthersLookingForScreen());
                        },
                        child: Container(
                          // width: 200,
                          height: 30,
                          decoration: transBg(),
                          child: const Center(
                              child: Text(
                            'What others are looking for',
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      )
                    ],
                  ),
                ),
                DrawerCard(
                  title: 'Leaderboard',
                  icon: Icons.leaderboard_outlined,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(() => const PlayerRankingScreen());
                        },
                        child: Container(
                          // width: 200,
                          height: 30,
                          decoration: transBg(),
                          child: const Center(
                              child: Text(
                            'Player Ranking',
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.3,
                        child: Divider(
                          height: 0,
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => const TopPerformersScreen());
                        },
                        child: Container(
                          // width: 200,
                          height: 30,
                          decoration: transBg(),
                          child: const Center(
                              child: Text(
                            'Top Performers',
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.3,
                        child: Divider(
                          height: 0,
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => const TeamRankingScreen());
                        },
                        child: Container(
                          // width: 200,
                          height: 30,
                          decoration: transBg(),
                          child: const Center(
                              child: Text(
                            'Team Ranking',
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      )
                    ],
                  ),
                ),
                // DrawerCard(
                //   title: 'Challenge Team',
                //   onTap: () {
                //     Get.to(() => const ChallengeTeam());
                //   },
                //   icon: Icons.compare,
                // ),
                DrawerCard(
                  title: 'About us',
                  onTap: () {
                    Get.to(() => const LegalViewScreen(
                          title: 'About us',
                          slug: 'about-us',
                        ));
                  },
                  icon: Icons.info,
                ),
                DrawerCard(
                  title: 'Contact us',
                  icon: Icons.contact_page,
                  onTap: () {
                    Get.to(() => const ContactUsScreen());
                  },
                ),
                DrawerCard(
                  title: 'History',
                  onTap: () {
                    Get.to(() => const SelectTeamToViewHistory());
                  },
                  icon: Icons.history,
                ),
                const DrawerCard(
                  title: 'Share App',
                  icon: Icons.share,
                ),
                DrawerCard(
                  title: 'Privacy Policy',
                  onTap: () {
                    Get.to(() => const LegalViewScreen(
                          title: 'Privacy Policy',
                          slug: 'privacy-policy',
                        ));
                  },
                  icon: Icons.privacy_tip,
                ),
                DrawerCard(
                  title: 'FAQs',
                  onTap: () {
                    Get.to(() => const LegalViewScreen(
                          title: 'FAQs',
                          slug: 'faqs',
                        ));
                  },
                  icon: Icons.question_answer,
                ),
                DrawerCard(
                  title: 'Rate us',
                  onTap: () {
                    Get.to(() => const RateUsScreen());
                  },
                  icon: Icons.rate_review,
                ),
                DrawerCard(
                  title: 'Disclaimer',
                  onTap: () {
                    Get.to(() => const LegalViewScreen(
                          title: 'Disclaimer',
                          slug: 'disclaimer',
                        ));
                  },
                  icon: Icons.disc_full,
                ),
                DrawerCard(
                  title: 'Log out',
                  onTap: () {
                    final controller = Get.find<Preferences>();
                    controller.clear();
                    Get.offAll(() => const SplashScreen());
                    // Get.to(() => const LegalViewScreen());
                  },
                  icon: Icons.logout,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration transBg() {
    return const BoxDecoration(
        gradient: LinearGradient(
      colors: [
        Color.fromARGB(10, 235, 234, 234),
        Color.fromARGB(48, 255, 255, 255),
        Color.fromARGB(42, 255, 255, 255),
        Color.fromARGB(10, 235, 234, 234),
      ],
      // stops: [0, 0.5, 1],
    ));
  }
}
