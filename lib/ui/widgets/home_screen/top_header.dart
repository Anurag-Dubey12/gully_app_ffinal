import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/auth_controller.dart';

import '../../screens/notification_screen.dart';
import '../../screens/player_profile_screen.dart';

class TopHeader extends GetView<AuthController> {
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
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      NetworkImage(controller.user.value.toImageUrl()),
                )),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    controller.getUser();
                  },
                  child: Obx(() => SizedBox(
                        width: Get.width * 0.5,
                        child: Text(
                          controller.user.value.fullName,
                          style: Get.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontSize: 24,
                              fontStyle: FontStyle.italic),
                        ),
                      )),
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
