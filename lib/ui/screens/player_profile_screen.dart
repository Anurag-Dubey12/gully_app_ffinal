import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/ui/screens/add_team.dart';
import 'package:gully_app/ui/screens/my_teams.dart';
import 'package:gully_app/ui/screens/select_team_to_view_history.dart';
import 'package:gully_app/ui/screens/view_opponent_team.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/utils/image_picker_helper.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

class PlayerProfileScreen extends StatefulWidget {
  const PlayerProfileScreen({super.key});

  @override
  State<PlayerProfileScreen> createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen> {
  XFile? _image;

  pickImage() async {
    _image = await imagePickerHelper();
    setState(() {});
    if (_image != null) {
      final controller = Get.find<AuthController>();
      final base64Image = await convertImageToBase64(_image!);
      controller.updateProfile(
          nickName: controller.state!.captializedName, base64: base64Image);
      successSnackBar('Profile updated successfully');
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    return DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage(
                'assets/images/sports_icon.png',
              ),
              fit: BoxFit.cover),
        ),
        child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff3F5BBF), Colors.white24, Colors.white24],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(children: [
                AppBar(
                  iconTheme: const IconThemeData(color: Colors.white),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: const Text(
                    'Profile',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.w800),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    pickImage();
                  },
                  child: Stack(
                    children: [
                      Obx(() => _image != null
                          ? CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white,
                              backgroundImage: FileImage(File(_image!.path)))
                          : Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          toImageUrl(
                                              controller.state!.profilePhoto!)),
                                      fit: BoxFit.cover)))),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.amber.shade600,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.edit,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Text(
                      controller.state!.fullName,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey[900]),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.mail,
                          color: Colors.grey[900],
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          controller.state!.email,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey[800]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.grey[900],
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          width: Get.width * 0.5,
                          child: Obx(() => Text(
                                controller.location.value,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey[800]),
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.phone,
                          color: Colors.grey[900],
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          controller.state!.phoneNumber ?? "",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey[800]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.black26),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ProfileTileCard(
                              text: 'Add team',
                              onTap: () {
                                Get.to(() => const AddTeam());
                              },
                            ),
                            ProfileTileCard(
                              text: 'View My Team',
                              onTap: () {
                                Get.to(() => const MyTeams());
                              },
                            ),
                            ProfileTileCard(
                              text: 'My performance',
                              onTap: () {
                                Get.to(() => const SelectTeamToViewHistory());
                              },
                            ),
                            ProfileTileCard(
                              text: 'View Opponent',
                              onTap: () {
                                Get.to(() => const ViewOpponentTeam());
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ]),
            )));
  }
}

class ProfileTileCard extends StatelessWidget {
  final String text;
  final Widget? subTrailingWidget;
  final Function? onTap;
  const ProfileTileCard({
    super.key,
    required this.text,
    this.subTrailingWidget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap == null ? () {} : () => onTap!(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.secondaryYellowColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Text(text, style: Get.textTheme.bodyLarge),
              const Spacer(),
              subTrailingWidget ?? const SizedBox(),
              const Icon(
                Icons.arrow_forward_ios,
                size: 19,
                color: AppTheme.secondaryYellowColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
