import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/data/controller/misc_controller.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/ui/screens/tournament_form_screen.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/app_drawer.dart';
import 'package:gully_app/ui/widgets/home_screen/date_times_card.dart';
import 'package:gully_app/ui/widgets/home_screen/sports_card.dart';
import 'package:gully_app/ui/widgets/home_screen/tournament_list.dart';
import 'package:gully_app/ui/widgets/location_permission_builder.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/utils.dart';

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
                        Get.to(() => const TournamentFormScreen(
                              tournament: null,
                            ));
                      },
                      // title: 'Create Your Tournament',
                      title:
                          AppLocalizations.of(context)!.create_your_tournament,
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

                    child: SizedBox(
                      height: Get.height - 150,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TopHeader(),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 60,
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
                            const SizedBox(
                              height: 20,
                            ),
                            TextButton(
                                onPressed: () {
                                  Get.updateLocale(const Locale("kn"));

                                  logger.d(Get.locale?.languageCode);
                                },
                                child: const Text('Locale')),
                            const FullBannerSlider(),
                            const SizedBox(height: 20),
                            const DateTimesCard(),
                            const TitleWidget(),
                            const TournamentList()
                          ],
                        ),
                      ),
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

class _TournamentMajorDuration extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  const _TournamentMajorDuration(
      {required this.title, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          // width: 64,
          decoration: BoxDecoration(
              color: isSelected ? AppTheme.secondaryYellowColor : Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade100, spreadRadius: 2, blurRadius: 2)
              ],
              borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FullBannerSlider extends StatefulWidget {
  const FullBannerSlider({super.key});

  @override
  State<FullBannerSlider> createState() => _FullBannerSliderState();
}

class _FullBannerSliderState extends State<FullBannerSlider> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MiscController>();
    return SizedBox(
        height: 100,
        width: Get.width,
        child: Obx(
          () => CarouselSlider(
              items: controller.banners.value
                  .map((e) => ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: toImageUrl(e.imageUrl),
                              fit: BoxFit.fill,
                              width: double.infinity,
                            ),
                            Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ...List.generate(
                                        controller.banners.length,
                                        (index) => Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 8,
                                            width: 8,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: _current == index
                                                    ? AppTheme.darkYellowColor
                                                    : Colors.grey.shade400),
                                          ),
                                        ),
                                      )
                                    ]))
                          ],
                        ),
                      ))
                  .toList(),
              options: CarouselOptions(
                  viewportFraction: 0.91,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9)),
        ));
  }
}

class TitleWidget extends StatefulWidget {
  const TitleWidget({super.key});

  @override
  State<TitleWidget> createState() => _TitleWidgetState();
}

class _TitleWidgetState extends State<TitleWidget> {
  String selected = 'Past';
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TournamentController>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Row(
        children: [
          Text(
            AppLocalizations.of(context)!.tournaments,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          const Spacer(),
          _TournamentMajorDuration(
            // title: 'Past',
            title: AppLocalizations.of(context)!.past,
            isSelected: selected == 'Past',
            onTap: () => setState(() {
              controller.getTournamentList(filter: 'past');
              selected = 'Past';
            }),
          ),
          _TournamentMajorDuration(
            // title: 'Current',
            title: AppLocalizations.of(context)!.current,
            isSelected: selected == 'Current',
            onTap: () => setState(() {
              controller.getTournamentList(filter: 'current');
              selected = 'Current';
            }),
          ),
          _TournamentMajorDuration(
            // title: 'Upcoming',
            title: AppLocalizations.of(context)!.upcoming,
            isSelected: selected == 'Upcoming',
            onTap: () => setState(() {
              controller.getTournamentList(filter: 'upcoming');
              selected = 'Upcoming';
            }),
          ),
        ],
      ),
    );
  }
}
