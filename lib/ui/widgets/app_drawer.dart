import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/ui/screens/player_profile_screen.dart';
import 'package:gully_app/ui/screens/select_team_for_challenge.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:share_plus/share_plus.dart';

import '../../config/app_constants.dart';
import '../screens/contact_us_screen.dart';
import '../screens/legal_screen.dart';
import '../screens/looking_for_screen.dart';
import '../screens/organizer_profile.dart';
import '../screens/others_looking_for.dart';
import '../screens/performance_stat_screen.dart';
import '../screens/player_ranking_screen.dart';
import '../screens/select_challenge_match_for_performance.dart';
import '../screens/select_performance_type.dart';
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
                    if (controller.state!.isOrganizer) {
                      Get.to(() => const OrganizerProfileScreen());
                    } else {
                      Get.to(() => const PlayerProfileScreen());
                    }
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
                            child: Obx(() => CircleAvatar(
                                radius: 50,
                                backgroundImage: CachedNetworkImageProvider(
                                    toImageUrl(controller.state?.profilePhoto ??
                                        "")))),
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
                  // title: 'Looking',
                  title: AppConstants.looking,
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
                                AppConstants.what_others_looking_for,
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      )
                    ],
                  ),
                ),
                DrawerCard(
                  title: AppConstants.leaderboard,
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
                            AppConstants.player_ranking,
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
                            // 'Top Performers',
                            AppConstants.top_performers,
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
                            // 'Team Ranking',
                            AppConstants.team_ranking,
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      )
                    ],
                  ),
                ),
                DrawerCard(
                  // title: 'Challenge Team',
                  title: AppConstants.challenge_team,
                  onTap: () {
                    Get.to(() => const SelectTeamForChallenge());
                  },
                  icon: Icons.compare,
                ),
                DrawerCard(
                  // title: 'Challenge Team',
                  title: AppConstants.my_performance,
                  onTap: () {
                    Get.to(() => SelectPerformanceCategory(
                          onChallengeTap: () {
                            Get.to(
                                () => const SelectChallengeMatchForPerformance(
                                    // category: 'challenge',
                                    ));
                          },
                          onTouranmentTap: () {
                            Get.to(() => const PerformanceStatScreen(
                                  category: 'tournaments',
                                ));
                          },
                        ));
                  },
                  icon: Icons.auto_graph,
                ),
                // DrawerCard(
                //   title: "Services",
                //   icon: Icons.search,
                //   child: Column(
                //     children: [
                //       GestureDetector(
                //         onTap: () {
                //           Get.to(() => const ServiceRegister());
                //         },
                //         child: Container(
                //           // width: 200,
                //           height: 30,
                //           decoration: transBg(),
                //           child: const Center(
                //               child: Text(
                //                 'Add My Service',
                //                 style: TextStyle(color: Colors.white),
                //               )),
                //         ),
                //       ),
                //       SizedBox(
                //         width: Get.width * 0.3,
                //         child: Divider(
                //           height: 0,
                //           color: Colors.white.withOpacity(0.3),
                //         ),
                //       ),
                //       InkWell(
                //         onTap: () {
                //           Get.to(() => const RegisterShop());
                //         },
                //         child: Container(
                //           // width: 200,
                //           height: 30,
                //           decoration: transBg(),
                //           child: const Center(
                //               child: Text(
                //                 "Add My Shop",
                //                 style: TextStyle(color: Colors.white),
                //               )),
                //         ),
                //       )
                //     ],
                //   ),
                // ),

                DrawerCard(
                  // title: 'About us',
                  title: AppConstants.about_us,

                  onTap: () {
                    Get.to(() => LegalViewScreen(
                          title: AppConstants.about_us,
                          slug: 'about-us',
                          hideDeleteButton: true,
                        ));
                  },
                  icon: Icons.info,
                ),
                DrawerCard(
                  // title: 'Contact us',
                  title: AppConstants.contact_us,
                  icon: Icons.contact_page,
                  onTap: () {
                    Get.to(() => const ContactUsScreen());
                  },
                ),
                // DrawerCard(
                //   title: 'History',
                //   onTap: () {
                //     Get.to(() => const SelectTeamToViewHistory());
                //   },
                //   icon: Icons.history,
                // ),
                DrawerCard(
                  // title: 'Share App',
                  title: AppConstants.share_app,
                  icon: Icons.share,
                  onTap: () {
                    Share.share(
                        'Inviting you to experience real-time tournament with the Gully Team app – download now!\n Download: https://play.google.com/store/apps/details?id=com.nileegames.gullyteam');
                  },
                ),
                DrawerCard(
                  // title: 'Privacy Policy',
                  title: AppConstants.privacy_policy,
                  onTap: () {
                    Get.to(() => LegalViewScreen(
                          // title: 'Privacy Policy',
                          title: AppConstants.privacy_policy,
                          slug: 'privacy-policy',
                        ));
                  },
                  icon: Icons.privacy_tip,
                ),
                DrawerCard(
                  // title: 'FAQs',
                  title: AppConstants.faqs,
                  onTap: () {
                    Get.to(() => const LegalViewScreen(
                          // title: 'FAQs',
                          hideDeleteButton: true,
                          title: AppConstants.faqs,
                          slug: 'faq',
                        ));
                  },
                  icon: Icons.question_answer,
                ),
                // DrawerCard(
                //   title: 'Rate us',
                //   onTap: () {
                //     Get.to(() => const RateUsScreen());
                //   },
                //   icon: Icons.rate_review,
                // ),
                DrawerCard(
                  // title: 'Disclaimer',
                  title: "Disclaimer",
                  onTap: () {
                    Get.to(() => LegalViewScreen(
                          // title: 'Disclaimer',

                          title: "Disclaimer",
                          slug: 'disclaimer',
                          hideDeleteButton: true,
                        ));
                  },
                  icon: Icons.disc_full,
                ),
                // DrawerCard(
                //   // title: 'Disclaimer',
                //   title: AppConstants.changeLanguage,
                //   onTap: () {
                //     Get.to(() => const ChooseLanguageScreen(
                //         // title: 'Disclaimer',
                //
                //         ));
                //   },
                //   icon: Icons.language,
                // ),
                DrawerCard(
                  // title: 'Log out',
                  title: AppConstants.logout,
                  onTap: () async {
                    controller.logout();
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
