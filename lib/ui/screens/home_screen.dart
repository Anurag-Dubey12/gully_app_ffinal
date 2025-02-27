import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/data/controller/misc_controller.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/ui/screens/promote_banner_screen.dart';
import 'package:gully_app/ui/screens/search_tournament_screen.dart';
import 'package:gully_app/ui/screens/tournament_form_screen.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/app_drawer.dart';
import 'package:gully_app/ui/widgets/home_screen/date_times_card.dart';
import 'package:gully_app/ui/widgets/home_screen/tournament_list.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../../utils/image_picker_helper.dart';
import '../../utils/internetConnectivty.dart';
import '../widgets/home_screen/SliverAppBarDelegate.dart';
import '../widgets/home_screen/live_score_screen.dart';
import '../widgets/home_screen/top_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Internetconnectivty _connectivityService = Internetconnectivty();
  bool _isConnected = true;
  @override
  void initState() {
    super.initState();
    _connectivityService.listenToConnectionChanges((isConnected) {
      setState(() {
        _isConnected = isConnected;
      });
      if (!isConnected) {
        errorSnackBar("Please connect to the network");
      }
    });
    if (_isConnected) {
      Get.find<AuthController>().getUser();
      Get.find<MiscController>().getBanners();
      FirebaseMessaging.instance.getToken().then((value) {
        Get.find<AuthController>().updateProfile(fcmToken: value);
      });
    } else {
      errorSnackBar("Please connect to the network");
    }
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

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  late PersistentTabController _controller;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool isOrganizer = false;

  @override
  void initState() {
    super.initState();
    final controller = Get.find<AuthController>();
    _controller = PersistentTabController(initialIndex: 0);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    // if (controller.state!.isOrganizer) {
    //   isOrganizer = true;
    // } else {
    //    isOrganizer= false;
    // }
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> refreshData() async {
    try {
      final tournamentController = Get.find<TournamentController>();
      tournamentController.filter.value = 'current';

    } catch (e) {
      logger.e('Error refreshing data: $e');
    }
  }

  List<Widget> _buildScreens() {
    final tournamentController = Get.find<TournamentController>();
    tournamentController.filter.value = 'current';
    return [
      const HomePageContent(),
      const SizedBox(),
      // const ServiceHomeScreen(),
      // const ServiceHomeScreen(),
      const LiveScore()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home_filled),
        title: "Home",
        activeColorPrimary: AppTheme.primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
      // PersistentBottomNavBarItem(
      //   icon: const Icon(Icons.home_filled),
      //   title: "vendor",
      //   activeColorPrimary: AppTheme.primaryColor,
      //   inactiveColorPrimary: Colors.grey,
      // ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.circle),
        title: "",
        activeColorPrimary: Colors.transparent,
        inactiveColorPrimary: Colors.transparent,
        onPressed: (context) {},
      ),
      // PersistentBottomNavBarItem(
      //   icon: const Icon(Icons.home_filled),
      //   title: "vendor",
      //   activeColorPrimary: AppTheme.primaryColor,
      //   inactiveColorPrimary: Colors.grey,
      // ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.live_tv_outlined),
        title: "Live Score",
        activeColorPrimary: AppTheme.primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

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
      child: PopScope(
        canPop: true,
        child: Scaffold(
          endDrawer: const AppDrawer(),
          body: Stack(
            children: [
              PersistentTabView(
                context,
                controller: _controller,
                screens: _buildScreens(),
                items: _navBarsItems(),
                confineToSafeArea: true,
                padding: EdgeInsets.zero,
                backgroundColor: Colors.white,
                handleAndroidBackButtonPress: true,
                resizeToAvoidBottomInset: true,
                stateManagement: true,
                decoration: NavBarDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  colorBehindNavBar: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: const Offset(0, -1),
                    ),
                  ],
                ),
                navBarStyle: NavBarStyle.style4,
              ),
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Center(
                  child: ClipOval(
                    child: FloatingActionButton(
                      onPressed: () {
                        Get.to(() => const TournamentFormScreen());
                      },
                      backgroundColor: AppTheme.primaryColor,
                      child: const Icon(Icons.add),
                    ),
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

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => ScreenContent();
}

class ScreenContent extends State<HomePageContent> {
  String selected = 'Current';
  final int _current = 0;
  Future<void> refreshData() async {
    try {
      final tournamentController = Get.find<TournamentController>();
      tournamentController.filter.value = 'current';
      await tournamentController.getTournamentList(filterD: selected);
      Get.find<MiscController>().getBanners();
    } catch (e) {
      logger.e('Error refreshing data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TournamentController>();
    final misccontroller = Get.find<MiscController>();
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            width: Get.width,
            height: MediaQuery.of(context).padding.top + 55,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [Color(0xff368EBF), AppTheme.primaryColor],
                center: Alignment(-0.4, -0.8),
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top,
          bottom: 0,
          child: SizedBox(
            width: Get.width,
            height: Get.height - 150,
            child: RefreshIndicator(
              onRefresh: refreshData,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          decoration: const BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                Color(0xff368EBF),
                                AppTheme.primaryColor
                              ],
                            ),
                          ),
                          width: double.infinity,
                          child: const TopHeader(),
                        ),
                        const SizedBox(height: 10),
                        const FullBannerSlider(isAds: false),
                        const SizedBox(height: 10),
                        Obx(() {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.arrow_back_ios_new,
                                size: 12,
                                color: AppTheme.darkYellowColor,
                              ),
                              const SizedBox(width: 8),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                  misccontroller.banners.length,
                                  (index) => AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 3),
                                    height: 10,
                                    width:
                                        misccontroller.indexvalue.value == index
                                            ? 15
                                            : 8,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: misccontroller.indexvalue.value ==
                                              index
                                          ? AppTheme.darkYellowColor
                                          : Colors.grey.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: AppTheme.darkYellowColor,
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: SliverAppBarDelegate(
                      minHeight: 95,
                      maxHeight: 95,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: AssetImage('assets/images/sports_icon.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          children: [
                            const DateTimesCard(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Material(
                                      borderRadius: BorderRadius.circular(20),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(28),
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
                                        controller.setSelectedFilter(value);
                                        logger.d(
                                            "Selected Filter Value:${controller.filterData.value}");
                                        controller.getTournamentList(
                                            filterD:
                                                controller.filterData.value);
                                      });
                                    },
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<String>>[
                                      const PopupMenuItem<String>(
                                        value: 'past',
                                        enabled: false,
                                        height: 10,
                                        child: Center(
                                          child: Text(
                                            'Matches',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'past',
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
                                        value: 'current',
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
                                        value: 'upcoming',
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
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    color: Colors.white,
                                    elevation: 8,
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(10),
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
        ),
      ],
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
        () => GestureDetector(
          onTap: () {
            if (controller.banners.value[_current].link ==
                "inAppBannerPromotion") {
              imageViewer(
                  context, controller.banners.value[_current].imageUrl, true,
                  onTap: () {
                Get.to(() => const PromoteBannerScreen());
              });
            }
            // if (banner.type == "promotional") {
            //   imageViewer(context,controller.banners.value[_current].promotionalImage,
            //       true,
            //       onTap: (){
            //         Get.to(()=>const PromoteBannerScreen());
            //       }
            //   );
            // }
          },
          child: CarouselSlider(
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
                          if (e.type == "promotional")
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
                            ),
                          // if (widget.isAds)
                          //   Positioned(
                          //     top: 2,
                          //     right: 10,
                          //     child: Container(
                          //       padding: const EdgeInsets.symmetric(
                          //           horizontal: 8, vertical: 4),
                          //       decoration: BoxDecoration(
                          //         color: Colors.black.withOpacity(0.6),
                          //         borderRadius: BorderRadius.circular(20),
                          //         boxShadow: [
                          //           BoxShadow(
                          //             color: Colors.black.withOpacity(0.2),
                          //             blurRadius: 4,
                          //             offset: const Offset(0, 2),
                          //           ),
                          //         ],
                          //       ),
                          //       child: const Text(
                          //         "Ad",
                          //         style: TextStyle(
                          //           color: Colors.white,
                          //           fontSize: 12,
                          //           fontWeight: FontWeight.bold,
                          //         ),
                          //       ),
                          //     ),
                          //   )
                          // else
                          //   Positioned(
                          //     bottom: 10,
                          //     left: 0,
                          //     right: 0,
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: List.generate(
                          //         controller.banners.length,
                          //         (index) => AnimatedContainer(
                          //           duration: const Duration(milliseconds: 300),
                          //           margin:
                          //               const EdgeInsets.symmetric(horizontal: 3),
                          //           height: 8,
                          //           width: _current == index ? 15 : 8,
                          //           decoration: BoxDecoration(
                          //             borderRadius: BorderRadius.circular(4),
                          //             color: _current == index
                          //                 ? AppTheme.darkYellowColor
                          //                 : Colors.grey.withOpacity(0.5),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
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
                  controller.updateIndex(index);
                  _current = index;
                });
              },
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
            ),
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
