import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/ui/screens/search_places_screen.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/utils.dart';

import '../../../data/controller/tournament_controller.dart';
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
    return GestureDetector(
      onTap: () {
        Get.to(() => SearchPlacesScreen(
              showSelectCurrentLocation: true,
              onSelected: (e) async {
                controller.setLocation = e.description ?? 'Fetching Location';
                final tournamentController = Get.find<TournamentController>();
                logger.d("${e.lat}, ${e.lng}");
                tournamentController.setCoordinates =
                    LatLng(double.parse(e.lat!), double.parse(e.lng!));
                logger.f('Location: ${tournamentController.coordinates.value}');
              },
            ));
      },
      child: SizedBox(
        width: Get.width / 2.2,
        child: Obx(() => Text(controller.location.value,
            maxLines: 1,
            style: Get.textTheme.labelSmall?.copyWith(
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
                decoration: TextDecoration.underline,
                decorationColor: Colors.white))),
      ),
    );
  }
}
