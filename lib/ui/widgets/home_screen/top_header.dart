import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/data/controller/misc_controller.dart';
import 'package:gully_app/data/controller/notification_controller.dart';
import 'package:gully_app/ui/screens/search_places_screen.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/utils.dart';

import '../../../data/controller/tournament_controller.dart';
import '../../screens/notification_screen.dart';
import '../../screens/organizer_profile.dart';
import '../../screens/player_profile_screen.dart';

class TopHeader extends GetView<AuthController> {
  final Color? color;
  final double? fontSize;
  const TopHeader({super.key,this.color,this.fontSize});

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
                              color: color??Colors.white,
                              fontSize: fontSize ?? Get.textScaleFactor * 24,
                            ),
                          ),
                        ),
                      )),
                ),
                LocationBuilder(textColor: color ?? Colors.white,fontSize: fontSize),
              ],
            ),
          ],
        ),
        Row(
          children: [
            const _NotificationIcon(),
            const SizedBox(width: 10),
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
            const SizedBox(width: 15),
          ],
        )
      ],
    );
  }
}

class _NotificationIcon extends GetView<NotificationController> {
  const _NotificationIcon();

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
  final double? fontSize;
  const LocationBuilder({
    super.key,
    this.textColor,
    this.fontSize,
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
                logger.f('Location Description: ${e.lat}${e.lng}');
                controller.setLocation = e.description ?? 'Fetching Location';
                final tournamentController = Get.find<TournamentController>();

                tournamentController.setCoordinates =
                    LatLng(double.parse(e.lat!), double.parse(e.lng!));
                logger.f('Location: ${tournamentController.coordinates.value}');
                // return {'lat': e.lat, 'lng': e.lng};
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
                fontSize: fontSize,
                decorationColor: textColor ?? Colors.white))),
      ),
    );
  }
}
