import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/utils/utils.dart';

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
                child: Obx(
                  () => CircleAvatar(
                      radius: 20,
                      backgroundImage: CachedNetworkImageProvider(
                          toImageUrl(controller.state!.profilePhoto))),
                )),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => Get.to(() => const PlayerProfileScreen()),
                  child: Obx(() => SizedBox(
                        width: Get.width * 0.5,
                        child: Text(
                          controller.state!.captializedName,
                          style: Get.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontSize: Get.textScaleFactor * 24,
                          ),
                        ),
                      )),
                ),
                const LocationBuilder(),
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
                  Scaffold.of(context).openEndDrawer();
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

class LocationBuilder extends GetView<AuthController> {
  const LocationBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width / 2.7,
      child: Obx(() => Text(controller.location.value,
          maxLines: 1,
          style: Get.textTheme.labelSmall?.copyWith(
              overflow: TextOverflow.ellipsis,
              color: Colors.white,
              decoration: TextDecoration.underline,
              decorationColor: Colors.white))),
    );
  }
}
