import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:gully_app/ui/screens/service/my_service_screen.dart';
import 'package:gully_app/ui/screens/service/service_register.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/controller/auth_controller.dart';
import '../../../utils/utils.dart';
import '../../widgets/home_screen/top_header.dart';
import '../organizer_profile.dart';

class ServiceProfile extends StatefulWidget {
  const ServiceProfile({super.key});
  @override
  State<StatefulWidget> createState() => profile();
}

class profile extends State<ServiceProfile> {
  XFile? _image;
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
          body: Column(
            children: [
              Stack(
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
                                      toImageUrl(controller.state!.profilePhoto)),
                                  fit: BoxFit.cover)))),
                ],
              ),
              const SizedBox(height: 3),
              Obx(
                () => Column(
                  children: [
                    Text(
                      controller.state!.captializedName,
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
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.grey[900],
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        const LocationBuilder(
                          textColor: Colors.black,
                        ),
                        // SizedBox(
                        //   width: Get.width * 0.5,
                        //   child: Obx(() => Text(
                        //         controller.location.value,
                        //         textAlign: TextAlign.center,
                        //         overflow: TextOverflow.ellipsis,
                        //         style: TextStyle(
                        //             fontSize: 15,
                        //             fontWeight: FontWeight.w300,
                        //             color: Colors.grey[800]),
                        //       )),
                        // ),
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
                              text: 'View My Service',
                              onTap: () {
                                Get.to(() => const MyServiceScreen());
                              },
                            ),
                            ProfileTileCard(
                              text: 'Add My Service',
                              onTap: () {
                                Get.to(() => const ServiceRegister());
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
