import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/src/ui/screens/challenge_team.dart';
import 'package:gully_app/src/ui/screens/contact_us_screen.dart';
import 'package:gully_app/src/ui/screens/create_tournament_form_screen.dart';
import 'package:gully_app/src/ui/screens/leaderboard_screen.dart';
import 'package:gully_app/src/ui/screens/legal_screen.dart';
import 'package:gully_app/src/ui/screens/looking_for_screen.dart';
import 'package:gully_app/src/ui/screens/notification_screen.dart';
import 'package:gully_app/src/ui/screens/others_looking_for.dart';
import 'package:gully_app/src/ui/screens/player_performance.dart';
import 'package:gully_app/src/ui/screens/player_ranking_screen.dart';
import 'package:gully_app/src/ui/screens/profile_screen.dart';
import 'package:gully_app/src/ui/screens/rate_us.dart';
import 'package:gully_app/src/ui/screens/register_team.dart';
import 'package:gully_app/src/ui/screens/select_team_to_view_history.dart';
import 'package:gully_app/src/ui/screens/team_ranking_screen.dart';
import 'package:gully_app/src/ui/screens/top_performers.dart';
import 'package:gully_app/src/ui/theme/theme.dart';
import 'package:gully_app/src/ui/widgets/primary_button.dart';

import '../widgets/arc_clipper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedDate = 0;
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
      child: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          drawer: Drawer(
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
                          Get.to(() => const ProfileScreen());
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DecoratedBox(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.transparent,
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 142, 133, 133),
                                      width: 2)),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(
                                      'https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80'),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Bhavesh Pant',
                              style: Get.textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 22),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'bhavesh.pant@nileegames.com',
                              style: Get.textTheme.labelMedium?.copyWith(
                                  color:
                                      const Color.fromARGB(255, 200, 189, 189),
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      _DrawerCard(
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
                      _DrawerCard(
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
                      _DrawerCard(
                        title: 'Challenge Team',
                        onTap: () {
                          Get.to(() => const ChallengeTeam());
                        },
                        icon: Icons.compare,
                      ),
                      _DrawerCard(
                        title: 'About us',
                        onTap: () {
                          Get.to(() => const ContactUsScreen());
                        },
                        icon: Icons.info,
                      ),
                      _DrawerCard(
                        title: 'Contact us',
                        icon: Icons.contact_page,
                        onTap: () {
                          Get.to(() => const ContactUsScreen());
                        },
                      ),
                      _DrawerCard(
                        title: 'History',
                        onTap: () {
                          Get.to(() => const SelectTeamToViewHistory());
                        },
                        icon: Icons.history,
                      ),
                      const _DrawerCard(
                        title: 'Share App',
                        icon: Icons.share,
                      ),
                      _DrawerCard(
                        title: 'Privacy Policy',
                        onTap: () {
                          Get.to(() => const LegalViewScreen());
                        },
                        icon: Icons.privacy_tip,
                      ),
                      _DrawerCard(
                        title: 'FAQs',
                        onTap: () {
                          Get.to(() => const LegalViewScreen());
                        },
                        icon: Icons.question_answer,
                      ),
                      _DrawerCard(
                        title: 'Rate us',
                        onTap: () {
                          Get.to(() => const RateUsScreen());
                        },
                        icon: Icons.rate_review,
                      ),
                      _DrawerCard(
                        title: 'Disclaimer',
                        onTap: () {
                          Get.to(() => const LegalViewScreen());
                        },
                        icon: Icons.disc_full,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: 90,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: const Offset(0, -1))
            ]),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(19.0),
                  child: PrimaryButton(
                    onTap: () {
                      Get.to(() => const CreateTournamentScreen());
                    },
                    title: 'Create Your Tournament',
                  ),
                ),
              ],
            ),
          ),
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
                top: Get.statusBarHeight / 2.3,
                // left: 20,
                child: SizedBox(
                  // color: Colors.red,
                  width: Get.width,

                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: _TopHeader(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: Get.height * 0.10,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return SportsCard(
                                index: index,
                              );
                            },
                            padding: const EdgeInsets.only(left: 20),
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  width: 15,
                                ),
                            itemCount: 7),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: Get.height * 0.05,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedDate = index;
                                    });
                                  },
                                  child: TimeCard(
                                    isSelected: selectedDate == index,
                                    title: '10 July',
                                  ),
                                );
                              } else if (index == 1) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedDate = index;
                                    });
                                  },
                                  child: TimeCard(
                                    isSelected: selectedDate == index,
                                    title: 'Today',
                                  ),
                                );
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedDate = index;
                                    });
                                  },
                                  child: TimeCard(
                                    isSelected: selectedDate == index,
                                    title: '${index + 10} July',
                                  ),
                                );
                              }
                            },
                            padding: const EdgeInsets.only(left: 20),
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  width: 0,
                                ),
                            itemCount: 7),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                          child: Text(
                            'Tournaments',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                        ),
                      ),
                      Container(
                        width: Get.width,
                        height: Get.height * 0.54,
                        margin: const EdgeInsets.only(top: 10),
                        color: Colors.black26,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ...List.generate(
                                  3,
                                  (index) => selectedDate == 0
                                      ? const PastTournamentMatchCard()
                                      : selectedDate == 1
                                          ? const CurrentTournamentCard()
                                          : const FutureTournamentCard())
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
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

class _DrawerCard extends StatefulWidget {
  final String title;
  final Widget? child;
  final IconData icon;
  final Function? onTap;
  const _DrawerCard({
    required this.title,
    this.child,
    required this.icon,
    this.onTap,
  });

  @override
  State<_DrawerCard> createState() => _DrawerCardState();
}

class _DrawerCardState extends State<_DrawerCard> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      key: Key(widget.title),
      children: [
        ListTile(
          onTap: () {
            if (widget.child == null) {
              widget.onTap!();
            } else {
              setState(() {
                isExpanded = !isExpanded;
              });
            }
          },
          contentPadding: EdgeInsets.zero,
          leading: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: AppTheme.secondaryYellowColor,
            ),
            child: Icon(widget.icon, color: Colors.white, size: 26),
          ),
          title: Row(
            children: [
              Text(
                widget.title,
                style: Get.textTheme.labelMedium?.copyWith(
                    color: const Color.fromARGB(255, 244, 244, 244),
                    fontWeight: FontWeight.w400,
                    fontSize: 16),
              ),
              const Spacer(),
              if (widget.child != null)
                const RotatedBox(
                    quarterTurns: 3,
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 15,
                      color: Colors.white,
                    ))
            ],
          ),
          minVerticalPadding: 10,
        ),
        isExpanded ? widget.child! : const SizedBox()
      ],
    );
  }
}

