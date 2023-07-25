import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/src/ui/screens/signup_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
            onTap: () => Get.to(() => const SignUpScreen()),
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
