import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/data/controller/misc_controller.dart';
import 'package:gully_app/data/controller/shop_controller.dart';
import 'package:gully_app/data/controller/tournament_controller.dart';
import 'package:gully_app/ui/screens/current_tournament_list.dart';
import 'package:gully_app/ui/screens/search_tournament_screen.dart';
import 'package:gully_app/ui/screens/shop/User%20Screen/nearby_shop_screen.dart';
import 'package:gully_app/ui/screens/tournament_form_screen.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/app_drawer.dart';
import 'package:gully_app/ui/widgets/banner/banner_adding.dart';
import 'package:gully_app/ui/widgets/home_screen/bannerIndicators.dart';
import 'package:gully_app/ui/widgets/home_screen/date_times_card.dart';
import 'package:gully_app/ui/widgets/home_screen/tournament_list.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:shimmer/shimmer.dart';
import '../../config/app_constants.dart';
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
  DateTime? _lastPressedAt;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
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
      Future.delayed(const Duration(seconds: 1), () async {
        Get.find<MiscController>().getBanners();
      });
      // Get.find<MiscController>().getBanners();
      Get.find<MiscController>().getCurrentLocation();
      FirebaseMessaging.instance.getToken().then((value) {
        Get.find<AuthController>().updateProfile(fcmToken: value);
      });
      _checkLocationPermissionAndServices();
    } else {
      errorSnackBar("Please connect to the network");
    }
  }

  Future<void> _checkLocationPermissionAndServices() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      errorSnackBar("Location permission is required to proceed.");
      return;
    }
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      _showLocationServiceDialog();
    }
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.white,
          title: const Row(
            children: [
              Icon(
                Icons.location_on,
                size: 24,
                color: Colors.blueAccent,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Share Your Current Position',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'To provide you with relevant tournament matches, rankings, banners, and other local details, we require access to your current location.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Once location access is enabled, please refresh this screen to view the latest data.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () async {
                            Geolocator.openLocationSettings();
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Allow",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Maybe Later",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  //For Double press to exit
  // Future<bool> _onWillPop() async {
  //   final now = DateTime.now();
  //   if (_lastPressedAt == null ||
  //       now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
  //     _lastPressedAt = now;
  //     Get.snackbar(
  //       "Exit App",
  //       "Press back again to exit",
  //       snackPosition: SnackPosition.top,
  //       duration: const Duration(seconds: 2),
  //       backgroundColor: Colors.black,
  //       colorText: Colors.white,
  //     );

  //     return Future.value(false);
  //   }

  //   SystemNavigator.pop();
  //   return Future.value(true);
  // }

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
    final controller = Get.find<ShopController>();
    _controller = PersistentTabController(initialIndex: 0);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    controller.getCategory();
    controller.getbrands();
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
      Get.find<MiscController>().getBanners();
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
      const ShopHome(),
      const SizedBox(),
      // const ShopHome(),
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
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.sports_kabaddi_outlined),
        title: "Shop",
        activeColorPrimary: AppTheme.primaryColor,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.circle),
        title: "",
        activeColorPrimary: Colors.transparent,
        inactiveColorPrimary: Colors.transparent,
        onPressed: (context) {},
      ),
      // PersistentBottomNavBarItem(
      //   icon: const Icon(Icons.room_service),
      //   title: "Service",
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
                        BannerIndicators(controller: misccontroller),
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
        () {
          if (controller.banners.isEmpty) {
            return _buildShimmerLoading();
          } else {
            return _buildBannerCarousel(controller);
          }
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Widget _buildBannerCarousel(MiscController controller) {
    return GestureDetector(
      onTap: () {
        imageViewer(context, controller.banners.value[_current].imageUrl, true,
            onTap: () {
          if (controller.banners.value[_current].link == "TournamentSponsor") {
            Get.find<TournamentController>().getOrganizerTournamentList();
            Get.to(() => const CurrentTournamentListScreen(
                  redirectType: RedirectType.sponsor,
                ));
          } else if (controller.banners.value[_current].link ==
              "inAppBannerPromotion") {
            Get.to(() => const BannerAdding());
          } else {
            Get.to(() => const BannerAdding());
          }
        });
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
                        width: double.infinity,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: double.infinity,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (e.type == "promotional")
                        Positioned(
                          top: 2,
                          right: 10,
                          child: GestureDetector(
                            onTap: () => Get.to(() => const BannerAdding()),
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
              controller.updateIndex(index);
              _current = index;
            });
          },
          enlargeCenterPage: true,
          aspectRatio: 16 / 9,
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
          const Text(
            AppConstants.tournaments,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          const Spacer(),
          _TournamentMajorDuration(
            // title: 'Past',
            title: AppConstants.past,
            isSelected: selected == 'Past',
            onTap: () => setState(() {
              controller.getTournamentList(filterD: 'past');
              selected = 'Past';
            }),
          ),
          _TournamentMajorDuration(
            // title: 'Current',
            title: AppConstants.current,
            isSelected: selected == 'Current',
            onTap: () => setState(() {
              controller.getTournamentList(filterD: 'current');
              selected = 'Current';
            }),
          ),
          _TournamentMajorDuration(
            // title: 'Upcoming',
            title: AppConstants.upcoming,
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
