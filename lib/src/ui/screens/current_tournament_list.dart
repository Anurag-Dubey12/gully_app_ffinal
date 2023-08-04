import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/src/ui/screens/select_team.dart';
import '../theme/theme.dart';
import '../widgets/arc_clipper.dart';

class CurrentTournamentListScreen extends StatefulWidget {
  const CurrentTournamentListScreen({super.key});

  @override
  State<CurrentTournamentListScreen> createState() =>
      _CurrentTournamentListScreenState();
}

class _CurrentTournamentListScreenState
    extends State<CurrentTournamentListScreen> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage(
                'assets/images/sports_icon.png',
              ),
              fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(children: [
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
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 30, top: 30),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: BackButton(
                            color: Colors.white,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Get.width * 0.07,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Current Tournament',
                              style: Get.textTheme.headlineLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: Get.height * 0.02),
                          ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 18),
                              shrinkWrap: true,
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return const _TeamCard();
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
        ));
  }
}

class _TeamCard extends StatelessWidget {
  const _TeamCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const SelectOrganizeTeam());
      },
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: const Offset(0, 1))
            ],
            borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.05,
            vertical: Get.height * 0.02,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[200],
              ),
              const Spacer(),
              Text(
                'Black Panther',
                style: Get.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w300, fontSize: 19),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
