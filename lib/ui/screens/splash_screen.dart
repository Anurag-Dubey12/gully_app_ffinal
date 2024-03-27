import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/config/preferences.dart';
import 'package:gully_app/data/controller/misc_controller.dart';
import 'package:gully_app/ui/screens/home_screen.dart';
import 'package:gully_app/ui/screens/welcome_carosuel_screen.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkForUpdate();
    // route();
  }

  route() {
    Future.delayed(const Duration(seconds: 2), () async {
      final pref = Get.put<Preferences>(Preferences(), permanent: true);
      logger.i("Token: ${pref.getToken()}");
      if (pref.getToken() != null) {
        Get.offAll(() => const HomeScreen());
      } else {
        Get.offAll(() => const WelcomeCarouselScreen());
      }
    });
  }

  checkForUpdate() async {
    final misc = Get.find<MiscController>();
    final update = await misc.getVersion();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String version = packageInfo.version;
    bool updateAvailable = update.version != version;
    Future.delayed(const Duration(seconds: 2), () async {
      if (updateAvailable) {
        if (Platform.isIOS) {
          Get.dialog(CupertinoAlertDialog(
            title: const Text('Update Available'),
            content: const Text('Please update the app to continue'),
            actions: [
              update.forceUpdate
                  ? const SizedBox()
                  : TextButton(
                      onPressed: () {
                        route();
                        Get.back();
                      },
                      child: const Text('Later')),
              TextButton(
                  onPressed: () {
                    launchUrl(Uri.parse(
                        'https://apps.apple.com/in/app/gully-app/id1581440134'));
                  },
                  child: const Text('Update'))
            ],
          ));
        } else {
          Get.dialog(AlertDialog(
            title: const Text('Update Available'),
            content: const Text('Please update the app to continue'),
            actions: [
              update.forceUpdate
                  ? const SizedBox()
                  : TextButton(
                      onPressed: () {
                        Get.back();
                        route();
                      },
                      child: const Text('Later')),
              TextButton(
                  onPressed: () {
                    launchUrl(Uri.parse(
                        'https://play.google.com/store/apps/details?id=com.gully_app.gully_app'));
                  },
                  child: const Text('Update'))
            ],
          ));
        }
      } else {
        route();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(colors: [
          Color(0xff2EDEE4),
          Color(0xff3F5BBF),
        ], center: Alignment.centerRight),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(
              child: Image.asset(
            'assets/images/logo.png',
          )),
        ),
      ),
    );
  }
}
