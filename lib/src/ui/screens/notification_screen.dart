import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/src/ui/screens/full_notification_screen.dart';
import 'package:gully_app/src/ui/screens/txn_history_screen.dart';

import '../theme/theme.dart';
import '../widgets/arc_clipper.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
            image: AssetImage(
              'assets/images/sports_icon.png',
            ),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
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
              top: 0,
              child: SizedBox(
                  width: Get.width,
                  child: Column(children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10, top: 30),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: BackButton(
                            color: Colors.white,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Get.width * 0.03,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Notifications',
                              style: Get.textTheme.headlineLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: Get.height * 0.04),
                          Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 10))
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        Get.to(() =>
                                            const FullNotificationScreen());
                                      },
                                      child: const NotificationCard()),
                                  const NotificationCard(),
                                  const NotificationCard(),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ])))
        ]),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ListTile(
          leading: CircleAvatar(),
          title: Text('Congrats on the win!'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(
            color: Colors.grey[200],
          ),
        ),
      ],
    );
  }
}
