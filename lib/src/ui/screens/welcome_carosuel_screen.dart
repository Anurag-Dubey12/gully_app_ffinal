import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/src/ui/screens/signup_screen.dart';

class WelcomeCarouselScreen extends StatefulWidget {
  const WelcomeCarouselScreen({super.key});

  @override
  State<WelcomeCarouselScreen> createState() => _WelcomeCarouselScreenState();
}

class _WelcomeCarouselScreenState extends State<WelcomeCarouselScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => const SignUpScreen()),
      child: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(colors: [
            Color(0xffE04084),
            Color(0xff3F5BBF),
          ], center: Alignment.centerLeft),
        ),
        child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(128, 251, 218, 224),
                    Color(0xff5954FD),
                    Colors.transparent
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  stops: [0, 0.3, .5]),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: [
                  Positioned(
                    top: 30,
                    left: 40,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Image.asset(
                        'assets/images/hand_wave_cricketer.png',
                        height: Get.height * 0.54,
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 30,
                    bottom: 0,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Text(
                          'GULLY\nTEAM',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 82,
                              height: 0.8,
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
