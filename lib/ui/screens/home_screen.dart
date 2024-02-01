import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/ui/screens/tournament_form_screen.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/app_drawer.dart';
import 'package:gully_app/ui/widgets/home_screen/date_times_card.dart';
import 'package:gully_app/ui/widgets/home_screen/sports_card.dart';
import 'package:gully_app/ui/widgets/home_screen/tournament_list.dart';
import 'package:gully_app/ui/widgets/location_permission_builder.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:gully_app/utils/app_logger.dart';

import '../widgets/arc_clipper.dart';
import '../widgets/home_screen/top_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<AuthController>().getUser();
    FirebaseMessaging.instance.getToken().then((value) {
      Get.find<AuthController>().updateProfile(fcmToken: value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Obx(() {
      if (controller.state == null) {
        logger.i('state is null');
        return const Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: CircularProgressIndicator()),
              ],
            ));
      } else {
        return const HomePage();
      }
    });
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LocationStreamHandler(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage(
                'assets/images/sports_icon.png',
              ),
              fit: BoxFit.cover),
        ),
        child: PopScope(
          canPop: false,
          child: Scaffold(
            endDrawer: const AppDrawer(),
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
                        Get.to(() => const TournamentFormScreen());
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
                            color:
                                AppTheme.secondaryYellowColor.withOpacity(0.3),
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
                          child: TopHeader(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 104,
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
                        const DateTimesCard(),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 12),
                            child: Text(
                              'Tournaments',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                          ),
                        ),
                        const TournamentList()
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
