import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/ui/screens/edit_tournament_screen.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';

class ViewMatchupsScreen extends StatefulWidget {
  const ViewMatchupsScreen({super.key});

  @override
  State<ViewMatchupsScreen> createState() => _ViewMatchupsScreenState();
}

class _ViewMatchupsScreenState extends State<ViewMatchupsScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const EditTournamentScreen());
      },
      child: GradientBuilder(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Positioned(
                top: 0,
                child: SizedBox(
                  width: Get.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10, top: 30),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: BackButton(
                              color: Colors.white,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Get.width * 0.03,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text('View Matchups',
                                  style: Get.textTheme.headlineLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800)),
                            ),
                            SizedBox(height: Get.height * 0.05),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 23, vertical: 18),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            const CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  'https://i.pinimg.com/originals/70/52/1b/70521baac89be4d4cb2f223bbf67c974.png'),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              'CSK',
                                              style: Get.textTheme.headlineSmall
                                                  ?.copyWith(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        const Spacer(),
                                        Row(
                                          children: [
                                            Text(
                                              'KKR',
                                              style: Get.textTheme.headlineSmall
                                                  ?.copyWith(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            const SizedBox(width: 12),
                                            const CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  'https://i.pinimg.com/originals/c8/e9/e6/c8e9e65d1d2f9d2472dd64a875c5c238.jpg'),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: Get.height * 0.01),
                                    Center(
                                      child: Text('20/1',
                                          style: Get.textTheme.headlineLarge
                                              ?.copyWith(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w800)),
                                    ),
                                    SizedBox(height: Get.height * 0.01),
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                                text: TextSpan(
                                                    text: 'Overs: ',
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black),
                                                    children: [
                                                  TextSpan(
                                                      text: '13.2',
                                                      style: Get
                                                          .textTheme.bodyMedium
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))
                                                ])),
                                            RichText(
                                                text: TextSpan(
                                                    text: 'To Win: ',
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black),
                                                    children: [
                                                  TextSpan(
                                                    text: '311 OFF 21 Balls',
                                                    style: Get
                                                        .textTheme.bodyMedium
                                                        ?.copyWith(
                                                            color: Colors.black,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                ]))
                                          ],
                                        ),
                                        const Spacer(),
                                        Chip(
                                          label: Text(
                                            'View Full Screen',
                                            style: Get.textTheme.bodyMedium
                                                ?.copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10),
                                          ),
                                          side: BorderSide.none,
                                          backgroundColor:
                                              AppTheme.secondaryYellowColor,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
