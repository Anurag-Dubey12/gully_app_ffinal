import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gully_app/data/api/banner_promotion_api.dart';
import 'package:gully_app/data/api/misc_api.dart';
import 'package:gully_app/data/api/ranking_api.dart';
import 'package:gully_app/data/api/score_board_api.dart';
import 'package:gully_app/data/api/service_api.dart';
import 'package:gully_app/data/api/team_api.dart';
import 'package:gully_app/data/controller/banner_promotion_controller.dart';
import 'package:gully_app/data/controller/misc_controller.dart';
import 'package:gully_app/data/controller/notification_controller.dart';
import 'package:gully_app/data/controller/scoreboard_controller.dart';
import 'package:gully_app/data/controller/service_controller.dart';
import 'package:gully_app/data/controller/shop_controller.dart';
import 'package:gully_app/data/controller/team_controller.dart';
import 'package:gully_app/ui/widgets/location_permission_builder.dart';
import 'package:gully_app/utils/app_logger.dart';

import '/config/api_client.dart';
import '/config/app_constants.dart';
import '/config/preferences.dart';
import '/data/api/auth_api.dart';
import '/data/api/tournament_api.dart';
import '/data/controller/auth_controller.dart';
import '/data/controller/tournament_controller.dart';
import '/ui/screens/splash_screen.dart';
import '/ui/theme/theme.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  logger.i("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final fcmToken = await FirebaseMessaging.instance.getToken();
  logger.d("FCMToken $fcmToken");
  await GetStorage.init();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  HttpOverrides.global = MyHttpOverrides();
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  await DefaultCacheManager().emptyCache();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    try {
      final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
      _updateConnectionStatus(results);
    } catch (e) {
      logger.e('Could not check connectivity status', error: e);
    }

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _updateConnectionStatus(results);
    });
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    if (!mounted) return;

    final isConnected = results.any((result) => result != ConnectivityResult.none);

    try {
      final MiscController controller = Get.find<MiscController>();
      controller.isConnected.value = isConnected;
      logger.d("Connection Status: ${controller.isConnected.value}");

      if (Get.context != null) {
        if (!isConnected) {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.wifi_off, color: Colors.white),
                  SizedBox(width: 8),
                  Text('No internet connection'),
                ],
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        // else {
        //   ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
        //   ScaffoldMessenger.of(Get.context!).showSnackBar(
        //     const SnackBar(
        //       content: Row(
        //         children: [
        //           Icon(Icons.wifi, color: Colors.white),
        //           SizedBox(width: 8),
        //           Text('Internet connection restored'),
        //         ],
        //       ),
        //       backgroundColor: Colors.green,
        //       duration: Duration(seconds: 3),
        //       behavior: SnackBarBehavior.floating,
        //     ),
        //   );
        // }
      }
    } catch (e) {
      logger.e('Error updating connection status', error: e);
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('kn'),
        Locale('mr'),
        Locale('ml'),
        Locale('ur'),
        Locale('pa'),
        Locale('bn'),
        Locale('ta'),
        Locale('te'),
      ],
      builder: (context, child) {
        // if (!_isConnected) {
        //   return const NoInternetScreen();
        // }
        if (Get.locale != null &&
            (Get.locale!.languageCode == 'ar' ||
                Get.locale!.languageCode == 'ur')) {
          return LocationStreamHandler(
            child: Directionality(
              textDirection:
              TextDirection.rtl, // Right-to-left for Arabic or Urdu
              child: child!,
            ),
          );
        }
        return LocationStreamHandler(
          child: child!,
        );
        // else {
        //   // return ConnectivityWidget(
        //   //   offlineBanner: const SizedBox(),
        //   //   builder: (BuildContext context, bool isOnline) {
        //   //       MiscController controller =Get.find<MiscController>();
        //   //     if (!isOnline) {
        //   //       WidgetsBinding.instance.addPostFrameCallback((_) {
        //   //         controller.isConnected.value=false;
        //   //         logger.d("Connection Status:${controller.isConnected.value}");
        //   //         ScaffoldMessenger.of(context).showSnackBar(
        //   //           const SnackBar(
        //   //             content: Row(
        //   //               children: [
        //   //                 Icon(Icons.wifi_off, color: Colors.white),
        //   //                 SizedBox(width: 8),
        //   //                 Text('No internet connection'),
        //   //               ],
        //   //             ),
        //   //             backgroundColor: Colors.red,
        //   //             duration: Duration(days: 365),
        //   //             behavior: SnackBarBehavior.floating,
        //   //           ),
        //   //         );
        //   //       });
        //   //     } else {
        //   //       WidgetsBinding.instance.addPostFrameCallback((_) {
        //   //         controller.isConnected.value=true;
        //   //         logger.d("Connection Status:${controller.isConnected.value}");
        //   //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
        //   //         ScaffoldMessenger.of(context).showSnackBar(
        //   //           const SnackBar(
        //   //             content: Row(
        //   //               children: [
        //   //                 Icon(Icons.wifi, color: Colors.white),
        //   //                 SizedBox(width: 8),
        //   //                 Text('Internet connection Successfully'),
        //   //               ],
        //   //             ),
        //   //             backgroundColor: Colors.green,
        //   //             duration: Duration(seconds: 3),
        //   //             behavior: SnackBarBehavior.floating,
        //   //           ),
        //   //         );
        //   //       });
        //   //     }
        //   //     return LocationStreamHandler(
        //   //       child: child!,
        //   //     );
        //   //   },
        //   // );
        //
        // }
      },
      locale: const Locale('en'),
      binds: [
        Bind.put<Preferences>(Preferences()),
        Bind.put<GetConnectClient>(GetConnectClient(
          preferences: Get.find<Preferences>(),
        )),
        Bind.put<NotificationController>(NotificationController(
          preferences: Get.find<Preferences>(),
        )),
        Bind.lazyPut<RankingApi>(() => RankingApi(
          client: Get.find(),
        )),
        // Bind.lazyPut<AuthApi>(() => AuthApi(client: Get.find())),
        Bind.put<AuthApi>(AuthApi(client: Get.find())),
        Bind.put<MiscApi>(MiscApi(repo: Get.find())),
        Bind.put<BannerApi>(BannerApi(repo: Get.find())),
        Bind.put<ServiceApi>(ServiceApi(repo: Get.find())),
        Bind.lazyPut<TournamentApi>(() => TournamentApi(repo: Get.find())),
        Bind.lazyPut<ScoreboardApi>(() => ScoreboardApi(repo: Get.find())),
        Bind.put<TeamApi>(TeamApi(repo: Get.find())),
        Bind.put<TeamController>(TeamController(repo: Get.find())),
        Bind.put<AuthController>(AuthController(repo: Get.find())),
        Bind.put<ScoreBoardController>(
            ScoreBoardController(scoreboardApi: Get.find())),
        Bind.lazyPut<TournamentController>(
                () => TournamentController(Get.find())),
        Bind.lazyPut<PromotionController>(
                () => PromotionController(bannerApi: Get.find())),
        Bind.lazyPut<ServiceController>(
                () => ServiceController(serviceApi: Get.find())),
        Bind.lazyPut<ShopController>(
                () => ShopController()),
        Bind.put<MiscController>(MiscController(repo: Get.find())),
      ],
      defaultTransition: Transition.cupertino,
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}