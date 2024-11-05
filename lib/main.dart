import 'dart:async';
import 'dart:io';

import 'package:connectivity_widget/connectivity_widget.dart';
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
import 'package:gully_app/data/controller/team_controller.dart';
import 'package:gully_app/firebase_options.dart';
import 'package:gully_app/ui/screens/no_internet_screen.dart';
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
  // StreamSubscription<List<ConnectivityResult>>? subscription;
  // bool _isConnected = true;
  // @override
  // void initState() {
  //   super.initState();

  //   subscription = Connectivity()
  //       .onConnectivityChanged
  //       .listen((List<ConnectivityResult> result) {
  //     if (result.contains(ConnectivityResult.none)) {
  //       setState(() {
  //         _isConnected = false;
  //       });
  //     } else {
  //       setState(() {
  //         _isConnected = true;
  //       });
  //     }
  //   });
  // }

  @override
  void dispose() {
    // subscription?.cancel();
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
        } else {
          return ConnectivityWidget(
              offlineBanner: const SizedBox(),
              builder: (BuildContext context, bool isOnline) {
                if (!isOnline) {
                  return const NoInternetScreen();
                }
                return LocationStreamHandler(
                  child: child!,
                );
              });
        }
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ));
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
