import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/model/team_model.dart';
import 'package:gully_app/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/theme.dart';
import '../widgets/arc_clipper.dart';

class ViewOpponentTeam extends StatefulWidget {
  final TeamModel team;
  const ViewOpponentTeam({super.key, required this.team});

  @override
  State<ViewOpponentTeam> createState() => _ViewOpponentTeamState();
}

class _ViewOpponentTeamState extends State<ViewOpponentTeam> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage(
                'assets/images/sports_icon.png',
              ),
              fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: const Color.fromARGB(87, 172, 172, 221),
          body: Stack(
            children: [
              ClipPath(
                clipper: ArcClipper(),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const RadialGradient(
                      colors: [
                        Color(0xff368EBF),
                        AppTheme.primaryColor,
                      ],
                      center: Alignment(-0.4, -0.8),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: AppTheme.secondaryYellowColor.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: const Offset(0, 70))
                    ],
                  ),
                  width: double.infinity,
                ),
              ),
              Positioned(
                  top: 0,
                  child: SizedBox(
                    width: Get.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 0, top: 30),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: BackButton(
                                color: Colors.white,
                              )),
                        ),
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Column(
                                  children: [
                                    Text(widget.team.name.capitalizeFirst,
                                        style: Get.textTheme.headlineLarge
                                            ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                    Text(
                                        'Captain: ${widget.team.players![0].name.capitalizeFirst}',
                                        style:
                                            Get.textTheme.bodyMedium?.copyWith(
                                          color: Colors.white,
                                        )),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(width: 15),
                                        Text(
                                            'Contact: +91 ${widget.team.players?[0].phoneNumber} ',
                                            style: Get.textTheme.bodyMedium
                                                ?.copyWith(
                                              color: Colors.white,
                                            )),
                                        const SizedBox(width: 5),
                                        IconButton(
                                          onPressed: () {
                                            HapticFeedback.heavyImpact();
                                            launchUrl(Uri.parse(
                                                'tel:+91${widget.team.players?[0].phoneNumber}'));
                                          },
                                          icon: const Icon(
                                            Icons.call,
                                            size: 15,
                                          ),
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: Get.height * 0.01),
                              Center(
                                child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: AppTheme.primaryColor,
                                            width: 1)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Stack(
                                        children: [
                                          CircleAvatar(
                                            radius: 49,
                                            backgroundImage: NetworkImage(
                                                toImageUrl(
                                                    widget.team.logo ?? "")),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                              SizedBox(height: Get.height * 0.02),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: Get.height * 0.63,
                                  child: ListView.separated(
                                      padding:
                                          const EdgeInsets.only(bottom: 30),
                                      shrinkWrap: true,
                                      itemCount: widget.team.players!.length,
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(height: 14),
                                      itemBuilder: (context, snapshot) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255),
                                              borderRadius:
                                                  BorderRadius.circular(19),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.3),
                                                    blurRadius: 20,
                                                    spreadRadius: 2,
                                                    offset: const Offset(0, 10))
                                              ]),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Row(children: [
                                              // const CircleAvatar(),
                                              const Spacer(),
                                              Text(
                                                widget.team.players![snapshot]
                                                    .name.capitalizeFirst,
                                                style: Get
                                                    .textTheme.headlineSmall
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w400),
                                              ),
                                              const SizedBox(width: 10),
                                              Image.asset(
                                                getAssetFromRole(widget.team
                                                    .players![snapshot].role),
                                                width: 20,
                                              ),
                                              const Spacer(),
                                            ]),
                                          ),
                                        );
                                      }),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }
}
