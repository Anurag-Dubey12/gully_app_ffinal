import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gully_app/src/ui/screens/add_team.dart';
import 'package:gully_app/src/ui/screens/create_tournament_form_screen.dart';
import 'package:gully_app/src/ui/theme/theme.dart';
import 'package:gully_app/src/ui/widgets/primary_button.dart';

import '../widgets/arc_clipper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      child: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          drawer: Drawer(
            backgroundColor: Colors.transparent,
            child: Container(
              color: AppTheme.primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Get.bottomBarHeight / 2),
                    DecoratedBox(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          border: Border.all(
                              color: const Color.fromARGB(255, 142, 133, 133),
                              width: 2)),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                              'https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Bhavesh Pant',
                      style: Get.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 22),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'bhavesh.pant@nileegames.com',
                      style: Get.textTheme.labelMedium?.copyWith(
                          color: const Color.fromARGB(255, 200, 189, 189),
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
                  padding: const EdgeInsets.all(19.0),
                  child: PrimaryButton(
                    onTap: () {
                      Get.to(() => const CreateTournamentScreen());
                    },
                    title: 'Create Your Tournament',
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
                top: Get.statusBarHeight / 2.3,
                // left: 20,
                child: SizedBox(
                  // color: Colors.red,
                  width: Get.width,

                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: _TopHeader(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: Get.height * 0.10,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return SportsCard(
                                index: index,
                              );
                            },
                            padding: const EdgeInsets.only(left: 20),
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  width: 15,
                                ),
                            itemCount: 7),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: Get.height * 0.05,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return const TimeCard();
                            },
                            padding: const EdgeInsets.only(left: 20),
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  width: 0,
                                ),
                            itemCount: 7),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.all(18.0),
                          child: Text(
                            'Tournaments',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                        ),
                      ),
                      const FutureTournamentCard()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FutureTournamentCard extends StatelessWidget {
  const FutureTournamentCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          image: const DecorationImage(
              image: AssetImage(
                'assets/images/cricket_bat.png',
              ),
              alignment: Alignment.bottomLeft,
              scale: 1),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(0, 1))
          ],
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            const SizedBox(height: 7),
            Text(
              'Premier League | Cricket Tournament',
              style: Get.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppTheme.darkYellowColor),
            ),
            const SizedBox(height: 7),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date: 04 July 2023',
                    style: Get.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'Time Left: 5d:13h:5m:23s',
                    style: Get.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 17),
            Padding(
              padding: const EdgeInsets.only(right: 28),
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => const AddTeamScreen());
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            AppTheme.darkYellowColor)),
                    child: Text('Join Now',
                        style: Get.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w300, color: Colors.white))),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Text(
                        'Team: 7/10',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.info_outline_rounded,
                          color: Colors.grey, size: 18)
                    ],
                  ),
                  Text(
                    'Entry Fees: ₹900/-',
                    style: Get.textTheme.labelMedium,
                  )
                ],
              ),
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}

class TimeCard extends StatelessWidget {
  const TimeCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 90,
        // height: 8,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: const Offset(0, 1))
            ],
            borderRadius: BorderRadius.circular(20)),
        child: Center(
            child: Text(
          '04 July',
          style: Get.textTheme.labelMedium,
        )),
      ),
    );
  }
}

class SportsCard extends StatelessWidget {
  final int index;
  const SportsCard({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        decoration: BoxDecoration(
          color: index == 0 ? const Color(0xffDD6F50) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
                color: index == 0
                    ? AppTheme.secondaryYellowColor.withOpacity(0.3)
                    : Colors.black12,
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(0, 1))
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/cricket_icon.png',
                height: 45,
                color: index == 0 ? Colors.white : Colors.grey.shade400,
                width: 45,
              ),
              const SizedBox(height: 5),
              Text(
                'Cricket',
                style: TextStyle(
                    color: index == 0 ? Colors.white : Colors.grey,
                    fontSize: 14),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  const _TopHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bhavesh Pant',
                  style: Get.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 24,
                      fontStyle: FontStyle.italic),
                ),
                Text('Select Location',
                    style: Get.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white)),
              ],
            ),
          ],
        ),
        IconButton(
          icon: const Icon(
            Icons.menu,
            size: 30,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          color: Colors.white,
        )
      ],
    );
  }
}
