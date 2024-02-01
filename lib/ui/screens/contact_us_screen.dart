import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/create_tournament/form_input.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/ui/widgets/primary_button.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:gully_app/utils/utils.dart';

import '../../data/controller/auth_controller.dart';
import '../../data/controller/misc_controller.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final miscController = Get.find<MiscController>();
    return GradientBuilder(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Contact Us',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormInput(
                    controller: TextEditingController(
                      text: controller.state?.fullName,
                    ),
                    readOnly: true,
                    label: 'Name',
                    enabled: false,
                  ),
                  FormInput(
                    controller: TextEditingController(
                      text: controller.state?.email,
                    ),
                    readOnly: true,
                    label: 'Email',
                    enabled: false,
                  ),
                  FormInput(
                    controller: messageController,
                    maxLines: 10,
                    label: 'Message',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(() => PrimaryButton(
                        isLoading: miscController.status.isLoading,
                        onTap: () async {
                          if (messageController.text.isEmpty) {
                            errorSnackBar('Please enter message');
                            return;
                          }
                          if (messageController.text.length < 20) {
                            errorSnackBar(
                                'Message should be atleast 20 characters long');
                            return;
                          }
                          logger.i('adding help desk');
                          final r = await miscController.addhelpDesk({
                            'issue': messageController.text,
                          });
                          logger.i('help desk added');
                          Get.bottomSheet(
                              BottomSheet(
                                  onClosing: () {},
                                  enableDrag: false,
                                  showDragHandle: true,
                                  builder: (context) {
                                    return SizedBox(
                                      width: Get.width,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Icon(
                                            Icons.verified,
                                            size: 98,
                                            color:
                                                AppTheme.secondaryYellowColor,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Text(
                                            'Thank you for contacting us.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Text(
                                            'We will get back to you soon.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: PrimaryButton(
                                              onTap: () {
                                                Get.back();
                                                Get.back();
                                              },
                                              title: 'OK',
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 80,
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                              isDismissible: false,
                              enableDrag: false);
                        },
                        title: 'Submit',
                      )),
                ],
              ),
              SizedBox(
                height: Get.height * 0.06,
              ),
              const Row(
                children: [
                  Icon(
                    Icons.mail,
                    size: 17,
                    color: AppTheme.secondaryYellowColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('info@nileegames.com'),
                ],
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              const Row(
                children: [
                  Icon(
                    Icons.location_city,
                    size: 17,
                    color: AppTheme.secondaryYellowColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                      '508, 5th floor, Fly Edge building, S.V. \nRoad, Borivali East'),
                ],
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              const Row(
                children: [
                  Icon(
                    Icons.phone,
                    size: 17,
                    color: AppTheme.secondaryYellowColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('+91 9855453210, 555-899-80085'),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
