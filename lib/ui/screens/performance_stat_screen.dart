import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/data/controller/auth_controller.dart';
import 'package:gully_app/data/controller/team_controller.dart';
import 'package:gully_app/ui/theme/theme.dart';
import 'package:gully_app/ui/widgets/gradient_builder.dart';

import '../../utils/app_logger.dart';

class PerformanceStatScreen extends StatefulWidget {
  final String category;
  const PerformanceStatScreen({super.key, required this.category});

  @override
  State<PerformanceStatScreen> createState() => _PerformanceStatScreenState();
}

class _PerformanceStatScreenState extends State<PerformanceStatScreen>
    with SingleTickerProviderStateMixin {
  String innings = 'batting';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TeamController controller = Get.find<TeamController>();
    final authcontroller = Get.find<AuthController>();
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppTheme.darkYellowColor,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              isScrollable: true,
              tabs: const [
                Tab(text: 'Player Overview'),
                Tab(text: 'Statistics'),
                Tab(text: 'Tournaments'),
                Tab(text: 'Tournaments'),
                Tab(text: 'Tournaments'),
                Tab(text: 'Tournaments'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
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
                                child:
                                    Text('Tennis', textAlign: TextAlign.center),
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
                                padding: EdgeInsets.all(0.0),
                                child: Text(
                                  'Leather',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12),
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
                          future: controller.getMyPerformance(
                            userId: authcontroller.state!.id,
                            category: innings,
                          ),
                          builder: (context, snapshot) {
                            // if (snapshot.connectionState == ConnectionState.waiting) {
                            //   return const Center(child: CircularProgressIndicator());
                            // }
                            logger.d(
                                "My Performance Details:\n userId:${authcontroller.state!.id}\nMatchType:${widget.category}\nCategory:$innings ");
                            if (snapshot.hasError) {
                              return const Center(
                                child: Text(
                                  "Something went wrong",
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(
                                child: Text(
                                  "No data available",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              );
                            }
                            final performanceData = snapshot.data!;
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: performanceData.length,
                              itemBuilder: (context, index) {
                                final statKey =
                                    performanceData.keys.elementAt(index);
                                final statValues = performanceData[statKey];
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
                                          statValues['leather'].toString(),
                                          textAlign: TextAlign.center,
                                          style: _valueStyle(),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
  TextStyle _valueStyle() {
    return const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  }
}
