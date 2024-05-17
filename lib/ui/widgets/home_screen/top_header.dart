import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/data/controller/notification_controller.dart';
import 'package:gully_app/ui/screens/search_places_screen.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/utils.dart';

import '../../../data/controller/tournament_controller.dart';
import '../../screens/notification_screen.dart';
import '../../screens/organizer_profile.dart';
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
                onTap: () {
                  if (controller.state!.isOrganizer) {
                    Get.to(() => const OrganizerProfileScreen());
                  } else {
                    Get.to(() => const PlayerProfileScreen());
                  }
                },
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
                  onTap: () {
                    if (controller.state!.isOrganizer) {
                      Get.to(() => const OrganizerProfileScreen());
                    } else {
                      Get.to(() => const PlayerProfileScreen());
                    }
                  },
                  child: Obx(() => SizedBox(
                        width: Get.width * 0.5,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            controller.state!.captializedName,
                            textAlign: TextAlign.start,
                            style: Get.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontSize: Get.textScaleFactor * 24,
                            ),
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
            const _NotificationIcon(),
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

class _NotificationIcon extends GetView<NotificationController> {
  const _NotificationIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Stack(
          children: [
            const Icon(
              Icons.notifications,
              size: 23,
            ),
            Obx(
              () => controller.notifications.value
                      .any((element) => element.isRead == false)
                  ? Positioned(
                      right: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(99)),
                      ),
                    )
                  : const SizedBox(),
            )
          ],
        ),
        onPressed: () {
          Get.to(() => const NotificationScreen());
        },
        color: Colors.white,
      ),
    );
  }
}

class LocationBuilder extends GetView<AuthController> {
  final Color? textColor;
  const LocationBuilder({
    super.key,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => SearchPlacesScreen(
              showSelectCurrentLocation: true,
              title: AppLocalizations.of(context)!.selectLocation,
              onSelected: (e) async {
                logger.f('Location Description: ${e.description}');
                controller.setLocation = e.description ?? 'Fetching Location';
                final tournamentController = Get.find<TournamentController>();

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
            // textAlign: TextAlign.start,
            style: Get.textTheme.labelSmall?.copyWith(
                overflow: TextOverflow.ellipsis,
                color: textColor ?? Colors.white,
                decoration: TextDecoration.underline,
                decorationColor: textColor ?? Colors.white))),
      ),
    );
  }
}
