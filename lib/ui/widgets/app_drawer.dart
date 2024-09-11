import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import 'package:get/get.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/ui/screens/choose_lang_screen.dart';
import 'package:gully_app/ui/screens/player_profile_screen.dart';
import 'package:gully_app/ui/screens/select_performance_type.dart';
import 'package:gully_app/ui/screens/select_team_for_challenge.dart';
import 'package:gully_app/ui/screens/service/service_screen.dart';
import 'package:gully_app/ui/screens/shop/shop_home.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:iconsax/iconsax.dart';
import 'package:share_plus/share_plus.dart';

import '../screens/contact_us_screen.dart';
import '../screens/legal_screen.dart';
import '../screens/looking_for_screen.dart';
import '../screens/organizer_profile.dart';
import '../screens/others_looking_for.dart';
import '../screens/performance_stat_screen.dart';
import '../screens/player_ranking_screen.dart';
import '../screens/select_challenge_match_for_performance.dart';
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
                  title: AppLocalizations.of(context)!.looking,
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
                          child: Center(
                              child: Text(
                            AppLocalizations.of(context)!
                                .what_others_looking_for,
                            style: const TextStyle(color: Colors.white),
                          )),
                        ),
                      )
                    ],
                  ),
                ),
                DrawerCard(
                  title: AppLocalizations.of(context)!.leaderboard,
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
                          child: Center(
                              child: Text(
                            AppLocalizations.of(context)!.player_ranking,
                            style: const TextStyle(color: Colors.white),
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
                          child: Center(
                              child: Text(
                            // 'Top Performers',
                            AppLocalizations.of(context)!.top_performers,
                            style: const TextStyle(color: Colors.white),
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
                          child: Center(
                              child: Text(
                            // 'Team Ranking',
                            AppLocalizations.of(context)!.team_ranking,
                            style: const TextStyle(color: Colors.white),
                          )),
                        ),
                      )
                    ],
                  ),
                ),
                DrawerCard(
                  // title: 'Challenge Team',
                  title: AppLocalizations.of(context)!.challenge_team,
                  onTap: () {
                    Get.to(() => const SelectTeamForChallenge());
                  },
                  icon: Icons.compare,
                ),
                // DrawerCard(
                //   // title: 'Challenge Team',
                //   title: AppLocalizations.of(context)!.my_performance,
                //   onTap: () {
                //     Get.to(() => SelectPerformanceCategory(
                //           onChallengeTap: () {
                //             Get.to(
                //                 () => const SelectChallengeMatchForPerformance(
                //                     // category: 'challenge',
                //                     ));
                //           },
                //           onTouranmentTap: () {
                //             Get.to(() => const PerformanceStatScreen(
                //                   category: 'tournaments',
                //                 ));
                //           },
                //         ));
                //   },
                //   icon: Icons.auto_graph,
                // ),

                DrawerCard(
                  // title: 'About us',
                  title: 'Shop',
                  onTap: () {
                    Get.to(() => const ShopHome());
                  },
                  icon: Iconsax.shop,
                ),

                DrawerCard(
                  // title: 'About us',
                  title: 'Service',
                  onTap: () {
                    Get.to(() => const ServiceScreen());
                  },
                  icon: Icons.sports_cricket_rounded,
                ),
                DrawerCard(
                  // title: 'About us',
                  title: AppLocalizations.of(context)!.about_us,

                  onTap: () {
                    Get.to(() => LegalViewScreen(
                          title: AppLocalizations.of(context)!.about_us,
                          slug: 'about-us',
                          hideDeleteButton: true,
                        ));
                  },
                  icon: Icons.info,
                ),
                DrawerCard(
                  // title: 'Contact us',
                  title: AppLocalizations.of(context)!.contact_us,
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
                  title: AppLocalizations.of(context)!.share_app,
                  icon: Icons.share,
                  onTap: () {
                    Share.share(
                        'Inviting you to experience real-time tournament with the Gully Team app – download now!\n Download: https://play.google.com/store/apps/details?id=com.nileegames.gullyteam');
                  },
                ),
                DrawerCard(
                  // title: 'Privacy Policy',
                  title: AppLocalizations.of(context)!.privacy_policy,
                  onTap: () {
                    Get.to(() => LegalViewScreen(
                          // title: 'Privacy Policy',
                          title: AppLocalizations.of(context)!.privacy_policy,
                          slug: 'privacy-policy',
                        ));
                  },
                  icon: Icons.privacy_tip,
                ),
                DrawerCard(
                  // title: 'FAQs',
                  title: AppLocalizations.of(context)!.faqs,
                  onTap: () {
                    Get.to(() => LegalViewScreen(
                          // title: 'FAQs',
                          hideDeleteButton: true,
                          title: AppLocalizations.of(context)!.faqs,
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
                  title: AppLocalizations.of(context)!.disclaimer,
                  onTap: () {
                    Get.to(() => LegalViewScreen(
                          // title: 'Disclaimer',

                          title: AppLocalizations.of(context)!.disclaimer,
                          slug: 'disclaimer',
                          hideDeleteButton: true,
                        ));
                  },
                  icon: Icons.disc_full,
                ),
                DrawerCard(
                  // title: 'Disclaimer',
                  title: AppLocalizations.of(context)!.changeLanguage,
                  onTap: () {
                    Get.to(() => const ChooseLanguageScreen(
                        // title: 'Disclaimer',

                        ));
                  },
                  icon: Icons.language,
                ),
                DrawerCard(
                  // title: 'Log out',
                  title: AppLocalizations.of(context)!.logout,
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
