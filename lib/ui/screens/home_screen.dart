import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/data/controller/misc_controller.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/ui/screens/organizer_profile.dart';
import 'package:gully_app/ui/screens/search_tournament_screen.dart';
import 'package:gully_app/ui/screens/shop/shop_home.dart';
import 'package:gully_app/ui/screens/tournament_form_screen.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/app_drawer.dart';
import 'package:gully_app/ui/widgets/home_screen/date_times_card.dart';
import 'package:gully_app/ui/widgets/home_screen/tournament_list.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:iconsax/iconsax.dart';

import '../widgets/arc_clipper.dart';
import '../widgets/home_screen/SliverAppBarDelegate.dart';
import '../widgets/home_screen/top_header.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';

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
    Get.find<MiscController>().getBanners();
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selected = 'Current';

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TournamentController>();
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
            image: AssetImage(
              'assets/images/sports_icon.png',
            ),
            fit: BoxFit.cover),
      ),
      child: PopScope(
        canPop: true,
        child: Scaffold(
          endDrawer: const AppDrawer(),
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          // floatingActionButton: Padding(
          //   padding: const EdgeInsets.only(right: 15, bottom: 15),
          //   child: FloatingActionButton(
          //     onPressed: () {
          //       Get.to(()=>const TournamentFormScreen());
          //     },
          //     foregroundColor: Colors.white,
          //     backgroundColor: AppTheme.primaryColor,
          //     hoverColor: Colors.white,
          //     splashColor: Colors.white,
          //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          //     tooltip: 'Create Your Tournament',
          //     elevation: 10.0,
          //     child: const Icon(Icons.add),
          //
          //   ),
          // ),
          bottomNavigationBar:
              // SizedBox(
              //   height: 60,
              //   // decoration: BoxDecoration(
              //   //   color: Colors.white,
              //   //   border: Border.all(
              //   //     color: Colors.grey,
              //   //     width: 2,
              //   //   ),
              //   //   borderRadius: BorderRadius.only(
              //   //     topLeft: Radius.circular(50.0),
              //   //     topRight: Radius.circular(50.0),
              //   //   ),
              //   //   boxShadow: [
              //   //     BoxShadow(
              //   //       color: Colors.black12,
              //   //       spreadRadius: 5,
              //   //       blurRadius: 10,
              //   //     ),
              //   //   ],
              //   // ),
              //   child: FlashyTabBar(
              //       backgroundColor: AppTheme.primaryColor,
              //       selectedIndex: _index,
              //       showElevation: false,
              //       onItemSelected: (index) {
              //         setState(() {
              //           switch(index){
              //             case 0:{
              //               Get.to(()=>ShopHome());
              //             }
              //             case 1:{
              //               Get.to(()=>ShopHome());
              //             }
              //           }
              //         });
              //
              //       },
              //       items: [
              //         FlashyTabBarItem(
              //           icon: const Icon(Iconsax.shopping_cart,size: 25,),
              //           activeColor: Colors.white,
              //           inactiveColor: Colors.white,
              //           title: const Text('Shop'),
              //         ),
              //
              //         FlashyTabBarItem(
              //           icon: const Icon(Icons.sports_cricket_rounded,size: 25),
              //           activeColor: Colors.white,
              //           inactiveColor: Colors.white,
              //           title: const Text('History'),
              //         ),
              //       ],
              //     ),
              // ),
              //Old Create tournament Button
              Container(
            height: 60,
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
                  padding: const EdgeInsets.all(5.0),
                  child: PrimaryButton(
                    onTap: () {
                      Get.to(() => const TournamentFormScreen(
                            tournament: null,
                          ));
                    },
                    title: AppLocalizations.of(context)!.create_your_tournament,
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
                bottom: 0,
                child: SizedBox(
                  width: Get.width,
                  height: Get.height - 150,
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TopHeader(),
                            ),
                            const SizedBox(height: 20),
                            //For multiple sports icon and text
                            // SizedBox(
                            //   height: 60,
                            //   child: ListView.separated(
                            //       scrollDirection: Axis.horizontal,
                            //       shrinkWrap: true,
                            //       itemBuilder: (context, index) {
                            //         return SportsCard(
                            //           index: index,
                            //         );
                            //       },
                            //       padding: const EdgeInsets.only(left: 20),
                            //       separatorBuilder: (context, index) =>
                            //           const SizedBox(
                            //             width: 15,
                            //           ),
                            //       itemCount: 7),
                            // ),

                            //Optional
                            //For particular sports such as cricker
                            Container(
                              width: 130,
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 157, 46),
                                borderRadius: BorderRadius.circular(21),
                                boxShadow: [
                                  BoxShadow(
                                      color: AppTheme.secondaryYellowColor
                                          .withOpacity(0.3),
                                      blurRadius: 2,
                                      spreadRadius: 1,
                                      offset: const Offset(0, -1))
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/cricket_icon.png',
                                    color: Colors.white,
                                    height: 30,
                                    width: 30,
                                  ),
                                  const Text(
                                    'Cricket',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            const FullBannerSlider(isAds: false),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: SliverAppBarDelegate(
                          minHeight: 90,
                          maxHeight: 90,
                          child: DecoratedBox(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/sports_icon.png',
                                  ),
                                  fit: BoxFit.cover),
                            ),
                            child: Column(
                              children: [
                                const DateTimesCard(),
                                // const TitleWidget(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Material(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(28),
                                            onTap: () {
                                              Get.to(() =>
                                                  const SearchTournamentScreen());
                                            },
                                            child: Ink(
                                              height: 35,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.black,
                                                    width: 0.5),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: const Row(
                                                children: [
                                                  SizedBox(width: 18),
                                                  Icon(Icons.search,
                                                      color: Colors.black),
                                                  SizedBox(width: 20),
                                                  Text('Search...',
                                                      style: TextStyle(
                                                          color: Colors.black)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      PopupMenuButton<String>(
                                        onSelected: (String value) {
                                          setState(() {
                                            selected = value;
                                            controller.getTournamentList(
                                                filterD: value.toLowerCase());
                                          });
                                        },
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry<String>>[
                                          const PopupMenuItem<String>(
                                            value: 'Past',
                                            child: Row(
                                              children: [
                                                Icon(Icons.history,
                                                    color: Colors.blue),
                                                SizedBox(width: 10),
                                                Text('Past'),
                                              ],
                                            ),
                                          ),
                                          const PopupMenuItem<String>(
                                            value: 'Current',
                                            child: Row(
                                              children: [
                                                Icon(Icons.event,
                                                    color: Colors.green),
                                                SizedBox(width: 10),
                                                Text('Current'),
                                              ],
                                            ),
                                          ),
                                          const PopupMenuItem<String>(
                                            value: 'Upcoming',
                                            child: Row(
                                              children: [
                                                Icon(Icons.schedule,
                                                    color: Colors.orange),
                                                SizedBox(width: 10),
                                                Text('Upcoming'),
                                              ],
                                            ),
                                          ),
                                        ],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        color: Colors.white,
                                        elevation: 8,
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border:
                                                Border.all(color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Icon(Icons.filter_list,
                                              color: Colors.black),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: TournamentList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
  final bool isAds;
  const FullBannerSlider({super.key, required this.isAds});

  @override
  State<FullBannerSlider> createState() => _FullBannerSliderState();
}

class _FullBannerSliderState extends State<FullBannerSlider> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MiscController>();
    return SizedBox(
      height: 150,
      width: 400,
      child: Obx(
        () => CarouselSlider(
          items: controller.banners.value
              .map((e) => ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                            imageUrl: toImageUrl(e.imageUrl),
                            fit: BoxFit.fill,
                            width: double.infinity),
                        if (widget.isAds)
                          Positioned(
                            top: 2,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Text(
                                "Ad",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        else
                          Positioned(
                            bottom: 10,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                controller.banners.length,
                                (index) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                  height: 8,
                                  width: _current == index ? 15 : 8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: _current == index
                                        ? AppTheme.darkYellowColor
                                        : Colors.grey.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                          ),
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
            aspectRatio: 16 / 9,
          ),
        ),
      ),
    );
  }
}

class TitleWidget extends StatefulWidget {
  const TitleWidget({super.key});

  @override
  State<TitleWidget> createState() => _TitleWidgetState();
}

class _TitleWidgetState extends State<TitleWidget> {
  String selected = 'Current';
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
              controller.getTournamentList(filterD: 'past');
              selected = 'Past';
            }),
          ),
          _TournamentMajorDuration(
            // title: 'Current',
            title: AppLocalizations.of(context)!.current,
            isSelected: selected == 'Current',
            onTap: () => setState(() {
              controller.getTournamentList(filterD: 'current');
              selected = 'Current';
            }),
          ),
          _TournamentMajorDuration(
            // title: 'Upcoming',
            title: AppLocalizations.of(context)!.upcoming,
            isSelected: selected == 'Upcoming',
            onTap: () => setState(() {
              controller.getTournamentList(filterD: 'upcoming');
              selected = 'Upcoming';
            }),
          ),
        ],
      ),
    );
  }
}
