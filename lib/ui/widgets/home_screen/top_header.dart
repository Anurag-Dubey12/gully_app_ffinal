import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../screens/notification_screen.dart';
import '../../screens/player_profile_screen.dart';

class TopHeader extends StatelessWidget {
  const TopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            InkWell(
                onTap: () => Get.to(() => const PlayerProfileScreen()),
                child: const CircleAvatar()),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bhavesh Pant',
                  style: Get.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 24,
                      fontStyle: FontStyle.italic),
                ),
                Text('Select Location',
                    style: Get.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white)),
              ],
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 30,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.notifications,
                  size: 23,
                ),
                onPressed: () {
                  Get.to(() => const NotificationScreen());
                },
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 30,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.menu,
                  size: 23,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                color: Colors.white,
              ),
            ),
          ],
        )
      ],
    );
  }
}
