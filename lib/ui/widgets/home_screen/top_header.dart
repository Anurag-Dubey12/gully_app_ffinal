import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/geo_locator_helper.dart';
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
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: CachedNetworkImageProvider(
                      controller.state?.toImageUrl()),
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
                          controller.state!.fullName,
                          style: Get.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontSize: Get.textScaleFactor * 24,
                              fontStyle: FontStyle.italic),
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

class LocationBuilder extends StatefulWidget {
  const LocationBuilder({
    super.key,
  });

  @override
  State<LocationBuilder> createState() => _LocationBuilderState();
}

class _LocationBuilderState extends State<LocationBuilder> {
  String? location;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      determinePosition().then((value) {
        getAddressFromLatLng(value).then((value1) {
          logger.i('value1 $value1');
          setState(() {
            location = value1;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // determinePosition().then((value) {
    //   logger.i('value $value');
    //   getAddressFromLatLng(value).then((value1) {
    //     logger.i('value1 $value1');
    //     setState(() {
    //       location = value1;
    //     });
    //   });
    // });
    return Text(location ??= 'Loading...',
        style: Get.textTheme.labelSmall?.copyWith(
            color: Colors.white,
            decoration: location == null ? TextDecoration.underline : null,
            decorationColor: Colors.white));
  }
}