class FutureTournamentCard extends StatelessWidget {
  const FutureTournamentCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          image: const DecorationImage(
              image: AssetImage(
                'assets/images/cricket_bat.png',
              ),
              alignment: Alignment.bottomLeft,
              scale: 1),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(0, 1))
          ],
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            const SizedBox(height: 7),
            Text(
              'Premier League | Cricket Tournament',
              style: Get.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppTheme.darkYellowColor),
            ),
            const SizedBox(height: 7),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date: 04 July 2023',
                    style: Get.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'Time Left: 5d:13h:5m:23s',
                    style: Get.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 17),
            Padding(
              padding: const EdgeInsets.only(right: 28),
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 34,
                  width: 100,
                  child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => const RegisterTeam());
                      },
                      style: ButtonStyle(
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(6)),
                      ),
                      child: Text('Join Now',
                          style: Get.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              color: Colors.white))),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Text(
                        'Team: 7/10',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.info_outline_rounded,
                          color: Colors.grey, size: 18)
                    ],
                  ),
                  Text(
                    'Entry Fees: ₹900/-',
                    style: Get.textTheme.labelMedium,
                  )
                ],
              ),
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}

class CurrentTournamentCard extends StatelessWidget {
  const CurrentTournamentCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          image: const DecorationImage(
              image: AssetImage(
                'assets/images/cricket_bat.png',
              ),
              alignment: Alignment.bottomLeft,
              scale: 1),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(0, 1))
          ],
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            const SizedBox(height: 7),
            Text(
              'Premier League | Cricket Tournament',
              style: Get.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppTheme.darkYellowColor),
            ),
            const SizedBox(height: 7),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date: 04 July 2023',
                    style: Get.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'Time Left: 5d:13h:5m:23s',
                    style: Get.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 17),
            Padding(
              padding: const EdgeInsets.only(right: 28),
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 34,
                  width: 100,
                  child: ElevatedButton(
                      onPressed: () {
                        Get.bottomSheet(const ScoreBottomDialog());
                      },
                      style: ButtonStyle(
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(6)),
                      ),
                      child: Text('View Score',
                          style: Get.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              color: Colors.white))),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class PastTournamentMatchCard extends StatelessWidget {
  const PastTournamentMatchCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(0, 1))
          ],
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            const SizedBox(height: 7),
            Text(
              'Premier League | Cricket Tournament',
              style: Get.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppTheme.darkYellowColor),
            ),
            const SizedBox(height: 7),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 28),
              child: Text(
                'Date: 04 July 2023',
                style: Get.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 28),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(),
                          const SizedBox(width: 15),
                          Text('RCB',
                              style: Get.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18,
                              ))
                        ],
                      ),
                      const Text('216/8')
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(),
                          const SizedBox(width: 15),
                          Text('MI',
                              style: Get.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18,
                              ))
                        ],
                      ),
                      const Text('216/8')
                    ],
                  ),
                ],
              ),
            ),
            Text(
              'Mi won by 5 wickets',
              style: Get.textTheme.headlineMedium?.copyWith(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 17),
          ],
        ),
      ),
    );
  }
}

