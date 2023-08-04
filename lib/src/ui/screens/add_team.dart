import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/src/ui/screens/view_team.dart';

import '../theme/theme.dart';
import '../widgets/arc_clipper.dart';
import '../widgets/primary_button.dart';

class AddTeamScreen extends StatefulWidget {
  const AddTeamScreen({super.key});

  @override
  State<AddTeamScreen> createState() => _AddTeamScreenState();
}

class _AddTeamScreenState extends State<AddTeamScreen> {
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
          bottomNavigationBar: Container(
            height: 90,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: const Offset(0, -1))
            ]),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 35.0, vertical: 19),
                  child: PrimaryButton(
                    onTap: () {
                      Get.to(() => const ViewTeam());
                    },
                    title: 'Add Player',
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.transparent,
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
                                child: Text('Add Team',
                                    style: Get.textTheme.headlineLarge
                                        ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(height: Get.height * 0.04),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Get.width * 0.07,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 5,
                                            spreadRadius: 2,
                                            offset: const Offset(0, 1))
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(28.0),
                                    child: Row(
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color:
                                                        AppTheme.primaryColor,
                                                    width: 1)),
                                            child: const Padding(
                                              padding: EdgeInsets.all(3.0),
                                              child: Stack(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 39,
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    right: 0,
                                                    child: CircleAvatar(
                                                      radius: 10,
                                                      backgroundColor: AppTheme
                                                          .secondaryYellowColor,
                                                      child: Icon(
                                                        Icons.edit,
                                                        color: Colors.white,
                                                        size: 15,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )),
                                        const SizedBox(width: 10),
                                        Text('Black Panther',
                                            style: Get.textTheme.headlineMedium
                                                ?.copyWith(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                        const Icon(
                                          Icons.edit,
                                          color: AppTheme.secondaryYellowColor,
                                          size: 18,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: Get.height * 0.02),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Text('Players',
                                    style: Get.textTheme.headlineMedium
                                        ?.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black26,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView.separated(
                                      padding:
                                          const EdgeInsets.only(bottom: 30),
                                      shrinkWrap: true,
                                      itemCount: 4,
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(height: 20),
                                      itemBuilder: (context, snapshot) {
                                        return InkWell(
                                          onTap: () {},
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    255, 255, 255, 255),
                                                borderRadius:
                                                    BorderRadius.circular(19)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(19.0),
                                              child: Row(children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Bob Odenkirk',
                                                      style: Get.textTheme
                                                          .titleMedium,
                                                    ),
                                                    const Text('+91 7855698346')
                                                  ],
                                                ),
                                                const Spacer(),
                                                const CircleAvatar(
                                                  // radius: 13,
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 71, 224, 79),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Icon(Icons.share),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                const CircleAvatar(
                                                  // radius: 13,
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 235, 17, 24),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Icon(Icons.cancel),
                                                  ),
                                                )
                                              ]),
                                            ),
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
