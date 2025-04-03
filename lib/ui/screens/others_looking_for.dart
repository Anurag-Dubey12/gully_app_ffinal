import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/misc_controller.dart';
import 'package:gully_app/data/model/looking_for_model.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
import 'package:gully_app/utils/app_logger.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/theme.dart';

class OthersLookingForScreen extends StatelessWidget {
  const OthersLookingForScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MiscController miscController = Get.find<MiscController>();
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 253, 253, 253),
        image: DecorationImage(
          image: AssetImage('assets/images/sports_icon.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: GradientBuilder(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              'Looking for',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
          ),
          body: Stack(
            children: [
              // ClipPath(
              //   clipper: ArcClipper(),
              //   child: Container(
              //     decoration: BoxDecoration(
              //       gradient: const RadialGradient(
              //         colors: [
              //           Color(0xff368EBF),
              //           AppTheme.primaryColor,
              //         ],
              //         center: Alignment(-0.4, -0.8),
              //       ),
              //       boxShadow: [
              //         BoxShadow(
              //             color: AppTheme.secondaryYellowColor.withOpacity(0.3),
              //             blurRadius: 20,
              //             spreadRadius: 2,
              //             offset: const Offset(0, 70))
              //       ],
              //     ),
              //     width: double.infinity,
              //   ),
              // ),
              Positioned(
                  child: SizedBox(
                // height: 70,
                width: Get.width,
                // height: Get.height / 1.2,
                child: ListView(
                  children: [
                    // SizedBox(height: Get.height * 0.04),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     boxShadow: [
                    //       BoxShadow(
                    //           color: const Color.fromARGB(132, 61, 60, 58)
                    //               .withOpacity(0.3),
                    //           blurRadius: 20,
                    //           spreadRadius: 2,
                    //           offset: const Offset(0, 7))
                    //     ],
                    //   ),
                    //   height: 54,
                    //   width: Get.width / 1.2,
                    //   child: TextField(
                    //     onTap: () {},
                    //     decoration: InputDecoration(
                    //       isDense: true,

                    //       suffixIcon: const Icon(
                    //         CupertinoIcons.search,
                    //         color: AppTheme.secondaryYellowColor,
                    //         size: 28,
                    //       ),
                    //       labelText: 'Search..',
                    //       labelStyle: TextStyle(
                    //         color: Colors.grey.shade500,
                    //         fontSize: 14,
                    //         fontWeight: FontWeight.w500,
                    //       ),
                    //       filled: true,
                    //       fillColor: Colors.white,
                    //       // isCollapsed: true,
                    //       border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(60),
                    //         borderSide: const BorderSide(
                    //           width: 0,
                    //           style: BorderStyle.none,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('What others are looking for?',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          const SizedBox(height: 30),
                          FutureBuilder(
                              future: miscController.getLookingFor(),
                              builder: (c, s) {
                                if (s.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (s.hasError) {
                                  return Center(
                                      child: Text('Error: ${s.error}'));
                                }
                                if (s.data!.isEmpty) {
                                  return const Center(
                                    child: Text(
                                        "No players found near your location"),
                                  );
                                }
                                return ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: s.data?.length ?? 0,
                                  separatorBuilder: (c, i) {
                                    return const SizedBox(height: 10);
                                  },
                                  itemBuilder: (c, i) {
                                    return _LookingCard(s.data![i]);
                                  },
                                );
                              }),
                        ],
                      ),
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class _LookingCard extends StatelessWidget {
  final LookingForPlayerModel model;
  const _LookingCard(this.model);

  @override
  Widget build(BuildContext context) {
    final startIndex = model.role!.indexOf("for a") + "for a".length;
    final roleString = model.role!.substring(startIndex).trim();
    // //logger.d"found looking for:${model.role}");
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
              offset: const Offset(0, 1))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(
                          text: model.fullName,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              height: 1.5,
                              fontFamily: AppTheme.fontName),
                          children: [
                        const TextSpan(
                          text: ' is looking for a  ',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              fontFamily: AppTheme.fontName),
                        ),
                        TextSpan(
                          text: roleString,
                          style: const TextStyle(
                            color: AppTheme.secondaryYellowColor,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: ' in ${model.location}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ])),
                  const SizedBox(height: 5),
                  Text(
                      DateFormat('dd MMM yyy @hh:mm a')
                          .format(model.createdAt.toLocal()),
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      _showContactOptions(context, model.phoneNumber ?? '');
                    },
                    child: const CircleAvatar(
                      backgroundColor: AppTheme.secondaryYellowColor,
                      child: Icon(Icons.contact_page),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showContactOptions(BuildContext context, String phoneNumber) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Contact Options',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          content: const Text(
            'Would you like to call or message via WhatsApp?',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          actions: [
            // Call Button with Icon
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _callPlayer(phoneNumber);
              },
              icon: const Icon(
                Icons.phone,
                color: Colors.green,
              ),
              label: const Text(
                'Call',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
            ),
            // WhatsApp Button with Icon
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _whatsappMessage(phoneNumber);
              },
              icon: const Icon(
                Icons.message,
                color: Colors.green,
              ),
              label: const Text(
                'WhatsApp',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

// Function to initiate a call
  void _callPlayer(String phoneNumber) {
    launchUrl(Uri.parse('tel:+91$phoneNumber'));
  }

  void _whatsappMessage(String phoneNumber) async {
    String message =
        setMessage(model.role ?? '', model.fullName, model.location ?? '');
    final encodedMessage = Uri.encodeComponent(message);

    final whatsappUrl = 'https://wa.me/+91$phoneNumber?text=$encodedMessage';

    if (await canLaunch(whatsappUrl)) {
      launchUrl(Uri.parse(whatsappUrl));
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  String setMessage(String role, String fullName, String location) {
    String message;

    switch (role.toLowerCase()) {
      case 'i am looking for a team to join as a batsman':
        message =
            'Hey, $fullName! I found that you are looking to join a team as a Batsman. Located in $location.';
        break;

      case 'all-rounder':
        message =
            'Hey, $fullName! I noticed that you are an All-rounder looking for a team. Located in $location.';
        break;

      case 'i am looking for a team to join as a wicket-keeper':
        message =
            'Hey, $fullName! I saw that you are looking to join a team as a Wicket-keeper. Located in $location.';
        break;

      case 'i am looking for a team to join as a bowler':
        message =
            'Hey, $fullName! I saw that you are looking to join a team as a Bowler. Located in $location.';
        break;

      case 'i am looking for a teammate to join as a bowler':
        message =
            'Hey, $fullName! I found that you are looking for a teammate to join as a Bowler. Located in $location.';
        break;

      case 'i am looking for a teammate to join as a batsman':
        message =
            'Hey, $fullName! I noticed that you are looking for a teammate to join as a Batsman. Located in $location.';
        break;

      case 'i am looking for a teammate to join as a wicket-keeper':
        message =
            'Hey, $fullName! I saw that you are looking for a teammate to join as a Wicket-keeper. Located in $location.';
        break;

      case 'i am looking for a teammate to join as an all-rounder':
        message =
            'Hey, $fullName! I found that you are looking for a teammate to join as an All-rounder. Located in $location.';
        break;

      default:
        message =
            'Hey, $fullName! I saw that you are looking for a team. Located in $location.';
        break;
    }

    return message;
  }
}