class ScoreBottomDialog extends StatelessWidget {
  const ScoreBottomDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: () {},
        builder: (context) => Container(
              width: Get.width,
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 7,
                        width: 120,
                        decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Text(
                          'Season Tournament',
                          style: Get.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 23,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 225, 222, 236),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        const CircleAvatar(
                                          radius: 28,
                                        ),
                                        Text(
                                          'Team A',
                                          style: Get.textTheme.headlineMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text('20/2',
                                        style: Get.textTheme.headlineMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                          fontSize: 28,
                                        )),
                                    Column(
                                      children: [
                                        const CircleAvatar(
                                          radius: 28,
                                        ),
                                        Text(
                                          'Team B',
                                          style: Get.textTheme.headlineMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Center(
                                  child: Column(children: [
                                    Text('Over: 2.2(18)'),
                                    Text('To win: 230'),
                                  ]),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }
}

class TimeCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  const TimeCard({
    super.key,
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 90,
        // height: 8,
        decoration: BoxDecoration(
            color: isSelected ? AppTheme.secondaryYellowColor : Colors.white,
            boxShadow: [
              BoxShadow(
                  color: isSelected
                      ? AppTheme.secondaryYellowColor.withOpacity(0.1)
                      : Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: const Offset(0, 1))
            ],
            borderRadius: BorderRadius.circular(20)),
        child: Center(
            child: Text(
          title,
          style: Get.textTheme.labelMedium?.copyWith(
            color: isSelected ? Colors.white : Colors.black,
          ),
        )),
      ),
    );
  }
}

class SportsCard extends StatelessWidget {
  final int index;
  const SportsCard({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        decoration: BoxDecoration(
          color: index == 0 ? const Color(0xffDD6F50) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
                color: index == 0
                    ? AppTheme.secondaryYellowColor.withOpacity(0.3)
                    : Colors.black12,
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(0, 1))
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/cricket_icon.png',
                height: 45,
                color: index == 0 ? Colors.white : Colors.grey.shade400,
                width: 45,
              ),
              const SizedBox(height: 5),
              Text(
                'Cricket',
                style: TextStyle(
                    color: index == 0 ? Colors.white : Colors.grey,
                    fontSize: 14),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  const _TopHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bhavesh Pant',
                  style: Get.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 24,
                      fontStyle: FontStyle.italic),
                ),
                Text('Select Location',
                    style: Get.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white)),
              ],
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 30,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.notifications,
                  size: 23,
                ),
                onPressed: () {
                  Get.to(() => const NotificationScreen());
                },
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 30,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.menu,
                  size: 23,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                color: Colors.white,
              ),
            ),
          ],
        )
      ],
    );
  }
}
