import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/config/preferences.dart';
import 'package:gully_app/ui/screens/home_screen.dart';
import 'package:gully_app/ui/screens/signup_screen.dart';
import 'package:gully_app/ui/screens/welcome_carosuel_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    route();
  }

  route() {
    Future.delayed(const Duration(seconds: 1), () {
      final pref = Get.find<Preferences>();
      if (pref.getToken() != null) {
        Get.offAll(() => const HomeScreen());
      } else {
        Get.off(() => const SignUpScreen());
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
          child: InkWell(
            onTap: () => Get.to(() => const WelcomeCarouselScreen()),
            child: Center(
                child: Image.asset(
              'assets/images/logo.png',
            )),
          ),
        ),
      ),
    );
  }
}
