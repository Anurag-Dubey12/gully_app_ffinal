import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/misc_controller.dart';
import 'package:gully_app/data/model/looking_for_model.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';
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
          appBar:  AppBar(
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
                                  return Center(child: Text('Error: ${s.error}'));
                                }
                                if (s.data!.isEmpty) {
                                  return const Center(
                                    child: Text("No players found near your location"),
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
                      HapticFeedback.heavyImpact();
                      launchUrl(Uri.parse('tel:+91${model.phoneNumber}'));
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
}
