import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/team_controller.dart';
import 'package:gully_app/data/model/challenge_match.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';

import '../../utils/app_logger.dart';

class ChallengePerformanceStatScreen extends StatefulWidget {
  final ChallengeMatchModel match;
  const ChallengePerformanceStatScreen({super.key, required this.match});

  @override
  State<ChallengePerformanceStatScreen> createState() =>
      _ChallengePerformanceStatScreenState();
}

class _ChallengePerformanceStatScreenState
    extends State<ChallengePerformanceStatScreen> {
  String innings = 'batting';

  @override
  void initState() {
    super.initState();
    //logger.d"ChallengePerformanceStatScreen initialized with match ID: ${widget.match.id}");
  }

  @override
  Widget build(BuildContext context) {
    TeamController controller = Get.find<TeamController>();
    return GradientBuilder(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('My Performance',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: [
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      setState(() {
                        innings = 'batting';
                      });
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: innings == 'batting'
                            ? AppTheme.darkYellowColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'Batting',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: innings == 'batting'
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      setState(() {
                        innings = 'bowling';
                      });
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: innings == 'bowling'
                            ? AppTheme.darkYellowColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'Bowling',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: innings == 'bowling'
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('STATS',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12)),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: VerticalDivider(
                            color: Colors.grey.shade300,
                            thickness: 1,
                            indent: 1,
                            endIndent: 2,
                          ),
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Tennis', textAlign: TextAlign.center),
                          ),
                        ),
                        // SizedBox(
                        //   height: 40,
                        //   child: VerticalDivider(
                        //     color: Colors.grey.shade300,
                        //     thickness: 1,
                        //     indent: 1,
                        //     endIndent: 2,
                        //   ),
                        // ),
                        // const Expanded(
                        //   child: Padding(
                        //     padding: EdgeInsets.all(0.0),
                        //     child: Text(
                        //       'Leather',
                        //       textAlign: TextAlign.center,
                        //       style: TextStyle(fontSize: 12),
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 40,
                        //   child: VerticalDivider(
                        //     color: Colors.grey.shade300,
                        //     thickness: 1,
                        //     indent: 1,
                        //     endIndent: 2,
                        //   ),
                        // ),
                        // const Expanded(
                        //   child: Padding(
                        //     padding: EdgeInsets.all(8.0),
                        //     child: Text('Fielding'),
                        //   ),
                        // ),
                      ],
                    ),
                    Divider(
                      height: 0,
                      color: Colors.grey.shade300,
                      thickness: 1,
                      indent: 1,
                      endIndent: 2,
                    ),
                    FutureBuilder<Map<String, dynamic>>(
                        future: controller.getChallengePerformance(
                            matchId: widget.match.id, type: innings),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            logger
                                .e("Error in FutureBuilder: ${snapshot.error}");
                            return const Padding(
                              padding: EdgeInsets.all(18.0),
                              child: Center(child: Text('Error fetching data')),
                            );
                          }
                          if (snapshot.data == null || snapshot.data!.isEmpty) {
                            logger.w("No performance data available");
                            return const Padding(
                              padding: EdgeInsets.all(18.0),
                              child: Center(child: Text('No data available')),
                            );
                          }
                          if (snapshot.data!.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(18.0),
                              child: Center(child: Text('No data available')),
                            );
                          }
                          final performanceData = snapshot.data!;
                          //logger.d"Performance data: $performanceData" );
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data?.length ?? 0,
                              itemBuilder: (builder, index) {
                                final statKey =
                                    performanceData.keys.elementAt(index);
                                final statValues = performanceData[statKey];
                                //logger.d"StatKet: $statValues" );
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          statKey.capitalize ?? '',
                                          textAlign: TextAlign.center,
                                          style: _valueStyle(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      child: VerticalDivider(
                                        color: Colors.grey.shade300,
                                        thickness: 1,
                                        indent: 1,
                                        endIndent: 2,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          statValues['tennis'].toString(),
                                          textAlign: TextAlign.center,
                                          style: _valueStyle(),
                                        ),
                                      ),
                                    ),
                                    // SizedBox(
                                    //   height: 40,
                                    //   child: VerticalDivider(
                                    //     color: Colors.grey.shade300,
                                    //     thickness: 1,
                                    //     indent: 1,
                                    //     endIndent: 2,
                                    //   ),
                                    // ),
                                    // Expanded(
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.all(8.0),
                                    //     child: Text(
                                    //       snapshot.data!.entries
                                    //           .elementAt(index)
                                    //           .value['leather']
                                    //           .toString(),
                                    //       textAlign: TextAlign.center,
                                    //       style: _valueStyle(),
                                    //     ),
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   height: 40,
                                    //   child: VerticalDivider(
                                    //     color: Colors.grey.shade300,
                                    //     thickness: 1,
                                    //     indent: 1,
                                    //     endIndent: 2,
                                    //   ),
                                    // ),
                                    // Expanded(
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.all(8.0),
                                    //     child: Text(
                                    //       '3',
                                    //       textAlign: TextAlign.center,
                                    //       style: _valueStyle(),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                );
                              });
                        })
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  TextStyle _valueStyle() {
    return const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  }
}
