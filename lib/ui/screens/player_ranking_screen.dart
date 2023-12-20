import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/screens/challenge_team.dart';

import '../theme/theme.dart';
import '../widgets/arc_clipper.dart';

class PlayerRankingScreen extends StatelessWidget {
  const PlayerRankingScreen({super.key});

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
                  top: 0,
                  child: SizedBox(
                    width: Get.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 30, top: 30),
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
                              'Player Ranking',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: AppTheme.secondaryYellowColor,
                                    boxShadow: [
                                      BoxShadow(
                                          color: AppTheme.secondaryYellowColor
                                              .withOpacity(0.3),
                                          blurRadius: 20,
                                          spreadRadius: 2,
                                          offset: const Offset(0, 7))
                                    ],
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Text('Leather ball',
                                          style: Get.textTheme.bodyLarge
                                              ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(40),
                                    boxShadow: [
                                      BoxShadow(
                                          color: const Color.fromARGB(
                                                  121, 187, 186, 186)
                                              .withOpacity(0.9),
                                          blurRadius: 20,
                                          spreadRadius: 2,
                                          offset: const Offset(0, 7))
                                    ],
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Text('Tennis Ball',
                                          style: Get.textTheme.bodyLarge
                                              ?.copyWith(
                                                  color: AppTheme.primaryColor,
                                                  fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: AppTheme.secondaryYellowColor,
                                    boxShadow: [
                                      BoxShadow(
                                          color: AppTheme.secondaryYellowColor
                                              .withOpacity(0.4),
                                          blurRadius: 10,
                                          spreadRadius: 1,
                                          offset: const Offset(0, 2))
                                    ],
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Text('Batting',
                                          style: Get.textTheme.bodyLarge
                                              ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13)),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(40),
                                    boxShadow: [
                                      BoxShadow(
                                          color: const Color.fromARGB(
                                                  60, 227, 225, 225)
                                              .withOpacity(0.9),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                          offset: const Offset(0, 7))
                                    ],
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Text('Leather ball',
                                          style: Get.textTheme.bodyLarge
                                              ?.copyWith(
                                                  color: AppTheme.darkBlueColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13)),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(40),
                                    boxShadow: [
                                      BoxShadow(
                                          color: const Color.fromARGB(
                                                  121, 187, 186, 186)
                                              .withOpacity(0.9),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                          offset: const Offset(0, 7))
                                    ],
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Text('Tennis Ball',
                                          style: Get.textTheme.bodyLarge
                                              ?.copyWith(
                                                  color: AppTheme.primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13)),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Players',
                              style: Get.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                        Container(
                          color: Colors.black26,
                          height: Get.height * 0.6,
                          child: ListView.separated(
                              padding: const EdgeInsets.all(20),
                              itemCount: 10,
                              shrinkWrap: true,
                              separatorBuilder: (c, i) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (c, i) => GestureDetector(
                                    onTap: () {
                                      Get.to(() => const ChallengeTeam());
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(13.0),
                                        child: Row(
                                          children: [
                                            const CircleAvatar(
                                              radius: 29,
                                            ),
                                            const SizedBox(width: 12),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Player Name',
                                                    style: Get.textTheme
                                                        .headlineMedium
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black)),
                                                Text(
                                                  'Inn 329 Runs 2335 Avg 40.25',
                                                  style: Get
                                                      .textTheme.bodyMedium
                                                      ?.copyWith(
                                                          color:
                                                              Colors.black54),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                        )
                      ],
                    ),
                  ))
            ],
          )),
    );
  }
}
